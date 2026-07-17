import { IsString, IsOptional, IsNumber } from 'class-validator';

export class ValidatePromoDto {
  @IsString()
  code: string;

  @IsOptional()
  @IsNumber()
  orderAmount?: number;

  @IsOptional()
  @IsString()
  orderType?: string;
}
