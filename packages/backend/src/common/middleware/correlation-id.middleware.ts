import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { setCorrelationId, clearCorrelationId, getLogger, LogContext } from '../logging';

@Injectable()
export class CorrelationIdMiddleware implements NestMiddleware {
  async use(req: Request, res: Response, next: NextFunction) {
    const uuid = await import('uuid');
    const correlationId = (req.headers['x-correlation-id'] as string) || uuid.v4();
    setCorrelationId(correlationId);

    res.setHeader('X-Correlation-ID', correlationId);

    const startTime = Date.now();
    const originalSend = res.send;

    res.send = function (body?: any): Response {
      const responseTime = Date.now() - startTime;

      const logContext: LogContext = {
        correlationId,
        method: req.method,
        url: req.originalUrl || req.url,
        statusCode: res.statusCode,
        responseTime,
        userAgent: req.get('user-agent'),
        ip: req.ip,
        userId: (req as any).user?.id,
      };

      const logger = getLogger();
      const logMessage = `${req.method} ${req.originalUrl || req.url} ${res.statusCode} - ${responseTime}ms`;

      if (res.statusCode >= 500) {
        logger.error(logContext, logMessage);
      } else if (res.statusCode >= 400) {
        logger.warn(logContext, logMessage);
      } else {
        logger.info(logContext, logMessage);
      }

      clearCorrelationId();
      return originalSend.call(this, body);
    };

    next();
  }
}