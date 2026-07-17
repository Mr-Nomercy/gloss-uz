# Incident Escalation & On-Call Procedures — Gloss Ecosystem

## On-Call Rotation

### Schedule (Follow-the-Sun, 2-Week Rotation)

| Week | Primary (Backend) | Secondary (Backend) | Primary (Mobile) | Secondary (Mobile) | DevOps | Engineering Manager |
|------|-------------------|---------------------|------------------|--------------------|--------|---------------------|
| 1 | [Name] | [Name] | [Name] | [Name] | [Name] | [Name] |
| 2 | [Name] | [Name] | [Name] | [Name] | [Name] | [Name] |
| 3 | [Name] | [Name] | [Name] | [Name] | [Name] | [Name] |
| 4 | [Name] | [Name] | [Name] | [Name] | [Name] | [Name] |

**Rotation Handoff**: Monday 10:00 AM UZT (UTC+5)
**Handoff Checklist**: `docs/runbooks/oncall-handoff.md`

### Contact Information
| Role | Name | Phone | Slack | Timezone |
|------|------|-------|-------|----------|
| Backend Primary | | | @ | UZT |
| Backend Secondary | | | @ | UZT |
| Mobile Primary | | | @ | UZT |
| Mobile Secondary | | | @ | UZT |
| DevOps Primary | | | @ | UZT |
| DevOps Secondary | | | @ | UZT |
| Engineering Manager | | | @ | UZT |
| CTO | | | @ | UZT |

---

## Escalation Paths

### Severity Definitions (Aligned with `bug-triage.md`)

| Severity | Definition | Initial Response | Escalation |
|----------|------------|------------------|------------|
| **P0 — Critical** | System down, data loss, payment failure, security breach | ≤5 min | Auto-page Primary → +15min Secondary → +30min EM → +60min CTO |
| **P1 — High** | Major feature broken, payments degraded, WS issues | ≤15 min | Page Primary → +30min Secondary → +60min EM |
| **P2 — Medium** | Partial degradation, non-critical bug | ≤30 min | Slack Primary → +2h Secondary → +4h EM |
| **P3 — Low** | Cosmetic, minor UX, enhancement | Next business day | Assigned in sprint planning |

### Escalation Matrix

```
P0 INCIDENT
    │
    ├─► T+0: Page Backend Primary + DevOps Primary (Slack + Phone + PagerDuty)
    │
    ├─► T+5min: If no ACK → Page Backend Secondary + DevOps Secondary
    │
    ├─► T+15min: If no mitigation → Page Engineering Manager
    │            → Post to #incidents with: Impact, Actions, ETA
    │
    ├─► T+30min: If no resolution → Page CTO
    │            → Consider war room (Google Meet)
    │            → Stakeholder notification (Email to leadership)
    │
    └─► T+60min: If unresolved → Full war room + external support if needed

P1 INCIDENT
    │
    ├─► T+0: Page Backend Primary (or Mobile Primary if app-specific)
    │
    ├─► T+15min: If no ACK → Page Secondary
    │
    ├─► T+30min: If no mitigation → Page Engineering Manager
    │            → Post to #incidents
    │
    └─► T+60min: If unresolved → Consider war room

P2 INCIDENT
    │
    ├─► T+0: Slack @Primary in #bugs-p1 (or #bugs-p2)
    │
    ├─► T+2h: If no response → Slack @Secondary
    │
    └─► T+4h: If no progress → Slack @EM, schedule fix
```

---

## Communication Channels

| Channel | Purpose | Audience | Retention |
|---------|---------|----------|-----------|
| `#incidents` | Active P0/P1 coordination | On-call, Leads, EM, CTO | 90 days |
| `#bugs-p1` | P1 tracking | Assigned engineers, QA, PO | 30 days |
| `#bugs-p2` | P2 tracking | Assigned engineers, QA | 30 days |
| `#launch-updates` | Launch status (first 48h) | All stakeholders | 7 days |
| `#oncall` | On-call handoffs, schedule | On-call team | 30 days |
| PagerDuty | Alerting, paging, acknowledgment | On-call | 1 year |
| Email (incidents@) | Stakeholder notification | Leadership, PO, EM | 1 year |
| Google Meet (War Room) | Live collaboration | Incident responders | N/A |

