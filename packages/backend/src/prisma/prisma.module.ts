import { Module, Global } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaService } from './prisma.service';
import { PrismaEncryptionMiddleware } from './prisma-encryption.middleware';
import { EncryptionModule } from '../common/encryption/encryption.module';

@Global()
@Module({
  imports: [ConfigModule, EncryptionModule],
  providers: [PrismaService, PrismaEncryptionMiddleware],
  exports: [PrismaService, PrismaEncryptionMiddleware],
})
export class PrismaModule {}