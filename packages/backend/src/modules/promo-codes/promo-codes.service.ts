import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreatePromoCodeDto } from './dto/create-promo-code.dto';
import { UpdatePromoCodeDto } from './dto/update-promo-code.dto';
import { ValidatePromoDto } from './dto/validate-promo.dto';

@Injectable()
export class PromoCodesService {
  constructor(private prisma: PrismaService) {}

  async create(dto: CreatePromoCodeDto) {
    return this.prisma.promoCode.create({
      data: {
        ...dto,
        startsAt: dto.startsAt ? new Date(dto.startsAt) : undefined,
        expiresAt: dto.expiresAt ? new Date(dto.expiresAt) : undefined,
      },
    });
  }

  async findAll() {
    return this.prisma.promoCode.findMany({ orderBy: { createdAt: 'desc' } });
  }

  async findOne(id: string) {
    const promo = await this.prisma.promoCode.findUnique({ where: { id } });
    if (!promo) throw new NotFoundException('Promo code not found');
    return promo;
  }

  async update(id: string, dto: UpdatePromoCodeDto) {
    await this.findOne(id);
    return this.prisma.promoCode.update({
      where: { id },
      data: {
        ...dto,
        startsAt: dto.startsAt ? new Date(dto.startsAt) : undefined,
        expiresAt: dto.expiresAt ? new Date(dto.expiresAt) : undefined,
      },
    });
  }

  async remove(id: string) {
    await this.findOne(id);
    return this.prisma.promoCode.delete({ where: { id } });
  }

  async validate(dto: ValidatePromoDto) {
    const promo = await this.prisma.promoCode.findUnique({
      where: { code: dto.code },
    });
    if (!promo) throw new BadRequestException('Promo code not found');
    if (!promo.isActive) throw new BadRequestException('Promo code is inactive');
    if (promo.expiresAt && new Date() > promo.expiresAt) throw new BadRequestException('Promo code has expired');
    if (promo.startsAt && new Date() < promo.startsAt) throw new BadRequestException('Promo code is not yet active');
    if (promo.usageLimit && promo.usedCount >= promo.usageLimit) throw new BadRequestException('Promo code usage limit reached');
    if (promo.appliesTo !== 'all' && dto.orderType && promo.appliesTo !== dto.orderType) {
      throw new BadRequestException(`Promo code applies to ${promo.appliesTo} orders only`);
    }
    if (dto.orderAmount && promo.minOrderAmount && dto.orderAmount < Number(promo.minOrderAmount)) {
      throw new BadRequestException(`Minimum order amount is ${promo.minOrderAmount}`);
    }

    let discount = 0;
    if (promo.type === 'percentage') {
      discount = (dto.orderAmount ?? 0) * Number(promo.value) / 100;
      if (promo.maxDiscount && discount > Number(promo.maxDiscount)) {
        discount = Number(promo.maxDiscount);
      }
    } else if (promo.type === 'fixed_amount') {
      discount = Number(promo.value);
    }

    await this.prisma.promoCode.update({
      where: { id: promo.id },
      data: { usedCount: { increment: 1 } },
    });

    return {
      valid: true,
      promoCode: promo.code,
      type: promo.type,
      discount,
      description: promo.type === 'percentage' ? `${promo.value}% off` : `${promo.value} UZS off`,
    };
  }
}
