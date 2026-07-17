import { Controller, Get, Post, Patch, Delete, Body, Param, Query, UseGuards, BadRequestException } from '@nestjs/common';
import { ServicesService } from './services.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { CreateServiceTypeDto } from './dto/create-service-type.dto';
import { UpdateServiceTypeDto } from './dto/update-service-type.dto';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';

@Controller()
export class ServicesController {
  constructor(private servicesService: ServicesService) {}

  @Post('service-types')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  createType(@Body() dto: CreateServiceTypeDto) {
    return this.servicesService.createType(dto);
  }

  @Get('service-types')
  @Public()
  findAllTypes() {
    return this.servicesService.findAllTypes();
  }

  @Get('service-types/:id')
  @Public()
  findOneType(@Param('id') id: string) {
    return this.servicesService.findOneType(id);
  }

  @Patch('service-types/:id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  updateType(@Param('id') id: string, @Body() dto: UpdateServiceTypeDto) {
    return this.servicesService.updateType(id, dto);
  }

  @Delete('service-types/:id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  removeType(@Param('id') id: string) {
    return this.servicesService.removeType(id);
  }

  @Post('services')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  create(@Body() dto: CreateServiceDto) {
    return this.servicesService.create(dto);
  }

  @Get('services')
  @Public()
  findAll(@Query('serviceTypeId') serviceTypeId?: string) {
    return this.servicesService.findAll(serviceTypeId);
  }

  @Get('services/:id')
  @Public()
  findOne(@Param('id') id: string) {
    return this.servicesService.findOne(id);
  }

  @Patch('services/:id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  updateService(@Param('id') id: string, @Body() dto: UpdateServiceDto) {
    return this.servicesService.updateService(id, dto);
  }

  @Delete('services/:id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  removeService(@Param('id') id: string) {
    return this.servicesService.removeService(id);
  }

  @Get('services/:id/price')
  @Public()
  calculatePrice(
    @Param('id') id: string,
    @Query('area') area?: string,
    @Query('extras') extras?: string,
  ) {
    let parsedExtras: Record<string, boolean> | undefined;
    if (extras) {
      try { parsedExtras = JSON.parse(extras); }
      catch { throw new BadRequestException('Invalid extras JSON format'); }
    }
    return this.servicesService.calculatePrice(id, area ? parseFloat(area) : undefined, parsedExtras);
  }

  @Post('services/:id/images')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  addImage(@Param('id') id: string, @Body() body: { url: string; isPrimary?: boolean }) {
    return this.servicesService.addImage(id, body.url, body.isPrimary);
  }

  @Delete('service-images/:id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  removeImage(@Param('id') id: string) {
    return this.servicesService.removeImage(id);
  }
}
