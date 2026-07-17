import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';

@Injectable()
export class EncryptionService {
  private readonly algorithm = 'aes-256-gcm';
  private readonly keyLength = 32;
  private readonly ivLength = 12;
  private readonly authTagLength = 16;
  private readonly masterKey: Buffer;

  constructor(config: ConfigService) {
    const keyHex = config.get<string>('ENCRYPTION_MASTER_KEY');
    if (!keyHex) {
      throw new Error('ENCRYPTION_MASTER_KEY not configured');
    }
    this.masterKey = Buffer.from(keyHex, 'hex');
    if (this.masterKey.length !== this.keyLength) {
      throw new Error(`ENCRYPTION_MASTER_KEY must be ${this.keyLength} bytes (64 hex chars)`);
    }
  }

  encrypt(plaintext: string): string {
    const iv = crypto.randomBytes(this.ivLength);
    const cipher = crypto.createCipheriv(this.algorithm, this.masterKey, iv);
    
    const encrypted = Buffer.concat([
      cipher.update(plaintext, 'utf8'),
      cipher.final(),
    ]);
    
    const authTag = cipher.getAuthTag();
    
    return Buffer.concat([iv, encrypted, authTag]).toString('base64');
  }

  decrypt(ciphertext: string): string {
    const data = Buffer.from(ciphertext, 'base64');
    
    if (data.length < this.ivLength + this.authTagLength) {
      throw new Error('Invalid ciphertext: too short');
    }
    
    const iv = data.subarray(0, this.ivLength);
    const authTag = data.subarray(-this.authTagLength);
    const encrypted = data.subarray(this.ivLength, -this.authTagLength);
    
    const decipher = crypto.createDecipheriv(this.algorithm, this.masterKey, iv);
    decipher.setAuthTag(authTag);
    
    const decrypted = Buffer.concat([
      decipher.update(encrypted),
      decipher.final(),
    ]);
    
    return decrypted.toString('utf8');
  }

  encryptJson<T>(obj: T): string {
    return this.encrypt(JSON.stringify(obj));
  }

  decryptJson<T>(ciphertext: string): T {
    return JSON.parse(this.decrypt(ciphertext)) as T;
  }

  generateBlindIndex(value: string): string {
    const hmac = crypto.createHmac('sha256', this.masterKey);
    hmac.update(value.toLowerCase().trim());
    return hmac.digest('hex').substring(0, 16);
  }

  generateDataKey(): { key: string; encryptedKey: string } {
    const dataKey = crypto.randomBytes(this.keyLength);
    const encryptedKey = this.encrypt(dataKey.toString('hex'));
    return {
      key: dataKey.toString('hex'),
      encryptedKey,
    };
  }

  deriveKey(context: string): Buffer {
    return crypto.pbkdf2Sync(this.masterKey, context, 100000, this.keyLength, 'sha256');
  }

  hashForLookup(value: string): string {
    const hash = crypto.createHash('sha256');
    hash.update(value.toLowerCase().trim());
    return hash.digest('hex');
  }
}