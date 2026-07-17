import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { AuditService } from '../audit/audit.service';

@Injectable()
export class AdminService {
  constructor(
    private prisma: PrismaService,
    private auditService: AuditService,
  ) {}

  async listUsers(page = 1, limit = 20, search?: string, role?: string) {
    const skip = (page - 1) * limit;
    const where: any = { deletedAt: null };
    if (search) {
      where.OR = [
        { phone: { contains: search } },
        { fullName: { contains: search } },
        { email: { contains: search } },
      ];
    }
    if (role) {
      where.roles = { some: { role: { name: role } } };
    }
    const [users, total] = await Promise.all([
      this.prisma.user.findMany({
        where,
        skip,
        take: limit,
        include: { roles: { include: { role: true } } },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.user.count({ where }),
    ]);
    return { users, total, page, limit, totalPages: Math.ceil(total / limit) };
  }

  async getKycQueue() {
    return this.prisma.kYCDocument.findMany({
      where: { status: 'pending' },
      include: { user: { select: { id: true, phone: true, fullName: true } } },
      orderBy: { createdAt: 'asc' },
    });
  }

  async moderateKyc(documentId: string, status: 'approved' | 'rejected', reviewedBy: string, rejectionReason?: string) {
    const doc = await this.prisma.kYCDocument.findUnique({ where: { id: documentId } });
    if (!doc) throw new NotFoundException('KYC document not found');
    return this.prisma.kYCDocument.update({
      where: { id: documentId },
      data: { status, reviewedBy, reviewedAt: new Date(), rejectionReason },
    });
  }

  async moderateProduct(productId: string, status: 'approved' | 'rejected', rejectionReason?: string) {
    const product = await this.prisma.product.findUnique({ where: { id: productId } });
    if (!product) throw new NotFoundException('Product not found');
    return this.prisma.product.update({
      where: { id: productId },
      data: { status, rejectionReason },
    });
  }

  async getAuditLogs(params: {
    page?: number;
    limit?: number;
    role?: string;
    action?: string;
    entity?: string;
    userId?: string;
    startDate?: string;
    endDate?: string;
  }) {
    return this.auditService.findAll(params);
  }

  async getStats() {
    const [
      totalUsers,
      totalProviders,
      totalSellers,
      totalCouriers,
      totalOrders,
      totalProducts,
      pendingKyc,
    ] = await Promise.all([
      this.prisma.user.count({ where: { deletedAt: null } }),
      this.prisma.userRole.count({ where: { role: { name: 'provider' } } }),
      this.prisma.userRole.count({ where: { role: { name: 'seller' } } }),
      this.prisma.userRole.count({ where: { role: { name: 'courier' } } }),
      this.prisma.order.count(),
      this.prisma.product.count(),
      this.prisma.kYCDocument.count({ where: { status: 'pending' } }),
    ]);
    return { totalUsers, totalProviders, totalSellers, totalCouriers, totalOrders, totalProducts, pendingKyc };
  }
}
