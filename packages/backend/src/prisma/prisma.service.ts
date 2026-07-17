import { Injectable, OnModuleInit, OnModuleDestroy, Logger, Inject, forwardRef } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';
import { PrismaEncryptionMiddleware } from './prisma-encryption.middleware';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(PrismaService.name);

  constructor(
    config: ConfigService,
    @Inject(forwardRef(() => PrismaEncryptionMiddleware))
    private readonly encryptionMiddleware: PrismaEncryptionMiddleware,
  ) {
    super({
      log: config.get<string>('NODE_ENV') === 'development'
        ? ['query', 'warn', 'error']
        : ['warn', 'error'],
    });
  }

  async onModuleInit() {
    await this.$connect();
    this.logger.log('Connected to database');
  }

  async onModuleDestroy() {
    await this.$disconnect();
    this.logger.log('Disconnected from database');
  }

  // Helper for testing - bypass encryption middleware
  async cleanDatabase() {
    if (process.env.NODE_ENV === 'production') {
      throw new Error('cleanDatabase not allowed in production');
    }
    
    const models = Object.keys(this).filter(key => 
      typeof this[key as keyof this] === 'object' && 
      this[key as keyof this] !== null &&
      typeof (this[key as keyof this] as any).deleteMany === 'function'
    );

    for (const model of models) {
      try {
        await (this[model as keyof this] as any).deleteMany({});
      } catch (e) {
        // Ignore models that don't support deleteMany
      }
    }
  }
}