import { Controller, Get, Post, Patch, Body, Param, UseGuards } from '@nestjs/common';
import { SellerService } from './seller.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { CreateSellerDto } from './dto/create-seller.dto';
import { UpdateSellerDto } from './dto/update-seller.dto';
import { SubmitKycDto } from './dto/submit-kyc.dto';

@Controller('seller')
export class SellerController {
  constructor(private sellerService: SellerService) {}

  @Post('profile')
  @UseGuards(JwtAuthGuard)
  createProfile(@CurrentUser('id') userId: string, @Body() dto: CreateSellerDto) {
    return this.sellerService.createProfile(userId, dto);
  }

  @Get('profile')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('seller', 'admin', 'super_admin')
  getProfile(@CurrentUser('id') userId: string) {
    return this.sellerService.getProfile(userId);
  }

  @Patch('profile')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('seller', 'admin', 'super_admin')
  updateProfile(@CurrentUser('id') userId: string, @Body() dto: UpdateSellerDto) {
    return this.sellerService.updateProfile(userId, dto);
  }

  @Get('dashboard')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('seller', 'admin', 'super_admin')
  getDashboard(@CurrentUser('id') userId: string) {
    return this.sellerService.getDashboard(userId);
  }

  @Post('kyc')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('seller', 'admin', 'super_admin')
  submitKyc(@CurrentUser('id') userId: string, @Body() dto: SubmitKycDto) {
    return this.sellerService.submitKyc(userId, dto);
  }

  @Get('kyc')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('seller', 'admin', 'super_admin')
  getKycStatus(@CurrentUser('id') userId: string) {
    return this.sellerService.getKycStatus(userId);
  }

  @Get(':slug')
  @Public()
  getPublicProfile(@Param('slug') slug: string) {
    return this.sellerService.getPublicProfile(slug);
  }
}
