import { Controller, Get, Post, Patch, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { AddressesService } from './addresses.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { CreateAddressDto } from './dto/create-address.dto';
import { UpdateAddressDto } from './dto/update-address.dto';

@Controller('addresses')
@UseGuards(JwtAuthGuard)
export class AddressesController {
  constructor(private addressesService: AddressesService) {}

  @Post()
  create(@CurrentUser('id') userId: string, @Body() dto: CreateAddressDto) {
    return this.addressesService.create(userId, dto);
  }

  @Post('geocode')
  geocode(@Body() body: { address: string }) {
    return this.addressesService.geocode(body.address);
  }

  @Get()
  findAll(@CurrentUser('id') userId: string) {
    return this.addressesService.findAll(userId);
  }

  @Get(':id')
  findOne(@CurrentUser('id') userId: string, @Param('id') id: string) {
    return this.addressesService.findOne(id, userId);
  }

  @Patch(':id')
  update(@CurrentUser('id') userId: string, @Param('id') id: string, @Body() dto: UpdateAddressDto) {
    return this.addressesService.update(id, userId, dto);
  }

  @Patch(':id/default')
  setDefault(@CurrentUser('id') userId: string, @Param('id') id: string) {
    return this.addressesService.setDefault(id, userId);
  }

  @Delete(':id')
  remove(@CurrentUser('id') userId: string, @Param('id') id: string) {
    return this.addressesService.remove(id, userId);
  }
}
