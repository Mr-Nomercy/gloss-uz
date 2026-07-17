import { IsString, IsOptional, IsNumber, IsBoolean, Min } from 'class-validator';

export class CreatePromoCodeDto {
  @IsString()
  code: string;

  @IsString()
  type: string;

  @IsString()
  value: string;

  @IsOptional()
  @IsString()
  minOrderAmount?: string;

  @IsOptional()
  @IsString()
  maxDiscount?: string;

  @IsOptional()
  @IsNumber()
  @Min(1)
  usageLimit?: number;

  @IsOptional()
  @IsString()
  appliesTo?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @IsOptional()
  @IsString()
  startsAt?: string;

  @IsOptional()
  @IsString()
  expiresAt?: string;
}