### War Room Protocol
1. **Trigger**: P0 >15min, or P1 >30min no mitigation, or EM/CTO request
2. **Link**: `meet.google.com/xxx-xxxx-xxx` (pinned in `#incidents`)
3. **Roles**:
   - **Incident Commander** (EM or Senior Lead): Decisions, communication
   - **Tech Lead** (Backend/Mobile/DevOps): Technical direction
   - **Scribe**: Timeline, actions, decisions (in `#incidents` thread)
   - **Communicator**: Stakeholder updates (every 15min for P0)
4. **Agenda** (every 15min):
   - What happened?
   - What's the impact?
   - What are we doing?
   - What's the ETA?
   - What do we need?

---

## Stakeholder Notification

### P0 — Critical (Template)
```
Subject: [P0 INCIDENT] Gloss Production - <Brief Description> - <Time>

Impact: <User-facing impact: e.g., "Payments failing for 100% users", "Apps crashing on launch">
Start Time: <ISO timestamp>
Status: Investigating / Mitigating / Resolving / Resolved
Current Actions: <Bullet list>
Next Update: <Time> (every 15 min for P0)
War Room: <Meet link if active>

Affected: [ ] Payments [ ] Orders [ ] Tracking [ ] Chat [ ] Auth [ ] All
Roles: [ ] Client [ ] Provider [ ] Courier [ ] Seller [ ] Admin
```

**Recipients**: Engineering All, Product, Leadership, Support
**Frequency**: Every 15 min until resolved, then resolution email

### P1 — High (Template)
```
Subject: [P1 INCIDENT] Gloss Production - <Brief Description> - <Time>

Impact: <Description>
Start Time: <ISO timestamp>
Status: Investigating / Mitigating
Current Actions: <Bullet list>
Next Update: <Time> (every 30 min)

Affected: [ ] Payments [ ] Orders [ ] Tracking [ ] Chat [ ] Auth
Roles: [ ] Client [ ] Provider [ ] Courier [ ] Seller [ ] Admin
```

**Recipients**: Engineering Leads, Product, Support
**Frequency**: Every 30 min until resolved

### Resolution Email (P0/P1)
```
Subject: [RESOLVED] <Original Subject>

Incident Duration: <Start> → <End> (<Duration>)
Root Cause: <Summary>
Fix Applied: <Summary>
Prevention: <Action items with owners/timeline>
Post-Mortem: <Link to doc, due within 48h>
```

---

## Runbook References (Linked in Grafana Alerts)

| Alert | Runbook | Owner |
|-------|---------|-------|
| `HighErrorRate` | `docs/runbooks/high-error-rate.md` | Backend |
| `HighLatencyP95` | `docs/runbooks/high-latency.md` | Backend |
| `WSConnectionDrop` | `docs/runbooks/ws-connection-issues.md` | Backend |
| `PaymentFailureRate` | `docs/runbooks/payment-failures.md` | Backend |
| `AssignmentFailureRate` | `docs/runbooks/assignment-failures.md` | Backend |
| `DBConnectionPoolExhausted` | `docs/runbooks/db-connection-pool.md` | DevOps |
| `DBHighCPU` | `docs/runbooks/db-performance.md` | DevOps/Backend |
| `RedisHighMemory` | `docs/runbooks/redis-issues.md` | DevOps |
| `QueueBacklog` | `docs/runbooks/queue-backlog.md` | Backend |
| `MinIOHighErrors` | `docs/runbooks/minio-issues.md` | DevOps |
| `FCMDeliveryFailure` | `docs/runbooks/push-notification-issues.md` | Mobile |
| `CrashRateHigh` | `docs/runbooks/mobile-crash-rate.md` | Mobile |
| `SSLExpiringSoon` | `docs/runbooks/ssl-renewal.md` | DevOps |
| `DiskSpaceCritical` | `docs/runbooks/disk-space.md` | DevOps |

---

## On-Call Responsibilities

### Primary On-Call (Backend)
- Respond to P0/P1 pages within 5/15 min
- Own incident until resolution or handoff
- Run diagnostics, apply mitigations, deploy hotfixes
- Update `#incidents` every 15min (P0) / 30min (P1)
- Post-incident: Write post-mortem (due 48h)

