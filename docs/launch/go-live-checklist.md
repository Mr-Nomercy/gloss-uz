# Go-Live Checklist — Gloss Ecosystem Production Launch

## Pre-Launch (T-7 days to T-0)

### Code & Build
- [ ] **Release Branch**: `release/v1.0.0` created, frozen
- [ ] **Version Tags**: Backend `v1.0.0`, Apps `1.0.0 (1)`
- [ ] **Changelog**: `CHANGELOG.md` updated with all changes
- [ ] **Dependencies**: All locked, no vulnerabilities (Snyk/Dependabot clean)
- [ ] **Build Artifacts**: Docker images pushed to registry (`gloss/backend:v1.0.0`, etc.)
- [ ] **Mobile Builds**: IPA/APK/AAB uploaded to TestFlight/Play Console (internal track)
- [ ] **Source Maps**: Uploaded to Sentry for all 3 apps + backend

### Database
- [ ] **Migrations**: All Prisma migrations applied to staging, verified
- [ ] **Migration Script**: `prisma migrate deploy` tested on staging copy
- [ ] **Rollback Plan**: Down migrations tested for last 3 migrations
- [ ] **Seed Data**: Roles, permissions, categories, service types, system configs seeded
- [ ] **Indexes**: All planned indexes created, `ANALYZE` run
- [ ] **Partitioning**: `location_points` monthly partitions created for next 3 months
- [ ] **Extensions**: `pg_trgm`, `postgis`, `uuid-ossp` enabled
- [ ] **Backup**: Base backup taken <24h before launch, PITR verified

### Infrastructure
- [ ] **Kubernetes/ECS**: All services deployed to production namespace/cluster
- [ ] **Replicas**: API ≥3, WS ≥3, Workers ≥2 each type
- [ ] **HPA**: Configured (CPU >70%, Memory >80%, Custom: RPS >1000/pod)
- [ ] **Resources**: Limits/Requests set (no unbounded pods)
- [ ] **Network Policies**: Restrict inter-service traffic
- [ ] **Pod Disruption Budgets**: `minAvailable: 2` for API/WS
- [ ] **Ingress/ALB**: Configured, WAF attached, SSL termination
- [ ] **DNS**: Records created, TTL lowered to 60s (T-1h), validated
- [ ] **CDN**: Configured for static assets, cache rules set
- [ ] **MinIO**: 4+ nodes, erasure coding, replication, lifecycle policies
- [ ] **Redis**: Cluster mode, 3+ shards, AOF + RDB, replica
- [ ] **PostgreSQL**: Primary + 1 replica, PgBouncer, PITR, automated backups

### Configuration & Secrets
- [ ] **Secrets**: All in Vault/Secrets Manager (DB, Redis, MinIO, JWT, Click, Payme, FCM, Yandex, SMS, Email, Sentry)
- [ ] **No Secrets in ConfigMaps/Code**: Verified with `trufflehog`/`git-secrets`
- [ ] **Feature Flags**: All new features behind flags (default OFF for launch)
- [ ] **System Configs**: Commission, min amounts, payout schedules, radius loaded in DB
- [ ] **CORS**: Restricted to production app domains only
- [ ] **Rate Limits**: Auth 10/min, Payment 30/min, API 1000/min per IP
- [ ] **Certificate Pinning**: Prod pins configured in app builds

### Monitoring & Observability
- [ ] **Prometheus**: All targets UP (API, WS, DB, Redis, MinIO, Node, kube-state)
- [ ] **Grafana**: Dashboards provisioned (Business, Technical, Infra, WS, Payments, DB, Queues)
- [ ] **Alert Rules**: All defined, tested (fired in staging), routed to PagerDuty
- [ ] **Alertmanager**: Inhibition rules, grouping, routes configured
- [ ] **Sentry**: Backend + 3 apps projects, source maps, release tracking
- [ ] **Loki**: Logs ingesting, labels structured (service, level, trace_id)
- [ ] **Tempo/Jaeger**: Traces sampling 10%, error traces 100%
- [ ] **Uptime Checks**: External (Pingdom/BetterUptime) on `/health`, `/api/health`, WS
- [ ] **Log Retention**: 30d hot, 1yr cold (S3/GCS)
- [ ] **Metric Retention**: 15d Prometheus, 1yr Thanos/Cortex

