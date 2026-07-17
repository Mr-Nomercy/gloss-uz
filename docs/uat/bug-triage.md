# Bug Triage Process — Gloss Ecosystem

## Severity Classification (P0–P3)

| Severity | Label | Definition | SLA | Launch Blocker |
|----------|-------|------------|-----|----------------|
| **P0** | **Critical** | System down, data loss/corruption, payment failure, security breach, auth bypass, legal/compliance violation | **Immediate** (≤ 1 hour response, fix ASAP) | **YES** — Blocks launch |
| **P1** | **High** | Major feature broken, core flow broken, payment partial failure, data inconsistency, auth issues, WS connection failure | **≤ 4 hours** (fix or workaround) | **YES** — Blocks launch |
| **P2** | **Medium** | Feature partially working, UX degradation, non-critical bug, performance degradation, offline sync issues | **≤ 24–48 hours** | **Conditional** — Launch with workaround |
| **P3** | **Low** | Cosmetic, minor UI issue, enhancement, typo, non-blocking edge case | **Next sprint / backlog** | **NO** — Post-launch |

---

## Detailed Severity Criteria

### P0 — Critical (Launch Blockers)
- **System Availability**: API gateway down, DB unavailable, all apps crash on launch
- **Payments**: Payment initiation fails, webhook not processed, payout calculation wrong, refund fails
- **Security**: Auth bypass, SQL injection, XSS, PII exposure, token leak, webhook signature bypass
- **Data Integrity**: Order loss, duplicate orders, incorrect payout amounts, audit log gaps
- **Core Flows**: Order creation fails, assignment fails, tracking broken, chat message loss
- **Compliance**: KYC bypass, GDPR violation, payment regulation breach

### P1 — High (Launch Blockers)
- **Core Features**: Service booking fails, product checkout fails, schedule selection broken
- **Payments**: One payment method fails (Click works, Payme fails), callback timeout handling
- **Real-time**: WebSocket disconnects frequently, location updates stop, push notifications fail
- **Assignment**: Provider/courier not notified, assignment algorithm error, timeout logic broken
- **Tracking**: Map not loading, polyline broken, ETA calculation wrong
- **Auth**: Token refresh fails, role switching broken, session management issues
- **Offline**: Offline queue not syncing, data loss on sync, conflict resolution broken

### P2 — Medium (Can Launch with Workaround)
- **UX Issues**: Slow screen loads (>3s), confusing error messages, poor empty states
- **Performance**: List scrolling lag, image load delays, search slow (>2s)
- **Partial Features**: Promo code edge cases, address autocomplete slow, filter combos broken
- **Offline**: Slow sync, conflicts not auto-resolved, manual retry needed
- **Notifications**: Delayed push (>5min), badge count stale, deep link edge cases
- **Localization**: Missing translations, RTL issues, date/number format wrong
- **Accessibility**: Missing labels, contrast issues, focus order wrong
- **Edge Cases**: Cancel edge cases, refund partial, schedule edge cases

### P3 — Low (Post-Launch Backlog)
- **Cosmetic**: Alignment off, color mismatch, typo, icon wrong
- **Enhancements**: Better loading states, skeleton improvements, animation polish
- **Nice-to-have**: Additional filters, sort options, keyboard shortcuts
- **Documentation**: Missing help text, unclear error messages

---

## Triage Process

### 1. Bug Report Submission
**Template**: Use `uat-feedback-form.md` or Jira bug template
**Required Fields**:
- Title: `[P0-P3] <Component> - <Brief description>`
- Severity: P0/P1/P2/P3 (reporter suggests, triage confirms)
- Steps to Reproduce: Numbered, minimal steps
- Expected vs Actual Behavior
- Environment: Device, OS, App version, Backend version, Network
- Logs/Screenshots/Video: Required for P0/P1
- Frequency: Always / Intermittent / Once
- Role(s) Affected: Client / Provider / Courier / Seller / Admin / All

### 2. Triage Meeting (Daily during UAT, 2x/day during launch)
**Attendees**: QA Lead, Backend Lead, Flutter Lead, Product Owner
**Duration**: 15-30 min
**Agenda**:
1. Review new P0/P1 since last triage
2. Confirm severity assignments
3. Assign owner + ETA
4. Update launch blocker list
5. Communicate status to stakeholders

### 3. Severity Reassessment
- **Downgrade**: If workaround found, impact lower than thought → P1→P2, P2→P3
- **Upgrade**: If impact wider, data loss discovered → P2→P1, P1→P0
- **Requires**: QA Lead + relevant Tech Lead approval

---

## SLA Targets by Severity

| Severity | Acknowledgement | Fix/Workaround | Root Cause Analysis | Post-Mortem |
|----------|-----------------|----------------|---------------------|-------------|
| **P0** | ≤ 15 min | ≤ 1 hour (or hotfix deploy) | ≤ 24 hours | Required |
| **P1** | ≤ 30 min | ≤ 4 hours | ≤ 48 hours | Required for launch blockers |
| **P2** | ≤ 2 hours | ≤ 24-48 hours | ≤ 1 week | Optional |
| **P3** | ≤ 1 day | Next sprint | N/A | N/A |

### Launch Period SLA (First 48 Hours)
| Severity | Acknowledgement | Fix/Workaround |
|----------|-----------------|----------------|
| **P0** | ≤ 5 min | ≤ 30 min (hotfix deploy) |
| **P1** | ≤ 15 min | ≤ 2 hours |
| **P2** | ≤ 30 min | ≤ 6 hours |
| **P3** | ≤ 2 hours | Log for sprint |

