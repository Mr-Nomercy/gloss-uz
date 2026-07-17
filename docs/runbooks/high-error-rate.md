# High Error Rate Runbook

## Overview
Covers elevated HTTP error rates (5xx, 4xx) across API endpoints.

## Alert Thresholds
- **Warning**: Error rate > 1% for 5 min
- **Critical**: Error rate > 5% for 2 min or 5xx rate > 1%
- **Page**: Error rate > 10% or all health checks failing

## Quick Diagnostics (0-3 minutes)

```bash
# Overall error rate
curl -s "https://grafana.gloss.uz/api/datasources/proxy/1/api/v1/query?query=sum(rate(http_requests_total{status=~\"5..\"}[5m]))/sum(rate(http_requests_total[5m]))"

# By endpoint
curl -s "https://grafana.gloss.uz/api/datasources/proxy/1/api/v1/query?query=sum%20by%20(path)%20(rate(http_requests_total{status=~\"5..\"}[5m]))"

# Check specific service
kubectl logs -n gloss-prod -l app=gloss-backend --tail=100 | grep -E "ERROR|500|502|503" | head -20
```

## Common Issues & Resolutions

### 1. Database Connectivity Issues
**Symptoms**: 500 errors, "connection refused", "pool exhausted"
**Resolution**: See `db-performance.md` runbook

### 2. Upstream Service Down
**Symptoms**: 502/503 errors, timeout errors
**Common upstreams**: Payment gateways (Click/Payme), Yandex Maps, FCM, Redis
**Resolution**:
```bash
# Check upstream health
curl -s https://api.click.uz/health
curl -s https://api.payme.uz/health
curl -s https://fcm.googleapis.com/fcm/health

# Circuit breaker pattern - already implemented
# Check circuit breaker status in logs
```

### 3. Deployment Issue
**Symptoms**: Errors spike immediately after deployment
**Resolution**:
```bash
# Immediate rollback
./scripts/deploy-blue-green.sh --rollback

# Or manual switch
kubectl exec nginx -n gloss-prod -- sed -i 's/backup-green/backup-blue/' /etc/nginx/conf.d/upstream.conf && nginx -s reload
```

### 4. Resource Exhaustion
**Symptoms**: 500s with "out of memory", "too many connections"
**Resolution**: See `db-performance.md` and `queue-backlog.md`

### 5. Code Bug / Regression
**Symptoms**: Specific endpoint failing, consistent error pattern
**Resolution**:
```bash
# Check recent deployments
kubectl rollout history deployment/gloss-backend-blue -n gloss-prod

# Check error details
kubectl logs -n gloss-prod -l app=gloss-backend --tail=500 | grep -A 10 -B 5 "ERROR"

# If recent deploy: rollback
./scripts/deploy-blue-green.sh --rollback
```

## Escalation
1. On-call (0-5 min)
2. Platform Lead (5-15 min)
3. Engineering Manager (15+ min)

---

**Last Updated**: 2024-01-15  
**Owner**: Platform Team