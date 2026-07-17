import { IsString, IsOptional, IsNumber, IsBoolean } from 'class-validator';

export class CreateServiceDto {
  @IsString()
  serviceTypeId: string;

  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  nameRu?: string;

  @IsOptional()
  @IsString()
  nameEn?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsNumber()
  durationMinutes: number;

  @IsOptional()
  @IsNumber()
  minArea?: number;

  @IsOptional()
  @IsNumber()
  maxArea?: number;

  @IsString()
  basePrice: string;

  @IsOptional()
  @IsNumber()
  sortOrder?: number;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}
