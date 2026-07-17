# Post-Launch Retrospective — Gloss Ecosystem

## Session Info
- **Date**: _______________
- **Facilitator**: _______________
- **Attendees**: _______________
- **Launch Date**: _______________
- **Version**: Backend `v1.0.0` | Apps `1.0.0 (1)`

---

## 1. Launch Metrics Summary (First 48 Hours)

| Metric | Target | Actual (0-24h) | Actual (24-48h) | Trend | Status |
|--------|--------|----------------|-----------------|-------|--------|
| API Availability | >99.9% | | | | ☐ |
| API P95 Latency | <500ms | | | | ☐ |
| Payment Success Rate | >99.5% | | | | ☐ |
| Order Assignment Rate | >95% | | | | ☐ |
| WS Connection Stability | <5% drops | | | | ☐ |
| Crash-Free Sessions | >99.9% | | | | ☐ |
| FCM Delivery Rate | >98% | | | | ☐ |
| Peak Orders/min | N/A | | | | — |
| Error Budget Used | <20% | | | | ☐ |

**Data Sources**: Grafana "Launch Overview", "Business KPIs", Sentry, FCM Console

---

## 2. Incident Timeline

| Time (UZT) | Severity | Title | Duration | Root Cause | Resolved? |
|------------|----------|-------|----------|------------|-----------|
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |

**Total Incidents**: P0: ___  P1: ___  P2: ___  P3: ___
**Total Incident Minutes**: _______
**MTTA (Mean Time to Acknowledge)**: _______
**MTTR (Mean Time to Resolve)**: _______

---

## 3. What Went Well 🎉

| # | Item | Category | Impact | Kudos To |
|---|------|----------|--------|----------|
| 1 | | ☐ Tech ☐ Process ☐ Team | | |
| 2 | | ☐ Tech ☐ Process ☐ Team | | |
| 3 | | ☐ Tech ☐ Process ☐ Team | | |
| 4 | | ☐ Tech ☐ Process ☐ Team | | |
| 5 | | ☐ Tech ☐ Process ☐ Team | | |

*Categories: Technical (architecture, code, tools), Process (CI/CD, testing, communication), Team (collaboration, support, morale)*

---

## 4. What Could Be Better 📈

| # | Item | Category | Impact (H/M/L) | Root Cause Hypothesis |
|---|------|----------|----------------|----------------------|
| 1 | | ☐ Tech ☐ Process ☐ Team | | |
| 2 | | ☐ Tech ☐ Process ☐ Team | | |
| 3 | | ☐ Tech ☐ Process ☐ Team | | |
| 4 | | ☐ Tech ☐ Process ☐ Team | | |
| 5 | | ☐ Tech ☐ Process ☐ Team | | |

---

## 5. Surprises / Unknowns 🤔

| # | Surprise | Why Unexpected | What We Learned |
|---|----------|----------------|-----------------|
| 1 | | | |
| 2 | | | |
| 3 | | | |

---

## 6. Capacity & Scaling Observations

| Component | Peak Utilization | Headroom | Scaling Triggered? | Notes |
|-----------|------------------|----------|-------------------|-------|
| API Pods (CPU) | | | ☐ Yes ☐ No | |
| API Pods (Memory) | | | ☐ Yes ☐ No | |
| WS Pods (Connections) | | | ☐ Yes ☐ No | |
| PostgreSQL (CPU) | | | ☐ Yes ☐ No | |
| PostgreSQL (Connections) | | | ☐ Yes ☐ No | |
| Redis (Memory) | | | ☐ Yes ☐ No | |
| Redis (CPU) | | | ☐ Yes ☐ No | |
| MinIO (Disk) | | | ☐ Yes ☐ No | |
| Queue: Assignment | | | ☐ Yes ☐ No | |
| Queue: Notifications | | | ☐ Yes ☐ No | |
| Queue: Payouts | | | ☐ Yes ☐ No | |

**Scaling Decisions Made**:
- 
- 