### Secondary On-Call (Backend)
- Backup if primary unavailable
- Assist with investigation, parallel debugging
- Take over if primary >30min unresponsive

### Primary On-Call (Mobile)
- Respond to app crashes, FCM issues, build issues
- Coordinate with backend on API-related mobile issues
- Hotfix builds if needed (TestFlight/Play Console)

### DevOps On-Call
- Infrastructure: K8s, DB, Redis, MinIO, DNS, SSL, CDN
- Deployments, rollbacks, scaling
- CI/CD pipeline issues

### Engineering Manager
- Escalation point for P0/P1
- Stakeholder communication
- Resource allocation, war room coordination
- Post-mortem review & action tracking

---

## Handoff Procedure (Monday 10:00 UZT)

### Outgoing On-Call
1. Update `docs/runbooks/oncall-handoff.md` with:
   - Active incidents (link, status, next steps)
   - Known issues / watch items
   - Deployments this week
   - Capacity concerns
   - Upcoming changes (migrations, config changes)
2. Slack in `#oncall`: "Handoff complete — see doc"
3. Verbally brief incoming (call or huddle)

### Incoming On-Call
1. Read handoff doc
2. Review open P0/P1 in Jira/Linear
3. Check Grafana "On-Call" dashboard
4. Confirm PagerDuty schedule active
5. Acknowledge in `#oncall`: "On-call active"

---

## Post-Incident Process

### Within 1 Hour (P0) / 4 Hours (P1)
- [ ] Incident resolved, monitoring stable
- [ ] `#incidents` thread marked ✅ Resolved
- [ ] Stakeholder resolution email sent

### Within 24 Hours
- [ ] Timeline documented (from `#incidents` + logs)
- [ ] Root cause analysis started
- [ ] Action items identified with owners

### Within 48 Hours
- [ ] Post-mortem document completed (`docs/postmortems/YYYY-MM-DD-<title>.md`)
- [ ] Post-mortem review meeting (30 min)
- [ ] Action items created in Jira/Linear with due dates
- [ ] Shared with engineering team

### Post-Mortem Template
```markdown
# Post-Mortem: <Title> — <Date>

## Summary
- **Duration**: <Start> → <End> (<Total>)
- **Severity**: P0/P1
- **Impact**: <User-facing description>
- **Root Cause**: <One sentence>

## Timeline (UTC+5)
- HH:MM — <Event>
- HH:MM — <Event>

## Root Cause Analysis
- **What happened**: <Technical details>
- **Why**: <5 Whys>
- **Contributing Factors**: <List>

## Resolution
- **Mitigation**: <What stopped the bleeding>
- **Fix**: <Permanent fix>

## Action Items
| # | Action | Owner | Due Date | Ticket |
|---|--------|-------|----------|--------|
| 1 | | | | |
| 2 | | | | |

## Lessons Learned
- What went well:
- What didn't:
- Lucky breaks:
```

---

## On-Call Compensation & Wellbeing

- **On-Call Week**: 1 day comp time (or equivalent)
- **P0 Page (night 22:00-08:00)**: Additional 0.5 day comp
- **Max 2 pages/night** before escalation to secondary
- **No pages for 48h post-incident** for responder (recovery time)
- **Mental Health**: Encourage use of EAP, discuss in 1:1s

---

## Emergency Contacts (External)

| Service | Contact | Account/Details |
|---------|---------|-----------------|
| Cloud Provider (AWS/GCP/Yandex) | Support Portal | Enterprise Support |
| Click (Payment) | +998 78 120-00-00 | Merchant ID: xxx |
| Payme (Payment) | support@payme.uz | Merchant ID: xxx |
| Yandex Maps/MapKit | api-support@yandex.ru | API Key: xxx |
| Firebase/FCM | Firebase Console | Project: gloss-ecosystem |
| Sentry | Sentry Dashboard | Org: gloss |
| Grafana Cloud | Grafana Cloud Portal | Org: gloss |
| PagerDuty | PagerDuty Dashboard | Account: gloss |

---

**Document Version**: 1.0
**Last Updated**: _______________
**Next Review**: _______________
**Approved By**: _______________