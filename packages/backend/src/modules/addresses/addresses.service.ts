import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateAddressDto } from './dto/create-address.dto';
import { UpdateAddressDto } from './dto/update-address.dto';

@Injectable()
export class AddressesService {
  constructor(private prisma: PrismaService) {}

  async create(userId: string, dto: CreateAddressDto) {
    if (dto.isDefault) {
      await this.prisma.address.updateMany({
        where: { userId, isDefault: true },
        data: { isDefault: false },
      });
    }
    return this.prisma.address.create({
      data: { ...dto, userId },
    });
  }

  // Geocoding placeholder — integrate Yandex Geocoder API
  // Takes an address string and returns { lat, lng }
  // TODO: Replace with actual Yandex Geocoder HTTP API call
  async geocode(addressLine: string): Promise<{ lat: number; lng: number } | null> {
    // In production: call Yandex Geocoder API with addressLine
    // Return coordinates for the address
    return null;
  }

  async findAll(userId: string) {
    return this.prisma.address.findMany({
      where: { userId },
      orderBy: [{ isDefault: 'desc' }, { createdAt: 'desc' }],
    });
  }

  async findOne(id: string, userId: string) {
    const address = await this.prisma.address.findFirst({
      where: { id, userId },
    });
    if (!address) throw new NotFoundException('Address not found');
    return address;
  }

  async update(id: string, userId: string, dto: UpdateAddressDto) {
    await this.findOne(id, userId);
    if (dto.isDefault) {
      await this.prisma.address.updateMany({
        where: { userId, isDefault: true, id: { not: id } },
        data: { isDefault: false },
      });
    }
    return this.prisma.address.update({
      where: { id },
      data: dto,
    });
  }

  async setDefault(id: string, userId: string) {
    await this.findOne(id, userId);
    await this.prisma.address.updateMany({
      where: { userId, isDefault: true },
      data: { isDefault: false },
    });
    return this.prisma.address.update({
      where: { id },
      data: { isDefault: true },
    });
  }

  async remove(id: string, userId: string) {
    await this.findOne(id, userId);
    return this.prisma.address.delete({
      where: { id },
    });
  }
}
