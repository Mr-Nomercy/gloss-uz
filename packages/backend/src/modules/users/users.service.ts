import { Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findById(id: string) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      include: {
        roles: { include: { role: true } },
        addresses: true,
        sellerProfile: true,
      },
    });
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async findByPhone(phone: string) {
    return this.prisma.user.findUnique({
      where: { phone },
      include: {
        roles: { include: { role: true } },
      },
    });
  }

  async update(id: string, data: UpdateUserDto) {
    return this.prisma.user.update({
      where: { id },
      data,
    });
  }

  async findAll(page: number, limit: number, search?: string) {
    const where: Prisma.UserWhereInput = {};
    if (search) {
      where.OR = [
        { phone: { contains: search } },
        { fullName: { contains: search, mode: 'insensitive' } },
      ];
    }
    const [users, total] = await Promise.all([
      this.prisma.user.findMany({
        where,
        skip: (page - 1) * limit,
        take: limit,
        include: { roles: { include: { role: true } } },
      }),
      this.prisma.user.count({ where }),
    ]);
    return { data: users, total, page, limit, totalPages: Math.ceil(total / limit) };
  }

  async findByRole(roleName: string) {
    return this.prisma.user.findMany({
      where: {
        roles: {
          some: {
            role: { name: roleName },
          },
        },
      },
      include: {
        roles: { include: { role: true } },
      },
    });
  }

  async softDelete(id: string) {
    return this.prisma.user.update({
      where: { id },
      data: { deletedAt: new Date() },
    });
  }

  async uploadAvatar(userId: string, fileUrl: string) {
    return this.prisma.user.update({
      where: { id: userId },
      data: { avatar: fileUrl },
    });
  }
}
