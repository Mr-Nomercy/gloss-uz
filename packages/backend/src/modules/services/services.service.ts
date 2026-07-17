import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateServiceTypeDto } from './dto/create-service-type.dto';
import { UpdateServiceTypeDto } from './dto/update-service-type.dto';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';

@Injectable()
export class ServicesService {
  constructor(private prisma: PrismaService) {}

  async createType(dto: CreateServiceTypeDto) {
    return this.prisma.serviceType.create({ data: dto });
  }

  async findAllTypes() {
    return this.prisma.serviceType.findMany({
      where: { isActive: true },
      include: {
        services: { where: { isActive: true }, include: { pricings: true, images: true } },
        images: true,
      },
      orderBy: { sortOrder: 'asc' },
    });
  }

  async findOneType(id: string) {
    const type = await this.prisma.serviceType.findUnique({
      where: { id },
      include: { services: { where: { isActive: true }, include: { pricings: true, images: true } }, images: true },
    });
    if (!type) throw new NotFoundException('Service type not found');
    return type;
  }

  async updateType(id: string, dto: UpdateServiceTypeDto) {
    await this.findOneType(id);
    return this.prisma.serviceType.update({ where: { id }, data: dto });
  }

  async removeType(id: string) {
    await this.findOneType(id);
    const serviceCount = await this.prisma.service.count({ where: { serviceTypeId: id } });
    if (serviceCount > 0) {
      return this.prisma.serviceType.update({
        where: { id },
        data: { isActive: false },
      });
    }
    return this.prisma.serviceType.delete({ where: { id } });
  }

  async create(dto: CreateServiceDto) {
    return this.prisma.service.create({
      data: { ...dto },
      include: { pricings: true, images: true },
    });
  }

  async findAll(serviceTypeId?: string) {
    const where: any = { isActive: true };
    if (serviceTypeId) where.serviceTypeId = serviceTypeId;
    return this.prisma.service.findMany({
      where,
      include: { pricings: true, images: true, serviceType: true },
      orderBy: { sortOrder: 'asc' },
    });
  }

  async findOne(id: string) {
    const service = await this.prisma.service.findUnique({
      where: { id },
      include: { pricings: true, images: true, serviceType: true },
    });
    if (!service) throw new NotFoundException('Service not found');
    return service;
  }

  async calculatePrice(serviceId: string, area?: number, extras?: Record<string, boolean>) {
    const service = await this.findOne(serviceId);
    let basePrice = Number(service.basePrice);

    if (area && service.pricings.length > 0) {
      const matching = service.pricings.find(p => {
        const from = p.areaFrom ?? 0;
        const to = p.areaTo ?? Infinity;
        return area >= from && area <= to;
      });
      if (matching) {
        if (matching.pricePerSqm) {
          basePrice = Number(matching.pricePerSqm) * area;
        } else if (matching.fixedPrice) {
          basePrice = Number(matching.fixedPrice);
        }
      }
    }

    let extrasTotal = 0;
    if (extras && service.pricings.length > 0) {
      const pricing = service.pricings[0];
      if (pricing.extraOptions && typeof pricing.extraOptions === 'object') {
        const options = pricing.extraOptions as Record<string, number>;
        for (const [key, enabled] of Object.entries(extras)) {
          if (enabled && options[key]) {
            extrasTotal += options[key];
          }
        }
      }
    }

    const total = basePrice + extrasTotal;
    return {
      serviceId,
      serviceName: service.name,
      basePrice,
      extrasTotal,
      total,
      area,
      extras,
      estimatedDuration: service.durationMinutes,
    };
  }

  async addImage(serviceId: string, url: string, isPrimary?: boolean) {
    if (isPrimary) {
      await this.prisma.serviceImage.updateMany({
        where: { serviceId, isPrimary: true },
        data: { isPrimary: false },
      });
    }
    return this.prisma.serviceImage.create({
      data: { serviceId, url, isPrimary: isPrimary ?? false },
    });
  }

  async updateService(id: string, dto: UpdateServiceDto) {
    await this.findOne(id);
    return this.prisma.service.update({ where: { id }, data: dto });
  }

  async removeService(id: string) {
    await this.findOne(id);
    try {
      return await this.prisma.service.delete({ where: { id } });
    } catch (e) {
      if (e instanceof Prisma.PrismaClientKnownRequestError && e.code === 'P2003') {
        // Soft-delete instead if FK constraint fails
        return this.prisma.service.update({ where: { id }, data: { isActive: false } });
      }
      throw e;
    }
  }

  async removeImage(imageId: string) {
    try {
      return await this.prisma.serviceImage.delete({ where: { id: imageId } });
    } catch (e) {
      if (e instanceof Prisma.PrismaClientKnownRequestError && e.code === 'P2003') {
        throw new BadRequestException('Image is in use and cannot be deleted');
      }
      throw e;
    }
  }
}