---

## Escalation Paths

### P0 — Critical
1. **Immediate**: On-call engineer + QA Lead + Tech Lead + Product Owner (Slack #incidents + phone)
2. **15 min**: If no fix, escalate to Engineering Manager + CTO
3. **1 hour**: If no resolution, initiate rollback/war room

### P1 — High
1. **Immediate**: Assigned engineer + QA Lead (Slack #bugs-p1)
2. **30 min**: If no progress, Tech Lead joins
3. **2 hours**: If no fix, Engineering Manager notified
4. **4 hours**: If no workaround, Product Owner decides launch delay

### P2 — Medium
1. **Within 2 hours**: Assigned engineer acknowledges (Slack #bugs-p2)
2. **24 hours**: Progress update required
3. **48 hours**: Fix or documented workaround

### P3 — Low
1. **Next business day**: Triaged and prioritized
2. **Sprint planning**: Added to backlog

---

## Communication Channels

| Channel | Purpose | Audience |
|---------|---------|----------|
| `#incidents` (Slack) | P0/P1 real-time coordination | On-call, Leads, EM, CTO |
| `#bugs-p1` (Slack) | P1 tracking | Assigned engineers, QA, PO |
| `#bugs-p2` (Slack) | P2 tracking | Assigned engineers, QA |
| `#launch-updates` (Slack) | Launch status, blockers | All stakeholders |
| Jira | Bug tracking, status, history | All |
| Email | Stakeholder updates (P0/P1 launch blockers) | Leadership, PO, PM |

---

## Launch Blocker Criteria

**Launch is BLOCKED if ANY of the following exist:**
- [ ] Open P0 bugs
- [ ] Open P1 bugs affecting: Payments, Orders, Auth, Tracking, Assignment
- [ ] >3 open P1 bugs in any single module
- [ ] P2 bug with no workaround affecting >10% users
- [ ] Security audit findings: Critical/High unresolved
- [ ] Performance: P95 latency >3s on critical endpoints
- [ ] Payment success rate <99.5% in staging
- [ ] Crash rate >0.1% in staging

**Launch is CONDITIONAL if:**
- [ ] 1-3 P1 bugs with documented workarounds
- [ ] >5 P2 bugs in non-critical paths
- [ ] Performance: P95 2-3s on non-critical endpoints
- [ ] Minor localization/accessibility gaps

**Launch is GO if:**
- [ ] Zero P0/P1 open
- [ ] All P2 have workarounds or fix scheduled <48h
- [ ] Security audit: No Critical/High findings
- [ ] Performance benchmarks met
- [ ] All stakeholder sign-offs obtained

---

## Bug Lifecycle

```
NEW → TRIAGE → CONFIRMED → IN_PROGRESS → IN_REVIEW → VERIFIED → CLOSED
  ↓         ↓           ↓            ↓            ↓           ↓
(P0/P1)  (Assign    (Dev starts)  (Code review) (QA verifies) (Auto-close
  urgent   severity,  or hotfix    or hotfix      on staging/   after 5 days
  escalation) owner)    branch)      deploy)       prod)
```

### State Definitions
- **NEW**: Just reported, not triaged
- **TRIAGE**: Severity confirmed, owner assigned
- **CONFIRMED**: Reproducible, accepted by dev
- **IN_PROGRESS**: Active development
- **IN_REVIEW**: PR open, awaiting review
- **VERIFIED**: QA verified on staging/prod
- **CLOSED**: Done
- **REOPENED**: Regression or incomplete fix
- **WONTFIX**: Deferred/accepted risk (requires PO approval)

---

## Metrics & Reporting

### Daily During UAT/Launch
- Open bugs by severity (P0/P1/P2/P3)
- Bugs opened vs closed (burn rate)
- Mean time to acknowledge (MTTA)
- Mean time to resolve (MTTR)
- Launch blocker count

### Weekly Report (Post-Launch)
- Bug trend (week over week)
- Escape rate (prod bugs / total bugs)
- Severity distribution
- Top crash causes
- Customer-reported vs internal

---

## Hotfix Process (Production)

### Criteria for Hotfix
- P0 in production
- P1 affecting payments/orders/auth
- Security vulnerability
- Data corruption

### Hotfix Flow
1. **Branch**: `hotfix/<ticket-id>` from `main` (or latest release tag)
2. **Fix**: Minimal change, single commit preferred
3. **Test**: Run affected E2E tests + smoke test on staging
4. **Deploy**: Blue-green deploy to production
5. **Verify**: Monitor error rates, logs, metrics for 15 min
6. **Merge**: Back to `main` and `develop`
7. **Communicate**: Update `#incidents`, stakeholders

### Rollback Criteria
- Error rate >5% post-deploy
- P0 introduced by hotfix
- Critical metric regression (payments, orders)
- Decision: On-call + Tech Lead + PO (≤5 min)

---

## Triage Checklist (Per Bug)

- [ ] Severity assessed correctly (P0-P3)
- [ ] Reproducible with clear steps
- [ ] Environment documented
- [ ] Logs/screenshots attached (P0/P1 mandatory)
- [ ] Affected roles identified
- [ ] Owner assigned
- [ ] ETA communicated
- [ ] Launch impact assessed
- [ ] Stakeholders notified (if P0/P1 launch blocker)
- [ ] Linked to related tickets/PRs