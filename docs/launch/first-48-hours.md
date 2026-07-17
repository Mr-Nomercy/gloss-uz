# First 48 Hours Monitoring Plan — Gloss Ecosystem Launch

## Overview
Hour-by-hour monitoring plan for the first 48 hours post-launch. Goal: Detect issues early, maintain stability, build confidence.

**Command Center**: `#launch-updates` (Slack) + War Room (Google Meet, on standby)
**On-Call**: Per `incident-escalation.md` rotation
**Dashboard**: Grafana "Launch Overview" (provisioned)

---

## Hour 0–1: Launch & Initial Ramp (T+0 to T+1h)

### Focus: Traffic ramp, error rates, latency, core health

| Time | Action | Owner | Success Criteria |
|------|--------|-------|------------------|
| T+0 | **Launch**: Blue-green switch, DNS cutover | DevOps | All health checks green |
| T+2m | Run `scripts/launch-verify.sh` | DevOps | All checks ✅ |
| T+5m | Verify first real orders: Client → Provider → Courier | QA + PO | 3+ test orders complete |
| T+10m | Confirm payment flow: Click + Payme test transactions | Payments Lead | 2+ successful payments |
| T+15m | Verify WS connections: All 4 apps connecting | Backend | WS connections >0, <5% drops |
| T+20m | Check push notifications: FCM delivery to all apps | Mobile | Test push received on each |
| T+30m | **First Status Update** in `#launch-updates` | Release Manager | Summary posted |
| T+45m | Verify payout batch workers idle (no premature runs) | Backend | Workers waiting correctly |
| T+60m | **Hour 1 Review**: Error rate, latency, order volume | All Leads | Error rate <0.5%, p95 <500ms |

### Key Dashboards (Grafana)
- `Launch Overview` — Top-level health
- `API Golden Signals` — Rate, Errors, Duration (RED)
- `WebSocket Health` — Connections, messages, drops
- `Payments` — Success rate, latency, webhook processing

### Alerts to Watch (Silence non-critical)
- ✅ `HighErrorRate` (P0)
- ✅ `HighLatencyP95` (P1)
- ✅ `WSConnectionDrop` (P1)
- ✅ `PaymentFailureRate` (P0)
- ⚠️ `QueueBacklog` (P2 — monitor only)
- ⚠️ `DBHighCPU` (P2 — monitor only)

### Go/No-Go for Ramp
- **GO**: Error rate <0.5%, p95 <500ms, payments working, WS stable
- **HOLD**: Any P0/P1 firing, or error rate >1%
- **ROLLBACK**: Data corruption, payment calculation wrong, auth broken

---

## Hour 1–6: Stabilization & Payment Focus (T+1h to T+6h)

### Focus: Payment success rates, WS connections, order completion

| Time | Action | Owner | Success Criteria |
|------|--------|-------|------------------|
| T+1h | Verify order assignment: Provider + Courier notified | Backend | Assignment rate >95% |
| T+1h 30m | Check tracking: Live location updates on map | Mobile + Backend | Polyline rendering, ETA updating |
| T+2h | **Payment Deep Dive**: Click/Payme success rates, callback latency | Payments Lead | >99.5% success, callback <3s |
| T+2h 30m | Verify chat: Client↔Provider, Client↔Courier, Provider↔Courier | Backend | Messages delivering <1s |
| T+3h | Check KYC queue: Admin can approve/reject | Admin Lead | KYC flow works end-to-end |
| T+4h | Verify payout calculations (dry run): Provider/Courier/Seller | Backend | Amounts match expected |
| T+5h | **Mid-Shift Status Update** in `#launch-updates` | Release Manager | Metrics snapshot |
| T+6h | Review error logs: Any new patterns? | Backend + Mobile | No new error types |

### Key Metrics (Hourly)
| Metric | Target | Alert If |
|--------|--------|----------|
| API Error Rate | <0.5% | >1% |
| API P95 Latency | <500ms | >1s |
| Payment Success | >99.5% | <99% |
| Order Assignment | >95% | <90% |
| WS Drop Rate | <2% | >5% |
| Order Completion | >90% | <80% |
| Crash-Free Sessions | >99.9% | <99.5% |

### Capacity Checks
- [ ] API CPU <60%, Memory <70%
- [ ] DB CPU <50%, Connections <60%
- [ ] Redis Memory <60%
- [ ] Queue depths <100

---

## Hour 6–24: Peak Load & Database Performance (T+6h to T+24h)

### Focus: Peak traffic handling, database performance, queue depths

| Time | Action | Owner | Success Criteria |
|------|--------|-------|------------------|
| T+6h | **Peak Preparation**: Verify HPA scaling policies active | DevOps | Replicas scaling on CPU>70% |
| T+8h | Morning rush (08:00-10:00): Monitor order volume spike | All | System handles 2x baseline |
| T+10h | Check DB: Slow query log, index usage, vacuum status | Backend/DevOps | No queries >1s, no bloat |
| T+12h | **Lunch Peak** (12:00-14:00): Highest order volume expected | All | Error rate <0.5%, latency stable |
| T+14h | Verify tracking under load: 3-5s updates for 100+ active | Backend | No lag, smooth polylines |
| T+16h | Check offline sync: Apps reconnecting after background | Mobile | Sync completes <30s |
| T+18h | Evening peak (18:00-21:00): Final high-load period | All | Stable through peak |
| T+22h | Pre-night review: Error budget, capacity headroom | Leads | Budget >50% remaining |
| T+24h | **24-Hour Status Report** in `#launch-updates` | Release Manager | Full metrics + incidents |

### Database Focus
- [ ] `pg_stat_statements`: Top 10 queries all <100ms
- [ ] No blocking locks >5s
- [ ] Replication lag <1s
- [ ] Autovacuum keeping up (check `pg_stat_progress_vacuum`)
- [ ] Partition maintenance: `location_points` monthly partitions created

