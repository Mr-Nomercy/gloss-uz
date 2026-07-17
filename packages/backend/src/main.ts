import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import compression from 'compression';
import cookieParser from 'cookie-parser';
import * as Sentry from '@sentry/nestjs';
import { nodeProfilingIntegration } from '@sentry/profiling-node';
import { AppModule } from './app.module';
import { createCsrfMiddleware } from './common/middleware';
import { setupLogging } from './common/logging';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bufferLogs: true });
  const config = app.get(ConfigService);
  const logger = new Logger('Bootstrap');

  setupLogging(app, config);

  if (config.get('SENTRY_DSN')) {
    Sentry.init({
      dsn: config.get('SENTRY_DSN'),
      environment: config.get('NODE_ENV', 'development'),
      integrations: [
        nodeProfilingIntegration(),
      ],
      tracesSampleRate: config.get('NODE_ENV') === 'production' ? 0.1 : 1.0,
      profilesSampleRate: config.get('NODE_ENV') === 'production' ? 0.1 : 1.0,
      ignoreErrors: [
        /^ECONNREFUSED$/,
        /^ETIMEDOUT$/,
        /^ECONNRESET$/,
        /^ENOTFOUND$/,
        /^HttpException: Not Found$/,
        /^HttpException: Bad Request$/,
        /^BadRequestException$/,
        /^UnauthorizedException$/,
        /^ForbiddenException$/,
        /^NotFoundException$/,
        /^ConflictException$/,
        /^GoneException$/,
        /^UnprocessableEntityException$/,
      ],
      beforeSend(event, hint) {
        const error = hint.originalException;
        if (error instanceof Error) {
          if (error.message.includes('ECONNREFUSED') || error.message.includes('ETIMEDOUT')) {
            return null;
          }
          if (error.name === 'HttpException' && [400, 401, 403, 404, 409, 410, 422].includes((error as any).status)) {
            return null;
          }
        }
        return event;
      },
      beforeSendTransaction(event) {
        if (event.transaction?.includes('/health') || event.transaction?.includes('/metrics')) {
          return null;
        }
        return event;
      },
    });
    app.use((Sentry as any).requestHandler());
    app.use((Sentry as any).tracingHandler());
    logger.log('Sentry initialized');
  }

  app.setGlobalPrefix('api/v1');
  app.enableCors({
    origin: corsOrigins,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-CSRF-Token', 'X-Correlation-ID'],
    credentials: true,
    maxAge: 86400,
  });
  app.use(compression());
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  if (config.get('SENTRY_DSN')) {
    app.use((Sentry as any).errorHandler());
  }

  const port = config.get<number>('API_PORT', 3000);
  await app.listen(port);
  logger.log(`Server running on http://localhost:${port}/api/v1`);
  logger.log(`CORS enabled for: ${corsOrigins.join(', ')}`);
  logger.log('CSRF protection enabled');
  if (config.get('SENTRY_DSN')) {
    logger.log('Sentry error tracking enabled');
  }
}

bootstrap();