**Capacity Plan Updates Needed**:
- 

---

## 7. User Feedback & Support

| Channel | Volume | Top Issues | Sentiment |
|---------|--------|------------|-----------|
| In-App Support | | | ☐ + ☐ ~ ☐ - |
| App Store Reviews | | | ☐ + ☐ ~ ☐ - |
| Play Store Reviews | | | ☐ + ☐ ~ ☐ - |
| Social Media | | | ☐ + ☐ ~ ☐ - |
| Call Center | | | ☐ + ☐ ~ ☐ - |

**Critical User-Facing Bugs Reported**:
- 

---

## 8. Action Items 🎯

| # | Action | Category | Owner | Due Date | Ticket | Success Metric |
|---|--------|----------|-------|----------|--------|----------------|
| 1 | | ☐ Tech ☐ Process ☐ Monitor ☐ Docs ☐ Security | | | | |
| 2 | | ☐ Tech ☐ Process ☐ Monitor ☐ Docs ☐ Security | | | | |
| 3 | | ☐ Tech ☐ Process ☐ Monitor ☐ Docs ☐ Security | | | | |
| 4 | | ☐ Tech ☐ Process ☐ Monitor ☐ Docs ☐ Security | | | | |
| 5 | | ☐ Tech ☐ Process ☐ Monitor ☐ Docs ☐ Security | | | | |
| 6 | | ☐ Tech ☐ Process ☐ Monitor ☐ Docs ☐ Security | | | | |
| 7 | | ☐ Tech ☐ Process ☐ Monitor ☐ Docs ☐ Security | | | | |
| 8 | | ☐ Tech ☐ Process ☐ Monitor ☐ Docs ☐ Security | | | | |
| 9 | | ☐ Tech ☐ Process ☐ Monitor ☐ Docs ☐ Security | | | | |
| 10 | | ☐ Tech ☐ Process ☐ Monitor ☐ Docs ☐ Security | | | | |

*Categories: Technical, Process, Monitoring, Documentation, Security*

---

## 9. Runbook & Documentation Updates

| Document | Update Needed? | Owner | Due |
|----------|----------------|-------|-----|
| `docs/runbooks/rollback.md` | ☐ | | |
| `docs/runbooks/high-error-rate.md` | ☐ | | |
| `docs/runbooks/payment-failures.md` | ☐ | | |
| `docs/runbooks/ws-connection-issues.md` | ☐ | | |
| `docs/runbooks/db-performance.md` | ☐ | | |
| `docs/runbooks/queue-backlog.md` | ☐ | | |
| `docs/launch/first-48-hours.md` | ☐ | | |
| `docs/launch/incident-escalation.md` | ☐ | | |
| `docs/launch/go-live-checklist.md` | ☐ | | |
| On-call handoff doc | ☐ | | |

---

## 10. Team Health & Morale

| Aspect | Rating (1-5) | Notes |
|--------|--------------|-------|
| Workload during launch | | |
| Communication clarity | | |
| Tooling adequacy | | |
| Support from leadership | | |
| Celebration / Recognition | | |

**Burnout Risk**: ☐ Low ☐ Medium ☐ High
**Mitigation**: 

---

## 11. Next Release Improvements

Based on this retrospective, top 3 priorities for v1.1:

1. 
2. 
3. 

---

## 12. Appreciations 🙌

| Person | For What |
|--------|----------|
| | |
| | |
| | |
| | |

---

## Sign-Off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Facilitator | | | |
| Engineering Manager | | | |
| Product Owner | | | |
| DevOps Lead | | | |
| Backend Lead | | | |
| Flutter Lead | | | |
| QA Lead | | | |

---

## Distribution
- [ ] Engineering Team (Confluence/Notion)
- [ ] Product Team
- [ ] Leadership
- [ ] Archived in `docs/retrospectives/YYYY-MM-DD-launch-retro.md`

---

**Template Version**: 1.0
**Next Retrospective**: _______________ (recommended: 2 weeks post-launch)