import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PERMISSIONS_KEY } from '../decorators/permissions.decorator';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class PermissionsGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const requiredPermissions = this.reflector.getAllAndOverride<string[]>(PERMISSIONS_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!requiredPermissions) return true;

    const { user } = context.switchToHttp().getRequest();
    if (!user) throw new ForbiddenException();

    const userRoles = await this.prisma.userRole.findMany({
      where: { userId: user.id },
      include: {
        role: {
          include: {
            rolePermissions: {
              include: { permission: true },
            },
          },
        },
      },
    });

    const userPermissions = new Set<string>();
    for (const ur of userRoles) {
      for (const rp of ur.role.rolePermissions) {
        userPermissions.add(`${rp.permission.resource}:${rp.permission.action}`);
      }
    }

    const hasAll = requiredPermissions.every((p) => userPermissions.has(p));
    if (!hasAll) throw new ForbiddenException('Missing required permissions');
    return true;
  }
}