### Security
- [ ] **WAF**: OWASP CRS enabled, rate limiting, geo-blocking (if needed)
- [ ] **Network Policies**: Default deny, explicit allow
- [ ] **mTLS**: Service mesh (Istio/Linkerd) or application-level mTLS
- [ ] **Image Scanning**: Trivy/Claire in CI, no Critical/High in prod images
- [ ] **Admission Control**: Kyverno/OPA policies (no privileged, no hostPath, etc.)
- [ ] **Audit Logging**: Kubernetes audit logs to Loki
- [ ] **Penetration Test**: Recent report, Critical/High findings resolved

### External Integrations
- [ ] **Click**: Prod Merchant ID, Secret, Webhook URL (`https://api.gloss.uz/webhooks/click`), Test transaction ✅
- [ ] **Payme**: Prod Merchant ID, Key, Webhook URL (`https://api.gloss.uz/webhooks/payme`), Test transaction ✅
- [ ] **Firebase/FCM**: Server key, Sender ID, Test push to each app ✅
- [ ] **Yandex MapKit**: iOS/Android/Web API keys, quota verified
- [ ] **SMS Provider**: Eskiz/PlayMobile credentials, templates approved
- [ ] **Email Provider**: SendGrid/Mailgun domain verified, templates tested
- [ ] **Sentry**: DSNs configured in apps + backend

### Mobile Apps
- [ ] **Client App**: `1.0.0 (1)` — TestFlight/Play Internal ✅, Certificate pinning prod ✅
- [ ] **Provider App**: `1.0.0 (1)` — TestFlight/Play Internal ✅, Certificate pinning prod ✅
- [ ] **Courier App**: `1.0.0 (1)` — TestFlight/Play Internal ✅, Certificate pinning prod ✅
- [ ] **Seller App**: `1.0.0 (1)` — TestFlight/Play Internal ✅, Certificate pinning prod ✅
- [ ] **Deep Links**: `gloss://`, `gloss-provider://`, `gloss-courier://`, `gloss-seller://` verified
- [ ] **App Store / Play Console**: Listings ready, privacy policy URLs, content ratings
- [ ] **Root/Jailbreak Detection**: Enabled, warning shown
- [ ] **Certificate Pinning**: Production pins in all apps

### Documentation & Runbooks
- [ ] **API Docs**: Swagger/OpenAPI published at `https://api.gloss.uz/docs`
- [ ] **Runbooks**: All in `docs/runbooks/` (Deploy, Rollback, Scale, Incident, DB, Payments, WS, Queues)
- [ ] **Architecture Decision Records**: Current in `docs/adr/`
- [ ] **On-Call Schedule**: Next 4 weeks in PagerDuty, handoff doc updated
- [ ] **Escalation Paths**: Documented in `incident-escalation.md`
- [ ] **Launch Plan**: This checklist + `first-48-hours.md` shared with all leads

### Testing & Quality Gates
- [ ] **Load Test**: k6 — 10k RPS orders, 5k WS connections — PASSED
- [ ] **E2E Tests**: Flutter Patrol — Critical paths passing on staging
- [ ] **Integration Tests**: Backend — All flows passing
- [ ] **Security Scan**: SAST/DAST/Dependency — No Critical/High
- [ ] **Accessibility**: axe-core — WCAG AA passing
- [ ] **Performance**: Lighthouse >90, App cold start <3s
- [ ] **UAT Sign-Off**: All stakeholders signed `uat-signoff.md` — GO decision

