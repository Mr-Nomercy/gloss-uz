import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateSellerDto } from './dto/create-seller.dto';
import { UpdateSellerDto } from './dto/update-seller.dto';
import { SubmitKycDto } from './dto/submit-kyc.dto';

@Injectable()
export class SellerService {
  constructor(private prisma: PrismaService) {}

  async createProfile(userId: string, dto: CreateSellerDto) {
    const existing = await this.prisma.sellerProfile.findUnique({ where: { userId } });
    if (existing) throw new ConflictException('Seller profile already exists');

    const slugExists = await this.prisma.sellerProfile.findUnique({ where: { shopSlug: dto.shopSlug } });
    if (slugExists) throw new ConflictException('Shop slug already taken');

    return this.prisma.sellerProfile.create({
      data: { ...dto, userId },
      include: { products: true },
    });
  }

  async getProfile(userId: string) {
    const profile = await this.prisma.sellerProfile.findUnique({
      where: { userId },
      include: { products: { where: { deletedAt: null }, orderBy: { createdAt: 'desc' }, take: 10 }, kycDocuments: { orderBy: { createdAt: 'desc' }, take: 5 } },
    });
    if (!profile) throw new NotFoundException('Seller profile not found');
    return profile;
  }

  async getPublicProfile(slug: string) {
    const profile = await this.prisma.sellerProfile.findUnique({
      where: { shopSlug: slug, isActive: true },
      include: { products: { where: { isActive: true, status: 'approved' }, take: 20 } },
    });
    if (!profile) throw new NotFoundException('Seller not found');
    return profile;
  }

  async updateProfile(userId: string, dto: UpdateSellerDto) {
    await this.getProfile(userId);
    return this.prisma.sellerProfile.update({
      where: { userId },
      data: dto,
    });
  }

  // KYC
  async submitKyc(userId: string, dto: SubmitKycDto) {
    const profile = await this.prisma.sellerProfile.findUnique({ where: { userId } });
    if (!profile) throw new NotFoundException('Create a seller profile first');
    const { sellerId: _, ...cleanDto } = dto;
    return this.prisma.kYCDocument.create({ data: { ...cleanDto, userId, sellerId: profile.id } });
  }

  async getKycStatus(userId: string) {
    return this.prisma.kYCDocument.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  // Dashboard stats
  async getDashboard(userId: string) {
    const profile = await this.getProfile(userId);
    const sellerId = profile.id;
    const [totalProducts, totalOrders, revenueAgg, recentOrders] = await Promise.all([
      this.prisma.product.count({ where: { sellerId, deletedAt: null } }),
      this.prisma.orderItem.count({ where: { sellerId } }),
      this.prisma.orderItem.aggregate({
        where: { sellerId, order: { status: 'completed' } },
        _sum: { totalPrice: true },
      }),
      this.prisma.orderItem.findMany({
        where: { sellerId },
        include: { order: true },
        orderBy: { id: 'desc' },
        take: 5,
      }),
    ]);
    return {
      ...profile,
      stats: {
        totalProducts,
        totalOrders,
        totalRevenue: revenueAgg._sum.totalPrice ?? 0,
        recentOrders,
      },
    };
  }
}
