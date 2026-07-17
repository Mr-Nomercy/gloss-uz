import { Controller, Get, Post, Patch, Delete, Body, Param, Query, UseGuards, ParseIntPipe } from '@nestjs/common';
import { ProductsService } from './products.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';

@Controller('products')
export class ProductsController {
  constructor(private productsService: ProductsService) {}

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('seller', 'admin', 'super_admin')
  create(@CurrentUser('id') userId: string, @Body() dto: CreateProductDto) {
    return this.productsService.create(userId, dto);
  }

  @Get()
  @Public()
  findAll(
    @Query('sellerId') sellerId?: string,
    @Query('categoryId') categoryId?: string,
    @Query('search') search?: string,
    @Query('isActive') isActive?: string,
    @Query('status') status?: string,
    @Query('page', new ParseIntPipe({ optional: true })) page?: number,
    @Query('limit', new ParseIntPipe({ optional: true })) limit?: number,
    @Query('sort') sort?: string,
  ) {
    return this.productsService.findAll({
      sellerId, categoryId, search, status,
      isActive: isActive !== undefined ? isActive === 'true' : undefined,
      page, limit, sort,
    });
  }

  @Get(':id')
  @Public()
  findOne(@Param('id') id: string) {
    return this.productsService.findOne(id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('seller', 'admin', 'super_admin')
  update(
    @Param('id') id: string,
    @CurrentUser() user: any,
    @Body() dto: UpdateProductDto,
  ) {
    return this.productsService.update(id, user.id, dto, user.roles?.some((r: string) => ['admin', 'super_admin'].includes(r)));
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('seller', 'admin', 'super_admin')
  remove(
    @Param('id') id: string,
    @CurrentUser() user: any,
  ) {
    return this.productsService.remove(id, user.id, user.roles?.some((r: string) => ['admin', 'super_admin'].includes(r)));
  }

  @Post(':id/images')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('seller', 'admin', 'super_admin')
  addImage(@Param('id') id: string, @CurrentUser('id') userId: string, @Body() body: { url: string; isPrimary?: boolean }) {
    return this.productsService.addImage(id, userId, body.url, body.isPrimary);
  }
}
