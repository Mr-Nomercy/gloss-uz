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
  private readonly blindIndexKey: Buffer;

  constructor(config: ConfigService) {
    const keyHex = config.get<string>('ENCRYPTION_MASTER_KEY');
    if (!keyHex || keyHex.length !== 64) {
      throw new Error('ENCRYPTION_MASTER_KEY must be 64 hex characters (32 bytes)');
    }
    this.masterKey = Buffer.from(keyHex, 'hex');

    const blindKeyHex = config.get<string>('BLIND_INDEX_KEY');
    if (!blindKeyHex || blindKeyHex.length !== 64) {
      throw new Error('BLIND_INDEX_KEY must be 64 hex characters (32 bytes)');
    }
    this.blindIndexKey = Buffer.from(blindKeyHex, 'hex');
  }

  encrypt(plaintext: string): string {
    if (!plaintext) return plaintext;
    
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
    if (!ciphertext) return ciphertext;
    
    const data = Buffer.from(ciphertext, 'base64');
    if (data.length < this.ivLength + this.tagLength) {
      throw new Error('Invalid ciphertext: too short');
    }
    
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
    if (obj === null || obj === undefined) return obj as any;
    return this.encrypt(JSON.stringify(obj));
  }

  decryptJson<T>(ciphertext: string): T {
    if (!ciphertext) return ciphertext as any;
    return JSON.parse(this.decrypt(ciphertext));
  }

  generateBlindIndex(plaintext: string): string {
    if (!plaintext) return '';
    return crypto
      .createHmac('sha256', this.blindIndexKey)
      .update(plaintext.toLowerCase().trim())
      .digest('hex');
  }

  generateDeterministicEncryption(plaintext: string): string {
    if (!plaintext) return plaintext;
    
    const iv = crypto.createHash('sha256').update(plaintext).digest().subarray(0, this.ivLength);
    const cipher = crypto.createCipheriv(this.algorithm, this.masterKey, iv);
    
    const encrypted = Buffer.concat([
      cipher.update(plaintext, 'utf8'),
      cipher.final(),
    ]);
    
    const tag = cipher.getAuthTag();
    
    return Buffer.concat([iv, encrypted, tag]).toString('base64');
  }
}