# PII Encryption Audit Report
**Project**: Gloss Ecosystem Backend  
**Date**: 2026-07-12  
**Phase**: 7.3 - PII Encryption Audit  

---

## Executive Summary

This audit reviews the Prisma schema for sensitive Personal Identifiable Information (PII) fields and verifies encryption-at-rest implementation. The following sensitive fields were identified and assessed for encryption requirements.

---

## Sensitive Fields Identified

### 1. User Model (`User`)
| Field | Type | Sensitivity | Current Encryption | Recommendation |
|-------|------|-------------|-------------------|----------------|
| `phone` | String | **HIGH** - Primary identifier | ❌ None | Add column-level encryption |
| `email` | String? | **HIGH** - PII | ❌ None | Add column-level encryption |
| `passwordHash` | String | **CRITICAL** - Already hashed (argon2id) | ✅ Argon2id | ✅ OK |
| `fullName` | String? | **MEDIUM** - PII | ❌ None | Add column-level encryption |
| `resetOtp` | String? | **HIGH** - OTP token | ❌ None | Add encryption or TTL-based cleanup |
| `resetOtpExpires` | DateTime? | **MEDIUM** | ✅ TTL-based | ✅ OK |

### 2. Address Model (`Address`)
| Field | Type | Sensitivity | Current Encryption | Recommendation |
|-------|------|-------------|-------------------|----------------|
| `addressLine` | String | **HIGH** - Exact address | ❌ None | Add column-level encryption |
| `building` | String? | **MEDIUM** | ❌ None | Add column-level encryption |
| `entrance` | String? | **LOW** | ❌ None | Optional |
| `floor` | String? | **LOW** | ❌ None | Optional |
| `apartment` | String? | **MEDIUM** | ❌ None | Add column-level encryption |
| `doorCode` | String? | **HIGH** - Access code | ❌ None | Add column-level encryption |
| `lat` / `lng` | Float | **MEDIUM** - Location | ❌ None | Consider encryption |

### 3. KYC Documents (`KYCDocument`)
| Field | Type | Sensitivity | Current Encryption | Recommendation |
|-------|------|-------------|-------------------|----------------|
| `fileUrl` | String | **CRITICAL** - Document storage | ❌ None | Encrypt file URLs + use signed URLs |
| `type` | String | **HIGH** - Document type | ❌ None | Add encryption |
| `rejectionReason` | String? | **MEDIUM** | ❌ None | Optional |

### 4. Payment Model (`Payment`)
| Field | Type | Sensitivity | Current Encryption | Recommendation |
|-------|------|-------------|-------------------|----------------|
| `metadata` | Json? | **CRITICAL** - May contain card/phone | ❌ None | Encrypt JSON field |
| `providerTransactionId` | String? | **MEDIUM** | ❌ None | Optional |

### 5. Payout Account (`PayoutAccount`)
| Field | Type | Sensitivity | Current Encryption | Recommendation |
|-------|------|-------------|-------------------|----------------|
| `details` | Json | **CRITICAL** - Bank card/account | ❌ None | **MUST** encrypt JSON field |

### 6. User Model - Wallet (`Wallet` / `WalletTransaction`)
| Field | Type | Sensitivity | Current Encryption | Recommendation |
|-------|------|-------------|-------------------|----------------|
| `balance` | Decimal | **MEDIUM** - Financial | ❌ None | Consider encryption |
| `amount` (WalletTransaction) | Decimal | **MEDIUM** | ❌ None | Consider encryption |

### 7. Chat/Message (`Message`)
| Field | Type | Sensitivity | Current Encryption | Recommendation |
|-------|------|-------------|-------------------|----------------|
| `content` | String | **HIGH** - User messages | ❌ None | Add encryption |
| `metadata` | Json? | **MEDIUM** - May contain PII | ❌ None | Add encryption |

---

## Current Encryption Status

### ✅ Already Protected
- **Password Hash**: Argon2id (via `auth.service.ts`)
- **Refresh Tokens**: Stored as hashed values
- **OTP**: Stored with TTL expiration

### ❌ Missing Encryption
1. **Phone numbers** - Primary user identifier
2. **Email addresses** - PII
3. **Full names** - PII
4. **Addresses** - Physical location PII
5. **Door codes** - Access credentials
6. **Bank details** (PayoutAccount.details) - Financial PII
7. **Payment metadata** - May contain card/phone
8. **KYC document URLs** - Sensitive document references
9. **Chat messages** - User communications

---

