import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as argon2 from 'argon2';
import { PrismaService } from '../../prisma/prisma.service';
import { UsersService } from '../users/users.service';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private config: ConfigService,
    private usersService: UsersService,
  ) {}

  async register(dto: {
    phone: string;
    password: string;
    fullName?: string;
    roles?: string[];
    acceptedTos: boolean;
    acceptedPrivacyPolicy: boolean;
  }) {
    if (!dto.acceptedTos || !dto.acceptedPrivacyPolicy) {
      throw new BadRequestException('You must accept Terms of Service and Privacy Policy');
    }

    const existing = await this.usersService.findByPhone(dto.phone);
    if (existing) throw new ConflictException('Phone already registered');

    const passwordHash = await argon2.hash(dto.password);
    const roleNames = dto.roles?.length ? dto.roles : ['client'];

    const user = await this.prisma.user.create({
      data: {
        phone: dto.phone,
        passwordHash,
        fullName: dto.fullName,
        roles: {
          create: await Promise.all(
            roleNames.map(async (name) => {
              const role = await this.prisma.role.findUnique({ where: { name } });
              if (!role) throw new BadRequestException(`Role ${name} not found`);
              return { roleId: role.id };
            }),
          ),
        },
        userConsents: {
          create: [
            { type: 'tos_v1', granted: dto.acceptedTos },
            { type: 'privacy_policy_v1', granted: dto.acceptedPrivacyPolicy },
            { type: 'data_processing', granted: true },
          ],
        },
      },
      include: { roles: { include: { role: true } }, userConsents: true },
    });

    return this.generateTokens(user);
  }

  async login(phone: string, password: string) {
    const user = await this.usersService.findByPhone(phone);
    if (!user) throw new UnauthorizedException('Invalid credentials');

    const valid = await argon2.verify(user.passwordHash, password);
    if (!valid) throw new UnauthorizedException('Invalid credentials');

    return this.generateTokens(user);
  }

  async refresh(refreshToken: string) {
    try {
      const payload = this.jwtService.verify(refreshToken, {
        secret: this.config.get<string>('JWT_REFRESH_SECRET'),
      });

      const stored = await this.prisma.refreshToken.findUnique({
        where: { token: refreshToken },
      });
      if (!stored || stored.revokedAt) {
        throw new UnauthorizedException('Token revoked');
      }

      await this.prisma.refreshToken.update({
        where: { id: stored.id },
        data: { revokedAt: new Date() },
      });

      const user = await this.usersService.findById(payload.sub);
      return this.generateTokens(user);
    } catch {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  async forgotPassword(phone: string) {
    const user = await this.usersService.findByPhone(phone);
    if (!user) return { message: 'If the phone exists, an OTP will be sent' };

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const otpHash = await argon2.hash(otp);
    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        resetOtp: otpHash,
        resetOtpExpires: new Date(Date.now() + 5 * 60 * 1000),
      },
    });

    // TODO: Send OTP via SMS provider
    console.log(`[DEV] OTP for ${phone}: ${otp}`);

    return { message: 'OTP sent to phone' };
  }

  async resetPassword(phone: string, otp: string, newPassword: string) {
    const user = await this.usersService.findByPhone(phone);
    if (!user || !user.resetOtp || !user.resetOtpExpires) {
      throw new BadRequestException('No OTP was requested');
    }

    if (new Date() > user.resetOtpExpires) {
      throw new BadRequestException('OTP has expired');
    }

    const valid = await argon2.verify(user.resetOtp, otp);
    if (!valid) throw new BadRequestException('Invalid OTP');

    const passwordHash = await argon2.hash(newPassword);
    await this.prisma.user.update({
      where: { id: user.id },
      data: { passwordHash, resetOtp: null, resetOtpExpires: null },
    });

    // Revoke all refresh tokens
    await this.prisma.refreshToken.updateMany({
      where: { userId: user.id, revokedAt: null },
      data: { revokedAt: new Date() },
    });

    return { message: 'Password reset successfully' };
  }

  async changePassword(userId: string, currentPassword: string, newPassword: string) {
    const user = await this.usersService.findById(userId);
    const valid = await argon2.verify(user.passwordHash, currentPassword);
    if (!valid) throw new BadRequestException('Current password is incorrect');

    const passwordHash = await argon2.hash(newPassword);
    await this.prisma.user.update({
      where: { id: userId },
      data: { passwordHash },
    });

    return { message: 'Password changed successfully' };
  }

  async logout(userId: string) {
    await this.prisma.refreshToken.updateMany({
      where: { userId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
    return { message: 'Logged out' };
  }

  private async generateTokens(user: any) {
    const payload = { sub: user.id, phone: user.phone, roles: user.roles.map((ur) => ur.role.name) };

    const accessToken = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, {
      secret: this.config.get<string>('JWT_REFRESH_SECRET'),
      expiresIn: this.config.get<string>('JWT_REFRESH_EXPIRY', '7d'),
    });

    await this.prisma.refreshToken.create({
      data: {
        userId: user.id,
        token: refreshToken,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
      },
    });

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        phone: user.phone,
        fullName: user.fullName,
        roles: user.roles.map((ur) => ur.role.name),
      },
    };
  }
}