### Queue Monitoring
| Queue | Normal Depth | Alert Threshold | Action |
|-------|--------------|-----------------|--------|
| `order-assignment` | <10 | >100 | Scale workers |
| `payment-webhook` | <5 | >50 | Scale workers |
| `fcm-notifications` | <20 | >200 | Scale workers |
| `payout-batch` | 0 (scheduled) | >0 off-schedule | Investigate |
| `analytics-aggregation` | <50 | >500 | Scale workers |

---

## Hour 24–48: Stability Trends & Capacity Planning (T+24h to T+48h)

### Focus: Trend analysis, capacity planning, operational rhythm

| Time | Action | Owner | Success Criteria |
|------|--------|-------|------------------|
| T+24h | **Daily Standup (Launch Edition)**: Review 24h metrics | All Leads | Action items for Day 2 |
| T+26h | Analyze error trends: Any recurring patterns? | Backend | No new error patterns |
| T+28h | Review user feedback: Support tickets, app store reviews | PO + Support | No critical UX issues |
| T+30h | Capacity review: Project 7-day growth, plan scaling | DevOps | Scaling plan documented |
| T+32h | Verify backup/restore: Test restore to staging | DevOps | RTO <1h, RPO <15m confirmed |
| T+36h | Check SSL cert expiry, domain renewals | DevOps | All >90 days |
| T+40h | Review on-call handoff: Any knowledge gaps? | EM | Handoff doc updated |
| T+44h | **Pre-Weekend Check**: Stability for unattended hours | All | No P0/P1 risk |
| T+48h | **48-Hour Status Report** → Leadership | Release Manager | Executive summary |

### Trend Analysis (Grafana: 48h window)
- [ ] Error rate: Stable or decreasing
- [ ] Latency (p50/p95/p99): Stable
- [ ] Throughput: Matching business projections
- [ ] WS connections: Growing steadily
- [ ] Payment success: >99.5% sustained
- [ ] Crash rate: <0.1% sustained
- [ ] DB performance: No degradation
- [ ] Cache hit rate: >95%

### Capacity Planning Outputs
| Resource | Current Peak | 7-Day Projection | Action |
|----------|--------------|------------------|--------|
| API Replicas | | | ☐ Scale up ☐ OK |
| DB CPU | | | ☐ Read replica ☐ OK |
| DB Storage | | | ☐ Expand ☐ OK |
| Redis Memory | | | ☐ Add node ☐ OK |
| MinIO Storage | | | ☐ Expand ☐ OK |
| Queue Workers | | | ☐ Scale ☐ OK |

---

## Communication Cadence

| Channel | Frequency | Content | Audience |
|---------|-----------|---------|----------|
| `#launch-updates` | Hourly (0-6h), then 4h | Metrics snapshot, incidents, actions | All stakeholders |
| `#incidents` | Real-time | P0/P1 coordination | On-call, Leads |
| Email (leadership) | T+1h, T+6h, T+24h, T+48h | Executive summary | Leadership, PO |
| War Room | As needed (P0/P1) | Live collaboration | Responders |

### Status Update Template (for `#launch-updates`)
```
📊 **Launch Status — T+<X>h** — <Timestamp>

🟢 **Health**: <OK / DEGRADED / CRITICAL>
📈 **Orders/min**: <current> (peak: <peak>)
💳 **Payment Success**: <XX.X>%
⚡ **API P95**: <XXX>ms
🔌 **WS Connections**: <XXX> (drop rate: <X>%)
🐛 **Error Rate**: <X.XX>%
📱 **Crash-Free**: <XX.X>%

🚨 **Active Incidents**: <#P0, #P1> — <brief>
✅ **Completed**: <key achievements>
🔄 **In Progress**: <current focus>
📋 **Next**: <next hour priorities>

<@oncall> <@leads>
```

---

## Escalation Triggers (Auto-Page)

| Condition | Severity | Action |
|-----------|----------|--------|
| Error rate >2% for 5min | P0 | Page Backend + DevOps |
| Payment success <99% for 5min | P0 | Page Payments + Backend |
| WS drop rate >10% for 5min | P0 | Page Backend |
| API p99 >3s for 5min | P1 | Page Backend |
| DB connections >85% pool | P1 | Page DevOps |
| Crash rate >0.5% | P1 | Page Mobile |
| Queue depth >1000 for 10min | P1 | Page Backend |
| Disk >85% | P1 | Page DevOps |

---

## Runbook Quick Links

| Scenario | Runbook |
|----------|---------|
| High error rate | `docs/runbooks/high-error-rate.md` |
| Payment failures | `docs/runbooks/payment-failures.md` |
| WS connection issues | `docs/runbooks/ws-connection-issues.md` |
| DB performance | `docs/runbooks/db-performance.md` |
| Queue backlog | `docs/runbooks/queue-backlog.md` |
| Mobile crashes | `docs/runbooks/mobile-crash-rate.md` |
| Scale API | `docs/runbooks/scale-api.md` |
| Scale DB | `docs/runbooks/scale-db.md` |
| Rollback | `docs/runbooks/rollback.md` |

---

## Success Criteria (48h)

- [ ] Zero P0 incidents unresolved
- [ ] Zero P1 incidents without workaround
- [ ] Error rate <0.5% sustained
- [ ] Payment success >99.5%
- [ ] API p95 <500ms sustained
- [ ] Order assignment >95%
- [ ] Crash-free sessions >99.9%
- [ ] No data loss / corruption
- [ ] All monitoring green
- [ ] On-call team confident for weekend

---

**Document Version**: 1.0
**Launch Date**: _______________
**Prepared By**: _______________
**Approved By**: _______________