## Recommended Implementation: Column-Level Encryption

### Approach: Application-Level Encryption with Prisma Middleware

```typescript
// src/common/crypto/encryption.service.ts
import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class EncryptionService {
  private readonly algorithm = 'aes-256-gcm';
  private readonly keyLength = 32;
  private readonly ivLength = 12;
  private readonly tagLength = 16;
  private readonly masterKey: Buffer;

  constructor(config: ConfigService) {
    const keyHex = config.get<string>('ENCRYPTION_MASTER_KEY');
    if (!keyHex || keyHex.length !== 64) {
      throw new Error('ENCRYPTION_MASTER_KEY must be 64 hex characters (32 bytes)');
    }
    this.masterKey = Buffer.from(keyHex, 'hex');
  }

  encrypt(plaintext: string): string {
    const iv = crypto.randomBytes(this.ivLength);
    const cipher = crypto.createCipheriv(this.algorithm, this.masterKey, iv);
    
    const encrypted = Buffer.concat([
      cipher.update(plaintext, 'utf8'),
      cipher.final(),
    ]);
    
    const tag = cipher.getAuthTag();
    
    return Buffer.concat([iv, encrypted, tag]).toString('base64');
  }

  decrypt(ciphertext: string): string {
    const data = Buffer.from(ciphertext, 'base64');
    const iv = data.subarray(0, this.ivLength);
    const tag = data.subarray(data.length - this.tagLength);
    const encrypted = data.subarray(this.ivLength, data.length - this.tagLength);
    
    const decipher = crypto.createDecipheriv(this.algorithm, this.masterKey, iv);
    decipher.setAuthTag(tag);
    
    return Buffer.concat([
      decipher.update(encrypted),
      decipher.final(),
    ]).toString('utf8');
  }

  encryptJson<T>(obj: T): string {
    return this.encrypt(JSON.stringify(obj));
  }

  decryptJson<T>(ciphertext: string): T {
    return JSON.parse(this.decrypt(ciphertext));
  }
}
```

### Prisma Middleware for Transparent Encryption

```typescript
// src/prisma/prisma-encryption.middleware.ts
import { Prisma, PrismaClient } from '@prisma/client';
import { EncryptionService } from '../common/crypto/encryption.service';

const ENCRYPTED_FIELDS: Record<string, string[]> = {
  User: ['phone', 'email', 'fullName', 'resetOtp'],
  Address: ['addressLine', 'building', 'entrance', 'floor', 'apartment', 'doorCode'],
  KYCDocument: ['fileUrl', 'type', 'rejectionReason'],
  Payment: ['metadata'],
  PayoutAccount: ['details'],
  Message: ['content', 'metadata'],
};

export function createEncryptionMiddleware(encryption: EncryptionService) {
  return async (params: Prisma.MiddlewareParams, next: (params: Prisma.MiddlewareParams) => Promise<any>) => {
    const model = params.model;
    const fields = ENCRYPTED_FIELDS[model];
    
    if (!fields) return next(params);

    // Encrypt on create/update
    if (params.action === 'create' || params.action === 'update') {
      const data = params.args.data;
      for (const field of fields) {
        if (data[field] !== undefined && data[field] !== null) {
          if (field === 'metadata' || field === 'details') {
            data[field] = encryption.encryptJson(data[field]);
          } else {
            data[field] = encryption.encrypt(data[field]);
          }
        }
      }
    }

    const result = await next(params);

    // Decrypt on read
    if (params.action === 'findUnique' || params.action === 'findFirst' || params.action === 'findMany') {
      const decryptResult = (obj: any) => {
        if (!obj) return obj;
        for (const field of fields) {
          if (obj[field] !== undefined && obj[field] !== null) {
            try {
              if (field === 'metadata' || field === 'details') {
                obj[field] = encryption.decryptJson(obj[field]);
              } else {
                obj[field] = encryption.decrypt(obj[field]);
              }
            } catch (e) {
              // Field might not be encrypted (legacy data)
              console.warn(`Failed to decrypt ${model}.${field}:`, e);
            }
          }
        }
        return obj;
      };

      if (Array.isArray(result)) {
        return result.map(decryptResult);
      }
      return decryptResult(result);
    }

    return result;
  };
}
```

### Updated Prisma Service

