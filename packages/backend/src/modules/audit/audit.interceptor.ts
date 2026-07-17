import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable, tap } from 'rxjs';
import { AuditService } from './audit.service';
import { Reflector } from '@nestjs/core';

@Injectable()
export class AuditInterceptor implements NestInterceptor {
  constructor(
    private auditService: AuditService,
    private reflector: Reflector,
  ) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const method = request.method;
    const url = request.route?.path || request.url;
    const user = request.user;

    if (!['POST', 'PATCH', 'PUT', 'DELETE'].includes(method)) {
      return next.handle();
    }

    const entity = url.split('/').filter(Boolean)[0] || 'unknown';
    const action = method === 'POST' ? 'create' : method === 'DELETE' ? 'delete' : 'update';
    const role = user?.roles?.[0];

    return next.handle().pipe(
      tap((response) => {
        this.auditService.log({
          userId: user?.id,
          role,
          action,
          entity,
          entityId: response?.id || request.params?.id,
          newValue: method !== 'DELETE' ? request.body : undefined,
          ipAddress: request.ip,
          userAgent: request.headers['user-agent'],
        }).catch(() => {});
      }),
    );
  }
}
