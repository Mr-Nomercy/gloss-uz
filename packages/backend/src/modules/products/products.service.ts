import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';

@Injectable()
export class ProductsService {
  constructor(private prisma: PrismaService) {}

  async create(userId: string, dto: CreateProductDto) {
    const profile = await this.prisma.sellerProfile.findUnique({ where: { userId } });
    if (!profile) throw new ForbiddenException('You must have a seller profile to create products');
    const sellerId = profile.id;
    const { variants, ...productData } = dto;
    return this.prisma.product.create({
      data: {
        ...productData,
        sellerId,
        variants: variants?.length ? {
          create: variants.map(v => ({
            name: v.name,
            sku: v.sku,
            price: v.price,
            stockQty: v.stockQty ?? 0,
            sortOrder: v.sortOrder ?? 0,
          })),
        } : undefined,
      },
      include: { variants: true, images: true, category: true },
    });
  }

  async findAll(params: {
    sellerId?: string;
    categoryId?: string;
    search?: string;
    isActive?: boolean;
    status?: string;
    page?: number;
    limit?: number;
    sort?: string;
  }) {
    const { sellerId, categoryId, search, isActive, status, page = 1, limit = 20, sort } = params;
    const skip = (page - 1) * limit;
    const where: any = { deletedAt: null };

    if (sellerId) where.sellerId = sellerId;
    if (categoryId) where.categoryId = categoryId;
    if (isActive !== undefined) where.isActive = isActive;
    if (status) where.status = status;
    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
        { brand: { contains: search, mode: 'insensitive' } },
        { searchText: { contains: search, mode: 'insensitive' } },
      ];
    }

    let orderBy: any = { createdAt: 'desc' };
    if (sort === 'price_asc') orderBy = { basePrice: 'asc' };
    else if (sort === 'price_desc') orderBy = { basePrice: 'desc' };
    else if (sort === 'name') orderBy = { name: 'asc' };
    else if (sort === 'popular') orderBy = { totalSold: 'desc' };
    else if (sort === 'rating') orderBy = { rating: 'desc' };
    else if (sort === 'newest') orderBy = { createdAt: 'desc' };

    const [products, total] = await Promise.all([
      this.prisma.product.findMany({
        where,
        skip,
        take: limit,
        include: { variants: { where: { isActive: true } }, images: { where: { isPrimary: true } }, category: true },
        orderBy,
      }),
      this.prisma.product.count({ where }),
    ]);
    return { products, total, page, limit, totalPages: Math.ceil(total / limit) };
  }

  async findOne(id: string) {
    const product = await this.prisma.product.findUnique({
      where: { id },
      include: {
        variants: { where: { isActive: true }, orderBy: { sortOrder: 'asc' } },
        images: { orderBy: { sortOrder: 'asc' } },
        category: true,
        seller: { select: { id: true, shopName: true, shopSlug: true, logo: true, rating: true } },
      },
    });
    if (!product) throw new NotFoundException('Product not found');
    return product;
  }

  async update(id: string, userId: string, dto: UpdateProductDto, isAdmin = false) {
    const product = await this.findOne(id);
    if (product.sellerId !== userId && !isAdmin) {
      throw new ForbiddenException('You can only update your own products');
    }
    const { variants, ...productData } = dto;
    const updateData: any = { ...productData };
    if (variants) {
      const existing = await this.prisma.productVariant.findMany({ where: { productId: id } });
      const existingSkuMap = new Map(existing.filter(v => v.sku).map(v => [v.sku, v]));
      const incomingSkus = new Set<string>();
      for (const v of variants) {
        if (v.sku && existingSkuMap.has(v.sku)) {
          await this.prisma.productVariant.update({ where: { id: existingSkuMap.get(v.sku)!.id }, data: v });
        } else {
          await this.prisma.productVariant.create({ data: { ...v, productId: id } });
        }
        if (v.sku) incomingSkus.add(v.sku);
      }
      const toDelete = existing.filter(v => v.sku && !incomingSkus.has(v.sku));
      if (toDelete.length) {
        await this.prisma.productVariant.deleteMany({ where: { id: { in: toDelete.map(v => v.id) } } });
      }
    }
    return this.prisma.product.update({
      where: { id },
      data: updateData,
      include: { variants: true, images: true, category: true },
    });
  }

  async addImage(productId: string, userId: string, url: string, isPrimary?: boolean) {
    const product = await this.findOne(productId);
    const isAdmin = false; // Only sellers/admins can add images; checked in service
    if (product.sellerId !== userId && !isAdmin) {
      throw new ForbiddenException('You can only add images to your own products');
    }
    if (isPrimary) {
      await this.prisma.productImage.updateMany({
        where: { productId, isPrimary: true },
        data: { isPrimary: false },
      });
    }
    return this.prisma.productImage.create({
      data: { productId, url, isPrimary: isPrimary ?? false },
    });
  }

  async remove(id: string, userId: string, isAdmin = false) {
    const product = await this.findOne(id);
    if (product.sellerId !== userId && !isAdmin) {
      throw new ForbiddenException('You can only delete your own products');
    }
    return this.prisma.product.update({
      where: { id },
      data: { deletedAt: new Date(), isActive: false },
    });
  }
}
