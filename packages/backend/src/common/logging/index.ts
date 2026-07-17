import { LoggerService } from '@nestjs/common';
import pino, { Logger, LoggerOptions } from 'pino';

declare global {
  var loggerInstance: Logger | undefined;
}

export interface LogContext {
  correlationId?: string;
  userId?: string;
  method?: string;
  url?: string;
  statusCode?: number;
  responseTime?: number;
  userAgent?: string;
  ip?: string;
  error?: Error;
  [key: string]: unknown;
}

async function generateCorrelationId(): Promise<string> {
  const uuid = await import('uuid');
  return uuid.v4();
}

function getCorrelationIdInternal(): string {
  try {
    const cls = require('cls-hooked');
    const ns = cls.getNamespace('gloss-correlation');
    if (ns) {
      return ns.get('correlationId') || 'pending';
    }
  } catch {
    // cls-hooked not available
  }
  return 'pending';
}

export function getCorrelationId(): string {
  return getCorrelationIdInternal();
}

export function setCorrelationId(id: string): void {
  try {
    const cls = require('cls-hooked');
    const ns = cls.getNamespace('gloss-correlation');
    if (ns) {
      ns.set('correlationId', id);
    }
  } catch {
    // cls-hooked not available
  }
}

export function clearCorrelationId(): void {
  try {
    const cls = require('cls-hooked');
    const ns = cls.getNamespace('gloss-correlation');
    if (ns) {
      ns.set('correlationId', undefined);
    }
  } catch {
    // cls-hooked not available
  }
}

export function createLogger(config: { nodeEnv: string; serviceName: string; lokiUrl?: string }): Logger {
  const isDevelopment = config.nodeEnv === 'development';

  const baseOptions: LoggerOptions = {
    level: config.nodeEnv === 'production' ? 'info' : 'debug',
    base: {
      service: config.serviceName,
      environment: config.nodeEnv,
    },
    timestamp: pino.stdTimeFunctions.isoTime,
    mixin: () => ({
      correlationId: getCorrelationId(),
    }),
  };

  let streams: Array<{ target: string; options: Record<string, any>; level: string }> = [];

  if (config.nodeEnv === 'development') {
    streams = [
      {
        target: 'pino-pretty',
        options: {
          colorize: true,
          translateTime: 'SYS:standard',
          ignore: 'pid,hostname,service,environment',
        },
        level: 'debug',
      },
    ];
  } else {
    streams = [
      {
        target: 'pino/file',
        options: { destination: 1 },
        level: 'info',
      },
    ];
  }

  if (config.lokiUrl) {
    streams.push({
      target: 'pino-loki',
      options: {
        host: config.lokiUrl,
        labels: { service: config.serviceName },
        batching: true,
        interval: 5,
      },
      level: 'info',
    });
  }

  const logger = pino({
    ...baseOptions,
    transport: {
      targets: streams as any[],
    },
  });

  return logger;
}

export function setupLogging(app: any, config: any): void {
  const logger = createLogger({
    nodeEnv: config.get('NODE_ENV', 'development'),
    serviceName: 'gloss-backend',
    lokiUrl: config.get('LOKI_URL'),
  });

  if (!global.loggerInstance) {
    global.loggerInstance = logger;
  }

  const originalLog = console.log;
  const originalError = console.error;
  const originalWarn = console.warn;
  const originalDebug = console.debug;

  console.log = (...args: unknown[]) => {
    logger.info({ args }, args.map(String).join(' '));
    originalLog.apply(console, args);
  };
  console.error = (...args: unknown[]) => {
    logger.error({ args }, args.map(String).join(' '));
    originalError.apply(console, args);
  };
  console.warn = (...args: unknown[]) => {
    logger.warn({ args }, args.map(String).join(' '));
    originalWarn.apply(console, args);
  };
  console.debug = (...args: unknown[]) => {
    logger.debug({ args }, args.map(String).join(' '));
    originalDebug.apply(console, args);
  };

  app.useLogger({
    log: (message: string, context?: string) => logger.info({ context }, message),
    error: (message: string, trace?: string, context?: string) => logger.error({ context, trace }, message),
    warn: (message: string, context?: string) => logger.warn({ context }, message),
    debug: (message: string, context?: string) => logger.debug({ context }, message),
    verbose: (message: string, context?: string) => logger.trace({ context }, message),
  } as LoggerService);
}

function getLoggerInternal(): Logger {
  if (!global.loggerInstance) {
    global.loggerInstance = pino({
      level: process.env.NODE_ENV === 'production' ? 'info' : 'debug',
      base: {
        service: 'gloss-backend',
        environment: process.env.NODE_ENV || 'development',
      },
    });
  }
  return global.loggerInstance;
}

export class PinoLogger implements LoggerService {
  private readonly logger: Logger;

  constructor(context?: string) {
    this.logger = getLogger().child({ context });
  }

  log(message: string, context?: any): void {
    this.logger.info({ ...context }, message);
  }

  error(message: string, trace?: string, context?: any): void {
    this.logger.error({ ...context, trace }, message);
  }

  warn(message: string, context?: any): void {
    this.logger.warn({ ...context }, message);
  }

  debug(message: string, context?: any): void {
    this.logger.debug({ ...context }, message);
  }

  verbose(message: string, context?: any): void {
    this.logger.trace({ ...context }, message);
  }
}

export async function createCorrelationMiddleware(): Promise<(req: any, res: any, next: () => void) => void> {
  const uuid = await import('uuid');
  return async (req: any, res: any, next: () => void) => {
    const incomingId = req.headers['x-correlation-id'] || req.headers['x-request-id'];
    const correlationId = incomingId || uuid.v4();

    res.setHeader('x-correlation-id', correlationId);

    const start = Date.now();
    res.on('finish', () => {
      const duration = Date.now() - start;
      const logger = getLogger();
      logger.info({
        correlationId,
        method: req.method,
        url: req.url,
        statusCode: res.statusCode,
        responseTime: duration,
        userAgent: req.headers['user-agent'],
        ip: req.ip,
      }, `${req.method} ${req.url} ${res.statusCode} ${duration}ms`);
    });

    next();
  };
}

export function getLogger(): Logger {
  if (!global.loggerInstance) {
    global.loggerInstance = pino({
      level: process.env.NODE_ENV === 'production' ? 'info' : 'debug',
      base: {
        service: 'gloss-backend',
        environment: process.env.NODE_ENV || 'development',
      },
    });
  }
  return global.loggerInstance;
}