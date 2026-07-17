# Rollback Runbook

## Overview
Emergency rollback procedures for blue-green deployments. Supports both automated (CI/CD) and manual emergency rollbacks.

## When to Rollback
- **Automated**: Health checks fail, smoke tests fail, error rate > 5%
- **Manual**: Critical bug in production, data corruption, security issue

## Automated Rollback (CI/CD)
Triggered automatically by `deploy-blue-green.sh` on failure.

```bash
# Triggered automatically when:
# - Health checks fail (3 consecutive)
# - Smoke tests fail
# - Error rate > 5% in first 5 minutes
# - Manual approval rejected
```

## Manual Emergency Rollback

### Option 1: Blue-Green Switch (Fastest - < 2 minutes)
**Use when**: Current deployment has critical bug, previous version was stable

```bash
# From any machine with kubectl access
./scripts/deploy-blue-green.sh --rollback

# Or manually switch nginx upstream
kubectl exec -it nginx-pod -n gloss-prod -- sed -i 's/server backend-green:/server backup-green:/; s/server backup-blue:/server backup-green:/' /etc/nginx/conf.d/upstream.conf
kubectl exec -it nginx-pod -n gloss-prod -- nginx -s reload
```

### Option 2: Kubernetes Rollback (If Blue-Green Fails)
**Use when**: Blue-green switch failed, or need to rollback multiple versions

```bash
# Rollback deployment
kubectl rollout undo deployment/gloss-backend-blue -n gloss-prod
kubectl rollout undo deployment/gloss-backend-green -n gloss-prod

# Verify rollback
kubectl rollout status deployment/gloss-backend-blue -n gloss-prod
kubectl rollout status deployment/gloss-backend-green -n gloss-prod
```

### Option 3: Docker Image Rollback (Last Resort)
**Use when**: Kubernetes rollback failed, need specific image version

```bash
# Get previous working image tag
docker images | grep gloss-backend

# Update deployment to previous tag
kubectl set image deployment/gloss-backend-blue backend=ghcr.io/gloss-ecosystem/gloss-backend:v1.2.3 -n gloss-prod
kubectl set image deployment/gloss-backend-green backend=ghcr.io/gloss-ecosystem/gloss-backend:v1.2.3 -n gloss-prod

# Verify
kubectl rollout status deployment/gloss-backend-blue -n gloss-prod
```

### Option 4: Database Rollback (If Migration Applied)
**Use when**: Schema migration caused issues, need to revert schema

```bash
# 1. Check applied migrations
kubectl exec -it pg-primary -n gloss-prod -- psql -U postgres -c "SELECT * FROM _prisma_migrations ORDER BY finished_at DESC LIMIT 5;"

# 2. Revert specific migration (Prisma)
kubectl exec -it backend-pod -n gloss-prod -- npx prisma migrate resolve --rolled-back "20240115120000_migration_name"

# 3. Restore from backup (if data corrupted)
# See database-failover.md runbook
```

## Verification Checklist After Rollback

- [ ] Health endpoint returns 200: `curl https://api.gloss.uz/health`
- [ ] API responds: `curl https://api.gloss.uz/api/v1/health`
- [ ] WebSocket connections work: `wscat -c wss://ws.gloss.uz/ws?token=...`
- [ ] Database connections healthy: `kubectl exec pg-primary -- pg_isready`
- [ ] Redis accessible: `kubectl exec redis-primary -- redis-cli ping`
- [ ] Error rate < 1% for 5 minutes
- [ ] Smoke tests pass: `./scripts/smoke-tests.sh`

## Rollback Communication

### Internal
```bash
# Post to #incidents
@channel Rollback completed for gloss-backend. Rolled back to v1.2.3. Monitoring for stability.
```

### External (if customer-facing impact)
```markdown
Status page update: "We've rolled back a recent deployment that was causing issues. All services are now restored. We apologize for the inconvenience."
```

## Rollback Decision Matrix

| Scenario | Recommended Rollback | Time |
|----------|---------------------|------|
| Critical bug in new feature | Blue-green switch | < 2 min |
| Performance regression | Blue-green switch | < 2 min |
| Migration failure | Migration rollback + blue-green | 5-10 min |
| Data corruption | DB restore + app rollback | 15-30 min |
| Security vulnerability | Immediate blue-green + patch | < 5 min |

## Post-Rollback Actions

1. **Create incident record** with timeline
2. **Root cause analysis** within 24 hours
3. **Fix and re-deploy** with additional tests
4. **Update runbook** with lessons learned

## Quick Reference Commands

```bash
# Check current active color
kubectl get svc gloss-backend-active -n gloss-prod -o jsonpath='{.spec.selector.version}'

# Force switch to blue
./scripts/deploy-blue-green.sh --force-blue

# Force switch to green
./scripts/deploy-blue-green.sh --force-green

# Check rollout status
kubectl rollout status deployment/gloss-backend-blue -n gloss-prod
kubectl rollout status deployment/gloss-backend-green -n gloss-prod

# View recent deployments
kubectl rollout history deployment/gloss-backend-blue -n gloss-prod
```

---

**Last Updated**: 2024-01-15  
**Owner**: DevOps Team  
**Next Review**: 2024-04-15