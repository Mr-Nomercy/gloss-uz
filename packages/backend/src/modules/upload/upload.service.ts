import { Injectable, Logger, BadRequestException, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';
import { unlink, writeFile, mkdir } from 'fs/promises';
import { join } from 'path';
import * as ClamAV from 'clamav.js';

const ALLOWED_MIME_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'application/pdf'] as const;
const MAX_FILE_SIZE = 10 * 1024 * 1024;
const SIGNED_URL_EXPIRY_HOURS = 1;

interface FileTypeResult {
  mime: string;
  ext: string;
}

async function detectFileType(buffer: Buffer): Promise<FileTypeResult | null> {
  try {
    // Dynamic import for ESM-only module 'file-type'
    // eslint-disable-next-line @typescript-eslint/no-require-imports
    const fileTypeModule = await import('file-type').catch(() => 
      require('file-type')
    );
    const module = fileTypeModule.default || fileTypeModule;
    const result = await module.fileTypeFromBuffer(buffer);
    return result ? { mime: result.mime, ext: result.ext } : null;
  } catch (err) {
    return null;
  }
}

@Injectable()
export class UploadService {
  private readonly logger = new Logger(UploadService.name);
  private clamavScanner: ReturnType<typeof ClamAV.createScanner> | null = null;

  constructor(private config: ConfigService) {
    this.initClamAV();
  }

  private initClamAV(): void {
    const clamavHost = this.config.get<string>('CLAMAV_HOST');
    const clamavPort = this.config.get<number>('CLAMAV_PORT');

    if (clamavHost && clamavPort) {
      try {
        this.clamavScanner = ClamAV.createScanner(clamavPort, clamavHost);
        this.logger.log(`ClamAV scanner initialized: ${clamavHost}:${clamavPort}`);
      } catch (err) {
        this.logger.warn(`Failed to initialize ClamAV scanner: ${err}`);
      }
    } else {
      this.logger.warn('ClamAV not configured (CLAMAV_HOST/CLAMAV_PORT), skipping virus scan');
    }
  }

  async uploadFile(file: Express.Multer.File): Promise<{ url: string; expiresAt: Date; signedUrl: string }> {
    await this.validateFile(file);

    const uploadDir = this.config.get<string>('UPLOAD_DIR', './uploads');
    const ext = this.getExtension(file.mimetype);
    const filename = `${crypto.randomUUID()}${ext}`;
    const filepath = join(uploadDir, filename);

    try {
      await mkdir(uploadDir, { recursive: true });
      await writeFile(filepath, file.buffer);
    } catch (err) {
      this.logger.error(`Failed to save file: ${err}`);
      throw new BadRequestException('File upload failed');
    }

    await this.scanForVirus(filepath);

    const baseUrl = this.config.get<string>('BASE_URL', 'http://localhost:3000');
    const expiresAt = new Date(Date.now() + SIGNED_URL_EXPIRY_HOURS * 60 * 60 * 1000);
    const signedUrl = this.generateSignedUrl(filename, expiresAt);

    return {
      url: `${baseUrl}/uploads/${filename}`,
      expiresAt,
      signedUrl,
    };
  }

  async deleteFile(url: string): Promise<void> {
    const filename = url.split('/').pop()?.split('?')[0];
    if (!filename) return;

    const uploadDir = this.config.get<string>('UPLOAD_DIR', './uploads');
    const filepath = join(uploadDir, filename);

    try {
      await unlink(filepath);
    } catch {
      this.logger.warn(`File not found for deletion: ${filepath}`);
    }
  }

  private async validateFile(file: Express.Multer.File): Promise<void> {
    if (!file) throw new BadRequestException('No file provided');
    if (file.size > MAX_FILE_SIZE) throw new BadRequestException('File exceeds 10MB limit');

    const detectedType = await detectFileType(file.buffer);
    if (!detectedType) {
      throw new BadRequestException('Unable to detect file type from content');
    }

    const detectedMime = detectedType.mime;
    if (!ALLOWED_MIME_TYPES.includes(detectedMime as any)) {
      throw new BadRequestException(`Invalid file type: ${detectedMime}. Allowed: ${ALLOWED_MIME_TYPES.join(', ')}`);
    }

    if (file.mimetype !== detectedMime) {
      this.logger.warn(`MIME type mismatch: declared ${file.mimetype}, detected ${detectedMime}`);
      throw new BadRequestException('File type mismatch between declared and actual content');
    }
  }

  private async scanForVirus(filepath: string): Promise<void> {
    if (!this.clamavScanner) {
      this.logger.debug('ClamAV not available, skipping virus scan');
      return;
    }

    return new Promise((resolve, reject) => {
      this.clamavScanner!.scan(filepath, (err: Error | null, result?: string) => {
        if (err) {
          this.logger.error(`ClamAV scan error: ${err.message}`);
          reject(new InternalServerErrorException('Virus scan failed'));
          return;
        }

        if (result) {
          this.logger.error(`[SECURITY] Virus detected in ${filepath}: ${result}`);
          reject(new BadRequestException('File contains malware'));
        }

        this.logger.log(`ClamAV scan passed for ${filepath}`);
        resolve();
      });
    });
  }

  private generateSignedUrl(filename: string, expiresAt: Date): string {
    const baseUrl = this.config.get<string>('BASE_URL', 'http://localhost:3000');
    const secret = this.config.get<string>('SIGNED_URL_SECRET', 'default-secret-change-in-production');
    const expiry = Math.floor(expiresAt.getTime() / 1000);
    const payload = `${filename}:${expiry}`;
    const signature = crypto.createHmac('sha256', secret).update(payload).digest('hex');

    return `${baseUrl}/uploads/${filename}?expires=${expiry}&sig=${signature}`;
  }

  verifySignedUrl(filename: string, expires: string, signature: string): boolean {
    const secret = this.config.get<string>('SIGNED_URL_SECRET', 'default-secret-change-in-production');
    const payload = `${filename}:${expires}`;
    const expectedSignature = crypto.createHmac('sha256', secret).update(payload).digest('hex');

    if (signature !== expectedSignature) {
      this.logger.warn(`[SECURITY] Invalid signature for file ${filename}`);
      return false;
    }

    const now = Math.floor(Date.now() / 1000);
    if (parseInt(expires, 10) < now) {
      this.logger.warn(`[SECURITY] Signed URL expired for file ${filename}`);
      return false;
    }

    return true;
  }

  private getExtension(mimeType: string): string {
    const map: Record<string, string> = {
      'image/jpeg': '.jpg',
      'image/png': '.png',
      'image/webp': '.webp',
      'application/pdf': '.pdf',
    };
    return map[mimeType] || '.bin';
  }
}