import { Injectable, OnModuleInit, Inject, forwardRef } from '@nestjs/common';
import { PrismaService } from './prisma.service';
import { EncryptionService } from '../common/encryption/encryption.service';
import { ENCRYPTED_FIELDS, BLIND_INDEX_FIELDS } from '../common/encryption/encrypted-fields';

@Injectable()
export class PrismaEncryptionMiddleware implements OnModuleInit {
  constructor(
    @Inject(forwardRef(() => PrismaService))
    private readonly prisma: PrismaService,
    private readonly encryption: EncryptionService,
  ) {}

  onModuleInit() {
    this.applyMiddleware();
  }

  private applyMiddleware() {
    const models = Object.keys(ENCRYPTED_FIELDS) as Array<keyof typeof ENCRYPTED_FIELDS>;

    for (const model of models) {
      const fields = [...ENCRYPTED_FIELDS[model]];
      const blindFields = [...BLIND_INDEX_FIELDS[model]];
      
      if (fields.length === 0 && blindFields.length === 0) continue;

      (this.prisma as any).$use(async (params: any, next: any) => {
        if (params.model !== model) return next(params);

        // Encrypt on write
        const writeActions = ['create', 'update', 'upsert'];
        if (writeActions.includes(params.action)) {
          const data = params.args.data;
          if (data) {
            this.encryptData(data, fields, blindFields);
          }
        }

        const result = await next(params);

        // Decrypt on read
        const readActions = ['findUnique', 'findFirst', 'findMany'];
        if (readActions.includes(params.action)) {
          this.decryptResult(result, fields);
        }

        return result;
      });
    }
  }

  private encryptData(data: any, fields: string[], blindFields: string[]) {
    if (!data) return;

    const encryptValue = (obj: any, field: string) => {
      const value = obj[field];
      if (value !== undefined && value !== null && typeof value === 'string') {
        try {
          obj[field] = this.encryption.encrypt(value);
        } catch (e) {
          console.warn(`[Encryption] Failed to encrypt ${field}:`, e);
        }
      }
    };

    const encryptJson = (obj: any, field: string) => {
      const value = obj[field];
      if (value !== undefined && value !== null && typeof value === 'object') {
        try {
          obj[field] = this.encryption.encryptJson(value);
        } catch (e) {
          console.warn(`[Encryption] Failed to encrypt JSON ${field}:`, e);
        }
      }
    };

    // Handle create/update data
    for (const field of fields) {
      if (field === 'metadata' || field === 'details' || field === 'data') {
        encryptJson(data, field);
      } else {
        encryptValue(data, field);
      }
    }

    // Handle nested create/update
    for (const key of Object.keys(data)) {
      const value = data[key];
      if (value && typeof value === 'object') {
        if (value.create) this.encryptData(value.create, fields, blindFields);
        if (value.update) this.encryptData(value.update, fields, blindFields);
        if (value.upsert) {
          if (value.upsert.create) this.encryptData(value.upsert.create, fields, blindFields);
          if (value.upsert.update) this.encryptData(value.upsert.update, fields, blindFields);
        }
        if (Array.isArray(value)) {
          for (const item of value) {
            if (item && typeof item === 'object') {
              this.encryptData(item, fields, blindFields);
            }
          }
        }
      }
    }

    // Generate blind indexes
    for (const field of blindFields) {
      const value = data[field];
      if (value !== undefined && value !== null && typeof value === 'string') {
        try {
          data[`${field}BlindIndex`] = this.encryption.generateBlindIndex(value);
        } catch (e) {
          console.warn(`[Encryption] Failed to generate blind index for ${field}:`, e);
        }
      }
    }
  }

  private decryptResult(result: any, fields: string[]) {
    if (!result) return;

    const decryptValue = (obj: any, field: string) => {
      const value = obj[field];
      if (value !== undefined && value !== null && typeof value === 'string') {
        try {
          obj[field] = this.encryption.decrypt(value);
        } catch (e) {
          console.warn(`[Encryption] Failed to decrypt ${field}:`, e);
        }
      }
    };

    const decryptJson = (obj: any, field: string) => {
      const value = obj[field];
      if (value !== undefined && value !== null && typeof value === 'string') {
        try {
          obj[field] = this.encryption.decryptJson(value);
        } catch (e) {
          console.warn(`[Encryption] Failed to decrypt JSON ${field}:`, e);
        }
      }
    };

    const process = (obj: any) => {
      if (!obj || typeof obj !== 'object') return;

      for (const field of fields) {
        if (field === 'metadata' || field === 'details' || field === 'data') {
          decryptJson(obj, field);
        } else {
          decryptValue(obj, field);
        }
      }
    };

    if (Array.isArray(result)) {
      for (const item of result) {
        process(item);
      }
    } else {
      process(result);
    }
  }
}