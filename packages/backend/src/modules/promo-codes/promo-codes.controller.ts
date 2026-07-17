import { Controller, Get, Post, Patch, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { PromoCodesService } from './promo-codes.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { CreatePromoCodeDto } from './dto/create-promo-code.dto';
import { UpdatePromoCodeDto } from './dto/update-promo-code.dto';
import { ValidatePromoDto } from './dto/validate-promo.dto';

@Controller()
export class PromoCodesController {
  constructor(private promoCodesService: PromoCodesService) {}

  @Post('promo-codes')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  create(@Body() dto: CreatePromoCodeDto) {
    return this.promoCodesService.create(dto);
  }

  @Get('promo-codes')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  findAll() {
    return this.promoCodesService.findAll();
  }

  @Get('promo-codes/:id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  findOne(@Param('id') id: string) {
    return this.promoCodesService.findOne(id);
  }

  @Patch('promo-codes/:id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  update(@Param('id') id: string, @Body() dto: UpdatePromoCodeDto) {
    return this.promoCodesService.update(id, dto);
  }

  @Delete('promo-codes/:id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  remove(@Param('id') id: string) {
    return this.promoCodesService.remove(id);
  }

  @Post('promo-codes/validate')
  @UseGuards(JwtAuthGuard)
  validate(@Body() dto: ValidatePromoDto) {
    return this.promoCodesService.validate(dto);
  }
}
