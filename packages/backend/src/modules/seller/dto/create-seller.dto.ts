import { IsString, IsOptional, IsNumber } from 'class-validator';

export class CreateSellerDto {
  @IsString()
  shopName: string;

  @IsString()
  shopSlug: string;

  @IsOptional()
  @IsString()
  shopDescription?: string;

  @IsOptional()
  @IsString()
  logo?: string;

  @IsOptional()
  @IsString()
  banner?: string;
}