### Compliance & Legal
- [ ] **Privacy Policy**: Published, linked in apps
- [ ] **Terms of Service**: Published, linked in apps
- [ ] **Data Processing Agreement**: With subprocessors (Click, Payme, Firebase, Yandex, SMS, Email)
- [ ] **GDPR**: Data export + deletion endpoints tested
- [ ] **PCI DSS**: SAQ-A (redirect payments), no card data stored
- [ ] **Local Regulations**: Uzbekistan data localization (if applicable)

---

## Launch Day (T-0) — Final 2 Hours

### T-2h to T-1h
- [ ] **Code Freeze**: No merges to `release/v1.0.0`
- [ ] **Staging Final Smoke**: Full E2E on staging with prod-like data
- [ ] **DNS TTL**: Lowered to 60s (if not already)
- [ ] **Team Standup**: 15min — Final status, roles confirmed
- [ ] **War Room**: Google Meet link shared in `#launch-updates`
- [ ] **On-Call**: Primary + Secondary confirmed available
- [ ] **Feature Flags**: All launch features OFF (will enable post-deploy)

### T-1h to T-0
- [ ] **Deploy to Green**: `kubectl apply -k overlays/prod-green` (or equivalent)
- [ ] **Green Health Checks**: All pods Ready, `/health` 200, WS connects
- [ ] **Green Smoke Tests**: `scripts/launch-verify.sh` against green
- [ ] **Feature Flags ON**: Enable launch features in green
- [ ] **Traffic Switch**: ALB target group swap / Ingress update
- [ ] **DNS Cutover** (if needed): Verify propagation
- [ ] **T+0**: **LAUNCH** 🚀

---

## Post-Launch (T+0 to T+30min)

| Check | Command | Expected | ✅ |
|-------|---------|----------|----|
| API Health | `curl https://api.gloss.uz/health` | `{"status":"ok"}` | |
| WS Health | `wscat -c wss://ws.gloss.uz/health` | Connected, pong | |
| DB | `kubectl exec pg-primary -- pg_isready` | Accepting connections | |
| Redis | `redis-cli -h redis-prod ping` | PONG | |
| MinIO | `mc admin info minio/prod` | 4 drives OK | |
| Prometheus | `curl prometheus:9090/api/v1/targets` | All UP | |
| Sentry | Open Sentry → Releases → `v1.0.0` | Events flowing | |
| First Order | Place test order (Client→Provider→Courier) | Completes in <2min | |
| Payment | Test Click + Payme (small amount) | Success, webhook received | |
| Push | Send test FCM to each app | Received on device | |
| Tracking | Start order, verify live map | Courier marker moves | |

---

## Rollback Criteria (Any = Immediate Rollback)

- [ ] Data corruption / loss detected
- [ ] Payment calculation incorrect (wrong amounts)
- [ ] Auth completely broken (no login, token refresh fails)
- [ ] API error rate >5% for >5min
- [ ] Database unreachable >2min
- [ ] Critical security vulnerability exploited

### Rollback Procedure
1. `kubectl` switch ALB/Ingress back to Blue target group
2. Verify Blue health checks passing
3. Run smoke tests on Blue
4. Notify `#launch-updates`: "ROLLED BACK — investigating"
5. Investigate on Green (now inactive)
6. Post-mortem within 24h

---

## Sign-Off

| Role | Name | ✅ Ready | Signature | Time |
|------|------|----------|-----------|------|
| Release Manager | | | | |
| DevOps Lead | | | | |
| Backend Lead | | | | |
| Flutter Lead | | | | |
| QA Lead | | | | |
| Payments Lead | | | | |
| Security Lead | | | | |
| Product Owner | | | | |
| Engineering Manager | | | | |

**Launch Decision**: ☐ **GO** ☐ **NO-GO** ☐ **DEFER**

**Launch Time**: _______________
**Launch Version**: Backend `v1.0.0` | Apps `1.0.0 (1)`

---

**Checklist Version**: 1.0
**Last Updated**: _______________