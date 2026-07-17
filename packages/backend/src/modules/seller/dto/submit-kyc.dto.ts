import { IsString, IsOptional, IsIn } from 'class-validator';

export class SubmitKycDto {
  @IsString()
  @IsIn(['passport', 'id_card', 'driver_license'])
  type: string;

  @IsString()
  fileUrl: string;

  @IsOptional()
  @IsString()
  sellerId?: string;
}