```typescript
// src/prisma/prisma.service.ts (updated)
import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';
import { EncryptionService } from '../common/crypto/encryption.service';
import { createEncryptionMiddleware } from './prisma-encryption.middleware';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(PrismaService.name);

  constructor(
    config: ConfigService,
    private encryption: EncryptionService,
  ) {
    super({
      log: config.get<string>('NODE_ENV') === 'development'
        ? ['query', 'warn', 'error']
        : ['warn', 'error'],
    });

    this.$use(createEncryptionMiddleware(encryption));
  }

  async onModuleInit() {
    await this.$connect();
    this.logger.log('Connected to database with encryption middleware');
  }

  async onModuleDestroy() {
    await this.$disconnect();
    this.logger.log('Disconnected from database');
  }
}
```

---

## Migration Strategy

### 1. Generate Encryption Key
```bash
# Generate 32-byte key (64 hex chars)
openssl rand -hex 32
# Add to .env: ENCRYPTION_MASTER_KEY=<generated_key>
```

### 2. Database Migration for Existing Data
```sql
-- migration: add_encryption_to_pii_fields
-- Run after deploying encryption middleware

-- Create temporary columns
ALTER TABLE "users" ADD COLUMN "phone_encrypted" TEXT;
ALTER TABLE "users" ADD COLUMN "email_encrypted" TEXT;
ALTER TABLE "users" ADD COLUMN "full_name_encrypted" TEXT;

-- Encrypt existing data (run via script using EncryptionService)
-- UPDATE "users" SET "phone_encrypted" = encrypt(phone), ...;

-- Drop old columns, rename new ones
-- ALTER TABLE "users" DROP COLUMN "phone", RENAME COLUMN "phone_encrypted" TO "phone";
```

### 3. Searchable Encryption for Phone/Email
For fields requiring lookup (phone, email), use **deterministic encryption** or **blind indexing**:

```typescript
// Blind index for phone lookups
import * as crypto from 'crypto';

generateBlindIndex(plaintext: string, key: Buffer): string {
  return crypto.createHmac('sha256', key).update(plaintext).digest('hex');
}

// Add blind_index column to users table
// CREATE INDEX idx_users_phone_blind ON users(phone_blind_index);
```

---

## Compliance Checklist

| Requirement | Status | Notes |
|-------------|--------|-------|
| GDPR Art. 32 - Encryption at rest | ❌ Partial | Implement column-level encryption |
| PCI DSS - Card data protection | ❌ Missing | Encrypt PayoutAccount.details |
| Uzbekistan PDP Law - Personal data | ❌ Partial | Encrypt phone, name, address |
| Data minimization | ✅ | Only collect necessary fields |
| Right to erasure (GDPR Art. 17) | ✅ | Soft delete with `deletedAt` |
| Audit logging | ✅ | AuditLog model exists |
| Key rotation | ❌ Missing | Plan quarterly key rotation |

---

## Action Items

| Priority | Task | Effort | Owner |
|----------|------|--------|-------|
| **P0** | Add `EncryptionService` with AES-256-GCM | 4h | Backend |
| **P0** | Add Prisma encryption middleware | 4h | Backend |
| **P0** | Encrypt `PayoutAccount.details` (bank cards) | 2h | Backend |
| **P0** | Encrypt `User.phone`, `User.email`, `User.fullName` | 4h | Backend |
| **P1** | Encrypt `Address` fields (addressLine, doorCode) | 4h | Backend |
| **P1** | Encrypt `KYCDocument.fileUrl`, `Payment.metadata` | 3h | Backend |
| **P1** | Add blind indexes for phone/email lookups | 4h | Backend |
| **P2** | Encrypt `Message.content`, `Message.metadata` | 3h | Backend |
| **P2** | Implement key rotation strategy | 8h | DevOps |
| **P2** | Add encryption to `WalletTransaction.amount` | 2h | Backend |

---

## Verification Steps

1. **Unit Tests**: Verify encrypt/decrypt round-trip
2. **Integration Tests**: Verify Prisma middleware encrypts on write, decrypts on read
3. **Migration Test**: Run against staging with production-like data volume
4. **Performance Test**: Benchmark encryption overhead (< 5ms per operation)
5. **Search Test**: Verify blind index lookups work for phone/email
6. **Compliance Audit**: Verify all PII fields encrypted at rest

---

## Conclusion

**Current State**: Partial encryption (only passwords/tokens)  
**Target State**: Full column-level encryption for all PII fields  
**Estimated Effort**: ~38 hours  
**Risk**: HIGH - Unencrypted PII in database violates GDPR, PCI DSS, and local regulations  

**Recommendation**: Implement P0 items immediately before production launch. Use feature flag to enable encryption gradually.