# Developer Guide — Gloss Ecosystem

## Table of Contents
1. [Git Workflow](#git-workflow)
2. [Code Style](#code-style)
3. [Environment Setup](#environment-setup)
4. [Development Workflow](#development-workflow)
5. [Testing](#testing)
6. [CI/CD](#cicd)
7. [Code Review](#code-review)
8. [Database Migrations](#database-migrations)
9. [Deployment](#deployment)
10. [Monitoring](#monitoring)

---

## Git Workflow

### Branch Strategy

```
main (production)
  └── develop (integration)
       ├── feature/gloss-123-add-order-tracking
       ├── feature/gloss-124-seller-kyc
       ├── fix/gloss-125-order-cancel-bug
       ├── refactor/gloss-126-auth-middleware
       └── chore/gloss-127-update-deps
```

### Branch Naming

```
<type>/<gloss-id>-<short-description>

Types:
  feature/   — New functionality
  fix/       — Bug fixes
  refactor/  — Code refactoring
  chore/     — Dependencies, config, CI
  docs/      — Documentation
  test/      — Testing improvements
  perf/      — Performance optimization
  security/  — Security fixes

Example: feature/GLOSS-42-courier-tracking-ws
```

### Commit Convention (Conventional Commits)

```
<type>(<scope>): <short description>

<body (optional)>

<footer (optional)>

Types: feat, fix, refactor, chore, docs, test, perf, security
Scope: backend, client, provider, seller, shared, ui-kit, docs

Examples:
  feat(backend): add courier assignment algorithm
  fix(backend): order status not updating after payment
  feat(client): add live tracking map screen
  fix(provider): order accept button timeout
  refactor(shared): extract common order states
  chore(deps): upgrade prisma to 5.5
```

### Pull Request Process

1. Create feature branch from `develop`
2. Write tests for new code
3. Run `melos run ci:check` locally
4. Create PR → auto-assign reviewer
5. Pass CI checks (lint + test + build)
6. Code review approval (min 1)
7. Squash merge to `develop`
8. Delete feature branch

### Release Process

```
develop → release/v1.2.3 (staging)
  └── Test in staging
       └── Tag: v1.2.3
            └── Merge to main → production deploy
                 └── Hotfix: fix/v1.2.4 from main
```

### Branch Protection
- `main` branch: requires PR review (min 1 approver), status checks pass, no direct commits
- `develop` branch: requires PR review for non-team members
- Release tags: GPG signed
- CI secrets: never in PRs from forks

---

## Code Style

### Backend (TypeScript/NestJS)

- **Indentation**: 2 spaces
- **Quotes**: single quotes
- **Semicolons**: required
- **Naming**: `camelCase` for variables/functions, `PascalCase` for classes/interfaces, `UPPER_SNAKE` for constants
- **Max line length**: 100
- **File naming**: `kebab-case.ts`
- **Module naming**: `*.module.ts`, `*.service.ts`, `*.controller.ts`, `*.gateway.ts`
- **DTO naming**: `*.dto.ts`, `*Response.ts`, `*Input.ts`
- **Enums**: `PascalCase` enum members

**Linter**: ESLint + NestJS plugin + Prettier

```json
{
  "extends": ["plugin:@typescript-eslint/recommended", "plugin:prettier/recommended"],
  "rules": {
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/explicit-function-return-type": "off",
    "no-console": "warn",
    "max-len": ["error", 120]
  }
}
```

### Flutter (Dart)

- **Indentation**: 2 spaces
- **Naming**: `camelCase` for variables, `PascalCase` for classes, `snake_case` for files
- **Files per class**: One class per file (exceptions: small private classes)
- **Organize imports**: `dart format` handles automatically
- **Avoid dynamic**: Use typed variables
- **Use const**: Wherever possible

**Linter**: Very Good Analysis / flutter_lints

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - avoid_print
    - prefer_single_quotes
    - sort_constructors_first
    - require_trailing_commas
```

### Database (Prisma)

- **Model names**: `PascalCase` singular
- **Field names**: `camelCase`
- **Mapping**: `@map("snake_case")` for DB columns
- **Table names**: `@@map("snake_case_plural")`
- **Relations**: Explicit with `@relation()`
- **Indexes**: Add indexes on foreign keys and frequently queried fields

---

## Environment Setup

### Prerequisites

```bash
# Required
Node.js >= 18
npm >= 9
Flutter >= 3.19
Dart >= 3.2
Docker Desktop
Melos (global)
  npm install -g melos

# Optional
PostgreSQL 15+ (or use Docker)
Redis 7+ (or use Docker)
MinIO (or use Docker)
```

### Initial Setup

```bash
# 1. Clone
git clone git@github.com:gloss/gloss-ecosystem.git
cd gloss-ecosystem

# 2. Melos bootstrap
melos bootstrap

# 3. Start infrastructure
docker compose up -d

# 4. Backend setup
cd packages/backend
cp .env.example .env
npm install
npx prisma migrate dev
npx prisma db seed
npm run start:dev

# 5. Flutter setup (in separate terminals)
cd apps/gloss_client
flutter run

cd apps/gloss_provider_deliver
flutter run

cd apps/gloss_seller
flutter run
```

### Environment Variables (Backend)

```bash
# .env
DATABASE_URL=postgresql://gloss:gloss_secret@localhost:5432/gloss_ecosystem
REDIS_URL=redis://localhost:6379

JWT_SECRET=your-jwt-secret-change-in-production
JWT_ACCESS_EXPIRES=15m
JWT_REFRESH_EXPIRES=7d

MINIO_ENDPOINT=localhost:9000
MINIO_ACCESS_KEY=gloss
MINIO_SECRET_KEY=gloss_minio
MINIO_BUCKET=gloss-files

FCM_SERVER_KEY=your-firebase-server-key

CLICK_MERCHANT_ID=your-click-merchant
CLICK_SECRET_KEY=your-click-secret

PAYME_MERCHANT_ID=your-payme-merchant
PAYME_SECRET_KEY=your-payme-secret

YANDEX_MAPS_API_KEY=your-yandex-maps-key

SMTP_HOST=smtp.mailtrap.io
SMTP_PORT=2525
SMTP_USER=your-user
SMTP_PASS=your-pass

LOG_LEVEL=debug
NODE_ENV=development
```

---

## Development Workflow

### Daily Workflow

```bash
# 1. Update from develop
git checkout develop
git pull
git checkout -b feature/GLOSS-42-my-feature

# 2. Make changes, commit frequently
git commit -m "feat(backend): add courier assignment endpoint"
git commit -m "test(backend): add assignment unit tests"

# 3. Push and create PR
git push -u origin feature/GLOSS-42-my-feature
# → Create PR on GitHub

# 4. After PR approved, squash merge
# → Branch auto-deleted
```

### Running Tests

```bash
# All packages
melos run test:all

# Specific package
melos run --scope=backend -- test
flutter test apps/gloss_client

# With coverage
melos run --scope=backend -- test:cov
flutter test --coverage apps/gloss_client
```

### Code Generation

```bash
# Generate Prisma client
cd packages/backend
npx prisma generate

# Generate Dart models (Freezed)
cd packages/shared/models
dart run build_runner build --delete-conflicting-outputs

# Generate Dart API client (Retrofit)
cd packages/shared/api-client
dart run build_runner build --delete-conflicting-outputs
```

---

## Testing

### Test Types Required

| Type | Coverage Target | Who Writes |
|------|-----------------|------------|
| Unit tests | 80%+ | Developer |
| Widget tests | 70%+ | Developer |
| Integration | Critical flows | Developer + QA |
| E2E | Key user journeys | QA |

### Critical E2E Test Scenarios (Must Pass Before Each Release)

```
Backend (Jest):
  1. User registers with roles → login → refresh → logout
  2. Create service order → calculate price → provider accepts → in_progress → complete
  3. Create product order → payment (mock) → seller marks ready → courier assigned → delivered
  4. Create mixed order (service + products) → split → combined tracking → complete
  5. Cancel order before and after assignment (verify fee rules)
  6. Promo code validate → apply to order → verify discount
  7. Courier sends 1000+ location points → verify tracking history
  8. Chat: send message → receive via WS → read receipt → typing indicator
  9. Payment webhook → idempotency (duplicate = ignore)
  10. KYC: submit documents → admin approves → seller can list products

Flutter (Patrol):
  1. Register → select role → verify phone → login
  2. Browse services → select → booking form → confirm order → see status
  3. Browse products → add to cart → checkout → payment → order confirmed
  4. Provider: login → see available orders → accept → navigate to client → complete
  5. Courier: login → see deliveries → accept → navigate → photo proof → complete
  6. Seller: login → KYC upload → create product → see incoming order → mark ready
  7. Order tracking: open order → see real-time courier on map → ETA updates
  8. Chat: open chat → send message → receive reply → typing indicator
  9. Push notification: receive order_assigned → tap → deep link to order
  10. Offline: create order offline → reconnect → order synced
```

### SLA & Performance Targets

| Metric | Target | Threshold | Measurement |
|--------|--------|-----------|-------------|
| API response time (p95) | < 200ms | < 500ms | Prometheus |
| Order creation | < 500ms | < 1s | Custom metric |
| Location update (WS) | < 100ms | < 300ms | WS latency |
| WebSocket reconnect | < 3s | < 5s | Client metric |
| Auth (login/register) | < 1s | < 2s | Custom metric |
| Search (products) | < 300ms | < 800ms | Custom metric |
| System uptime | > 99.9% | > 99.5% | Uptime Kuma |
| Error rate | < 0.1% | < 1% | Grafana |
| Concurrent WS connections | 10,000 | 5,000 | k6 test |
| Concurrent API requests | 1,000 req/s | 500 req/s | k6 test |

### Regression Test Strategy

```
PR Pipeline (every PR):
  └── lint + typecheck + unit tests (backend + flutter)
       └── build check (backend docker + flutter apk)

Nightly (develop branch):
  └── full unit + widget tests
       └── integration tests (critical flows)
            └── E2E smoke tests (5 critical paths)

Release Pipeline (release/* branches):
  └── full E2E test suite (10 scenarios)
       └── load test (k6, 10 min)
            └── security scan (Snyk)
                 └── build + deploy to staging
                      └── UAT sign-off
```

### Testing Conventions

```typescript
// Backend — NestJS
describe('OrdersService', () => {
  describe('createOrder', () => {
    it('should create a service order successfully', async () => {
      // Arrange
      // Act
      // Assert
    });
  });
});
```

```dart
// Flutter
void main() {
  group('OrdersProvider', () {
    testWidgets('should load orders', (tester) async {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

### Mock Strategy

- **Backend**: Jest mocks, Prisma mock (or testcontainers for real DB)
- **Flutter**: Mockito for repositories, Fake API client for widget tests

---

## CI/CD

### GitHub Actions Workflows

#### CI Pipeline (`.github/workflows/ci.yml`)

```yaml
name: CI

on:
  pull_request:
    branches: [develop, main]
  push:
    branches: [develop]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 18 }
      - uses: subosito/flutter-action@v2
        with: { flutter-version: 3.19 }
      - run: npm install -g melos
      - run: melos bootstrap
      - run: melos run lint:all

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 18 }
      - uses: subosito/flutter-action@v2
        with: { flutter-version: 3.19 }
      - run: npm install -g melos
      - run: melos bootstrap
      - run: melos run test:all

  build:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: gloss
          POSTGRES_PASSWORD: gloss_secret
          POSTGRES_DB: gloss_ecosystem
        ports: [5432:5432]
    steps:
      - uses: actions/checkout@v4
      - run: npm install -g melos
      - run: melos bootstrap
      - run: cd packages/backend && npm run build
      - run: cd apps/gloss_client && flutter build apk --debug
```

#### Deploy Backend (`.github/workflows/deploy-backend.yml`)

```yaml
name: Deploy Backend

on:
  push:
    tags: [v*]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker image
        run: docker build -t gloss/backend:${GITHUB_REF_NAME} packages/backend
      - name: Push to registry
        run: docker push gloss/backend:${GITHUB_REF_NAME}
      - name: Deploy to server
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SERVER_KEY }}
          script: |
            docker pull gloss/backend:${GITHUB_REF_NAME}
            docker compose up -d backend
```

---

## Code Review Checklist

### General
- [ ] Code follows style guide
- [ ] No commented-out code
- [ ] No console.log / print statements
- [ ] Error handling for all new endpoints
- [ ] Input validation (DTOs)
- [ ] RBAC check for new endpoints
- [ ] No sensitive data in logs/responses

### Backend
- [ ] Prisma query optimized (no N+1)
- [ ] Indexes exist for new queries
- [ ] DTOs use class-validator
- [ ] WebSocket events documented
- [ ] Audit logging for state changes
- [ ] Rate limiting considered

### Flutter
- [ ] Riverpod providers properly disposed
- [ ] Offline fallback implemented
- [ ] Loading/error/empty states handled
- [ ] i18n added for new strings
- [ ] Analytics events tracked
- [ ] Memory leaks checked (StreamSubscription)

### Tests
- [ ] Unit tests cover new logic
- [ ] Widget tests cover new screens
- [ ] Integration tests for critical flows

---

## Database Migrations

### Creating Migrations

```bash
cd packages/backend

# After changing schema.prisma
npx prisma migrate dev --name add-courier-availability

# Generate migration file
# → prisma/migrations/20240710_add_courier_availability/migration.sql

# Apply to dev DB
npx prisma migrate dev
```

### Migration Rules

1. **Never edit existing migration files** — create new ones
2. **Always preview** before apply: `npx prisma migrate dev --create-only`
3. **Test rollback**: `npx prisma migrate resolve --rolled-back <migration>`
4. **Seed data**: Update `prisma/seed.ts` for new models
5. **Review SQL**: Check generated SQL for performance

### Production Migration

```bash
# Generate migration without applying
npx prisma migrate dev --create-only

# Save migration.sql file
# Apply during deployment via CI
npx prisma migrate deploy
```

---

## Deployment

### Docker Build

```bash
# Backend
docker build -t gloss/backend:latest packages/backend

# Run stack
docker compose -f docker-compose.yml up -d
```

### Production Considerations

1. **Environment variables**: Use secrets manager (Vault, AWS Secrets Manager)
2. **Database**: Connection pooling (PgBouncer), read replicas
3. **Redis**: Cluster mode for high availability
4. **MinIO**: Multi-node cluster + CDN
5. **SSL/TLS**: Let's Encrypt for API domain
6. **DDoS protection**: Rate limiting at Nginx/CDN level
7. **Backups**: Automated daily DB + file backups
8. **Rollback strategy**: Blue-green deployment or canary

---

## Monitoring

### Tools

- **Logs**: Winston/Pino → Loki → Grafana
- **Metrics**: Prometheus → Grafana
- **Tracing**: OpenTelemetry → Jaeger
- **Errors**: Sentry (backend + Flutter)
- **Performance**: Lighthouse CI (Flutter), k6 (API)
- **Uptime**: Uptime Kuma / Better Uptime

### Health Endpoints

```
GET /health          → {"status": "ok", "uptime": 12345}
GET /health/ready    → Database + Redis + MinIO connectivity
GET /health/version  → {"version": "1.2.3", "commit": "abc123"}
```

### Alert Rules

| Alert | Condition | Channel |
|-------|-----------|---------|
| API down | Health check fails 3x | Telegram + Email |
| High latency | p95 > 1000ms for 5 min | Telegram |
| Error rate > 1% | HTTP 5xx rate | Telegram |
| DB connection pool exhausted | > 80% used | Telegram |
| Low disk space | < 10% free | Email |

---

## Security Guidelines

1. **Never commit secrets** — use `.env.example` + `.env`, .env in .gitignore
2. **PII encryption**: Phone numbers, passport data, bank cards encrypted at rest (AES-256-GCM)
3. **Rate limiting**: 
   - `/auth/*`: 10 requests/min per IP
   - `/api/*`: 100 requests/min per token
   - `/ws/*`: 60 messages/min per connection
   - `/payments/webhook/*`: 30 requests/min per IP (whitelisted)
4. **Input sanitization**: All user input validated via class-validator DTOs, HTML tags stripped, URLs validated against allowlist
5. **Audit trail**: All state changes logged with user_id, timestamp, diff
6. **Session management**: JWT access (15min) + refresh (7d), rotation on use, revoke on logout
7. **File upload**: Validate MIME type whitelist (jpg,png,pdf,mp4), max size (10MB), ClamAV scan, signed URLs (1h expiry)
8. **CORS**: Restrict to known origins in production
9. **Webhook security**: Verify HMAC signature for Click/Payme webhooks, IP whitelist, idempotency key dedup, nonce + timestamp replay protection (`x-nonce` UUID, `x-timestamp` ISO8601, 5min window, nonce stored 24h in Redis)
10. **JWT secret rotation**: Rotate monthly, keep previous key for 24h for active tokens
11. **No raw SQL**: All queries through Prisma ORM to prevent SQL injection
12. **Dependency scanning**: Snyk/Dependabot weekly scan, critical CVEs auto-block CI
13. **Secret rotation schedule**:
    - JWT_SECRET: monthly
    - Click/Payme secrets: quarterly
    - MinIO credentials: yearly
    - Database password: yearly
14. **Audit log retention**: 
    - AuditLog: 90 days in DB, 1 year compressed archive
    - LocationPoint: 30 days
    - Notification: 90 days
    - Message: 1 year
15. **Data access control**: All admin actions require 2FA (TOTP)
16. **GDPR compliance**: User data export endpoint, account deletion cascade

### Password Security
- Algorithm: **argon2id** (memory cost: 19MB, iterations: 2, parallelism: 1)
- Min length: 8 characters (enforced at DTO + DB level)
- Complexity: at least 1 uppercase, 1 lowercase, 1 digit, 1 special character
- Password history: last 5 passwords stored (prevents reuse)
- Password rotation: optional, not enforced (UX preference)
- Recovery: forgot-password flow uses OTP (6-digit, 5min expiry, max 3 attempts)

### Session Management
- **Concurrent sessions**: unlimited by default, configurable via SystemConfig (`max_sessions_per_user`)
- **Session listing**: `GET /auth/sessions` returns all active sessions with device info, last active timestamp
- **Revoke session**: `DELETE /auth/sessions/:id` revokes specific session
- **Force logout (admin)**: `POST /admin/users/:id/revoke-sessions` terminates all sessions
- **Device tracking**: RefreshToken stores `deviceInfo` (device name, OS version) and `ipAddress`
- **Token theft detection**: if a refresh token is used from a different device/IP than its creation context, send alert notification and request re-authentication

### OTP Security
- Code length: 6 digits (numeric only)
- Expiry: 5 minutes from generation
- Max attempts: 3 per OTP code (after 3 failures, OTP invalidated, new code required)
- Rate limit: 5 OTP requests per phone number per hour
- Cooldown: 60 seconds between OTP resend requests
- SMS provider: integration with local Uzbek provider (e.g., Play Mobile, Eskiz)
- ReCAPTCHA: required after 3 failed OTP attempts within 30 minutes

### CORS Configuration
```typescript
// NestJS CORS setup
app.enableCors({
  origin: [
    'https://gloss-client.uz',
    'https://gloss-seller.uz',
    'https://gloss-admin.uz',
  ],
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Idempotency-Key'],
  credentials: true,
  maxAge: 86400, // 24 hours
});
```

### Webhook Replay Protection
Each webhook request includes `x-nonce` (UUID) and `x-timestamp` (ISO8601). Server rejects if:
- Timestamp is more than 5 minutes old
- Nonce has been seen within the last 24 hours (stored in Redis with TTL)

### Data Encryption
- **At rest (PostgreSQL)**: PII fields encrypted via Prisma middleware with AES-256-GCM
  - Encrypted fields: `User.phone`, `User.email`, `PayoutAccount.details`
  - Encryption key: managed in vault (HashiCorp Vault / AWS KMS), rotated every 90 days
  - Decryption: only when data is explicitly needed (not in list queries)
  - Audit: all decryption operations logged in AuditLog
- **At rest (MinIO)**: SSE-S3 (AES-256) enabled for all uploaded files
- **In transit**: TLS 1.3 for all API and WebSocket connections, HSTS enabled

### XSS Prevention
- All user-generated content sanitized before storage (server-side):
  - HTML tags stripped from text fields
  - URLs validated against allowlist
- Before rendering in Flutter:
  - Use `Text` widget (not `Html` or `RichText`) for user content
  - If rich text needed, use `flutter_widget_from_html` with sanitizer enabled
  - Escape special characters in chat messages

### Certificate Pinning (Mobile)
All Flutter apps implement SSL certificate pinning:
- Android: `android:networkSecurityConfig` with domain pinning for api.gloss.uz
- iOS: URLSession delegate with `didReceiveChallenge` handler
- Dio: `BadgeCertificateCallback` or `HttpClient.badgeCertificateCallback`
- Pins: SHA-256 hash of production certificate (backup pin for rotation)
- Rotation: update pin 30 days before certificate expiry
- Dev/staging: pinning disabled (configurable via build flavor)

### Device Security (Mobile)
- **Root detection**: `root_detector` package — scan for common root indicators
- **Jailbreak detection**: check for Cydia, unc0ver, sandbox integrity
- **Action**: on detection, show warning "This device appears to be rooted. App will exit for security."
- **Emulator detection**: block emulator builds from accessing payment/KYC flows

### GDPR Compliance
- **Data export endpoint**: `GET /users/me/export` returns JSON with all user data:
  - Profile, addresses, orders, messages, reviews, payments, KYC documents
  - No other users' data included
  - Generated on-demand, available for download for 48 hours
- **Account deletion**: 
  - Soft-delete: `deletedAt` timestamp on User record
  - Data retained for 30-day grace period (admin recovery option)
  - After 30 days: anonymization (phone → hash, email → hash, name → "Deleted User")
  - Hard delete after 1 year from deletion request
- **Consent management**:
  - `user_consents` table (model to be added): consentType, granted, timestamp
  - Consent types: `marketing_emails`, `location_tracking`, `data_processing`, `analytics`
  - Withdrawal: user can revoke consent anytime via Settings
  - Proof: all consent changes logged in AuditLog

### Dependency Security
- Weekly `snyk test` or `npm audit` / `dart pub outdated` scans
- GitHub Dependabot enabled for automated PRs
- Critical severity CVEs: auto-fail CI pipeline
- High severity: alert within 48 hours
- Lockfile verification: no manual dependency overrides without security review

---

## Useful Commands

```bash
# Monorepo
melos clean                     # Clean all packages
melos bootstrap                 # Install all deps
melos pub:get                   # Get dependencies for all
melos exec -- flutter pub get   # Flutter specific

# Backend
npm run start:dev               # Development server
npm run build                   # Production build
npm run lint                    # ESLint check
npm run lint:fix                # Auto-fix
npm run test                    # Unit tests
npm run test:e2e               # E2E tests
npx prisma studio              # DB UI

# Flutter
flutter run                     # Run on device
flutter build apk               # Android build
flutter build ios               # iOS build
flutter analyze                 # Lint
flutter test --coverage         # Test with coverage
```

## Test Strategy

### Test Pyramid Ratios
| Level | Target Coverage | Volume Ratio | Tools |
|-------|----------------|--------------|-------|
| Unit | 80%+ | 70% | Jest (backend), flutter_test (mobile) |
| Integration | 60%+ | 20% | Testcontainers (backend), integration_test (mobile) |
| E2E | All critical paths | 10% | Pactum (API), Patrol (mobile) |

Rationale: 70/20/10 ensures fast CI feedback (unit tests run in <2min), catches integration issues (order engine, payments), and validates critical user journeys end-to-end.

### Order State Machine Test Matrix
All possible state transitions and who can perform them:

| From | To | Role | Fee/Penalty |
|------|-----|------|-------------|
| pending | confirmed | system | None |
| pending | cancelled | client | Free (within 5min) |
| confirmed | assigned_provider | system | None |
| confirmed | assigned_courier | system | None |
| confirmed | cancelled | client | 10% fee |
| assigned_provider | in_progress | provider | None |
| assigned_provider | cancelled | provider | 15,000 UZS penalty |
| assigned_courier | ready_for_pickup | seller | None |
| ready_for_pickup | en_route_to_pickup | courier | None |
| en_route_to_pickup | picked_up | courier | None |
| picked_up | en_route_to_delivery | system | None |
| en_route_to_delivery | delivered | courier | Proof photo |
| delivered | completed | system | Payout triggered |
| in_progress | completed | provider | Payout triggered |
| any | cancelled | admin | Reason required |
| delivered → cancelled | — | INVALID | Must reject |
| completed → cancelled | — | INVALID | Must reject |

### Authentication Test Scenarios
- Token expiry handling: client refreshes on 401
- Refresh token rotation: old token invalid after use
- Invalid token: 401 returned, no user data leaked
- Expired token: graceful degradation to login screen
- RBAC boundary: client accessing /admin → 403
- Multi-role: user with provider+courier roles can access both
- Force logout: admin revokes sessions → user redirected
- Concurrent sessions: multiple devices all active

### WebSocket Testing Strategy
- Tool: `socket.io-client` for integration tests, `k6` with WebSocket for load
- Test scenarios:
  1. Connect → authenticate → subscribe → receive events
  2. Connection drop mid-stream → queue messages → reconnect → replay
  3. Room resubscription on reconnect
  4. Rate limit enforcement (60 msg/min → disconnect)
  5. Invalid token → connection rejected
  6. 10,000 concurrent connections stability

### Offline Sync Test Scenarios
- Create order offline → reconnect → synced (happy path)
- Update address offline → reconnect → conflict (server wins)
- Cancel order offline → reconnect → already cancelled on server
- Create order offline → stock depleted → conflict dialog
- 100+ offline mutations → sync queue processing order
- Queue persistence across app restart

### Payment Flow Test Scenarios
- Successful payment via Click/Payme
- Payment webhook timeout → retry → success
- Duplicate webhook → 409 (idempotency)
- Invalid HMAC signature → 401
- Refund flow: partial and full
- Concurrent refund requests
- Payment failure → order cancelled, retry option
- Provider no-show → full refund to client

### Concurrency Test Scenarios
- Two providers accept same order → first wins, second gets 409
- Double-spend: same payment webhook received twice
- Stock race: two clients buy last item → first confirmed, second cancelled
- Assignment race: two couriers scored for same order

### Mobile Device Fragmentation
- Target devices: Android API 24+ (8.0), iOS 15+
- Screen categories: small (320dp), medium (375dp), large (428dp), tablet (600dp+)
- Testing: Firebase Test Lab for automated device matrix
- Low-end devices: 2GB RAM, older CPUs — test for memory pressure
- Network: 3G, 4G, WiFi, offline — use Network Link Conditioner

### Golden Test Baseline Management
- Baseline storage: `test/goldens/` in each app package
- CI: `git diff --name-only` on golden files to detect changes
- Update: `flutter test --update-goldens` on intentional UI changes
- Per-platform: separate goldens for Android/iOS rendering diffs

## Performance Architecture

### Caching Strategy
| Cache Layer | Data | TTL | Invalidation |
|-------------|------|-----|--------------|
| Redis | Session tokens, rate limit counters | Token lifetime | Logout, expiry |
| Redis | Product catalog, categories | 5 min | Product update event |
| Redis | Service types + pricing | 15 min | Service update event |
| Redis | Geo-indexed courier/providers | 30 sec | Location update event |
| CDN | Product images, service icons | 7 days | Upload new version |
| CDN | Static assets (app icons, logos) | 30 days | Versioned URL |
| Drift (local) | Cached products, services | Session | Pull-to-refresh |
| Drift (local) | Orders, messages | Until synced | Server response |

Cache invalidation patterns:
- **Write-through**: On product update, update DB + Redis cache + purge CDN
- **Event-driven**: Use BullMQ to publish cache invalidation events on data changes
- **TTL-based**: Acceptable staleness for read-heavy, low-churn data (categories, service types)

### N+1 Query Prevention
Mandatory practices:
1. Always use Prisma `include` with `select` for list endpoints
2. Use `@@index` on all foreign keys (verified in schema)
3. Enable Prisma query logging in development: `log: ['query', 'warn', 'error']`
4. Review generated SQL in PR review — reject if N+1 detected
5. Use Prisma `batch` API for bulk operations (location points, stock updates)
6. Consider denormalization for hot paths: order `totalPrice` on Order, not computed from items

### Connection Pooling
- PgBouncer in transaction mode: `connection_limit=50` (increased from 20)
- Prisma pool: `pool_max=10` per instance
- With 3 backend instances: 50 PgBouncer connections × 3 instances = 150 total
- Connection timeout: `pool_timeout=10` seconds
- Monitor: `pg_stat_activity` for idle-in-transaction connections

### Read Replicas (Production)
```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL") // Write endpoint
  relationMode = "prisma"
}

datasource db_replica {
  provider = "postgresql"
  url      = env("DATABASE_REPLICA_URL") // Read-only endpoint
}
```
- Route read queries to replica: `this.db.$replica()` in Prisma
- Replication lag: accept up to 5 seconds for non-critical reads
- Critical reads (orders, payments): read from primary

### WebSocket Scaling
Redis adapter is MANDATORY for production (not future):
```typescript
const server = new NestExpressServer(app);
const io = new Server(server, {
  adapter: createAdapter(redisClient),
  pingInterval: 25000,
  pingTimeout: 60000,
});
```
- All WS connections go through Redis pub/sub for cross-instance events
- Load balancer: sticky sessions not required (Redis handles cross-instance)
- Room-based for efficient message routing

### Background Job Configuration
```typescript
// BullMQ defaults
const defaultJobOptions = {
  attempts: 5,
  backoff: {
    type: 'exponential',
    delay: 2000, // 2s, 4s, 8s, 16s, 32s
  },
  removeOnComplete: { age: 3600 * 24 }, // Keep for 24h
  removeOnFail: { age: 3600 * 24 * 7 }, // Keep failed for 7 days
};
```
- Dead Letter Queue: separate queue for jobs that exceed max attempts
- Queue monitoring: Bull Board at `/admin/queues` (secured)
- Worker concurrency: `concurrency: 10` per worker process

### Resource Estimation (Minimum)
| Service | CPU | RAM | Storage | Instances |
|---------|-----|-----|---------|-----------|
| Backend (NestJS) | 2 vCPU | 4 GB | 20 GB | 2-3 |
| PostgreSQL | 4 vCPU | 8 GB | 200 GB (starting) | 1 + replica |
| Redis | 1 vCPU | 2 GB | 10 GB | 2 (cluster) |
| MinIO | 2 vCPU | 4 GB | 500 GB | 2 |
| PgBouncer | 0.5 vCPU | 1 GB | 5 GB | 1 |
| Monitoring | 1 vCPU | 2 GB | 50 GB | 1 |

### HTTP Caching & Compression
- Enable gzip/brotli compression on NestJS: `app.use(compression())`
- Add Cache-Control headers to GET responses
- ETags for product catalog, service listings: `@CacheKey()` + `@CacheTTL()`
- CDN: Cloudflare or similar for static assets and image delivery

### Location Point Batch Writes
```typescript
// Instead of individual creates:
await prisma.locationPoint.createMany({
  data: points, // array of 50-100 points
  skipDuplicates: true,
});
```
- Batch threshold: every 5 seconds or 50 points, whichever comes first
- WAL tuning for high-write workloads:
  - `max_wal_size = 4GB`
  - `checkpoint_completion_target = 0.9`
  - `wal_buffers = 64MB`

### Query Performance Tooling
- Enable `pg_stat_statements` extension for slow query identification
- Prisma logging config: `log: ['query', 'warn', 'error']` when `LOG_LEVEL=debug`
- Slow query threshold: `log_min_duration_statement = 200` (200ms)
- Monthly `EXPLAIN ANALYZE` review on top 10 slowest queries

---

## Compliance & Legal

### Uzbekistan Data Localization
All production servers must be physically located within Uzbekistan.
- Partner with local hosting provider (Ucell, Uzbektelecom, IT Park resident)
- No cross-border transfer of personal data without explicit consent
- Foreign service providers (Click, Payme, Yandex, Firebase) must have DPAs in place
- Geographic redundancy within Uzbekistan (Tashkent + regional DC)

### Data Retention
| Data Type | Retention | Rationale |
|-----------|-----------|-----------|
| Orders, Payments, Payouts | 5 years | Uzbek E-commerce Law |
| AuditLog | 90 days active, 5 years archived | Financial records |
| Messages | 5 years | Order-related communication |
| Location Points | 30 days | Operational, auto-purge |
| Notifications | 90 days | Operational |
| KYC Documents | 5 years post-account closure | AML requirements |
| User Account | Deleted → anonymized after 30d, hard-delete after 5yr | GDPR + Uzbek law |

### Breach Notification
1. **Detection**: Automated monitoring (error rate spikes, unusual access patterns)
2. **Assessment**: Within 24 hours — determine scope, affected data, root cause
3. **Notification**:
   - Regulator: within 72 hours (GDPR Art. 33) / 24 hours (Uzbek law)
   - Affected users: without undue delay
   - Public disclosure: if significant risk to rights and freedoms
4. **Documentation**: All breaches logged in AuditLog with incident report
5. **DPO Contact**: designate Data Protection Officer, publish contact

### Third-Party Processor Agreements
DPAs required with:
- Click (payment processor) — data: order amounts, merchant ID
- Payme (payment processor) — data: order amounts, merchant ID
- Firebase (push notifications) — data: device tokens
- Yandex (maps/geocoding) — data: address coordinates
- SMS provider — data: phone numbers
- Cloud/hosting provider — data: all stored data
- MinIO/S3 provider — data: uploaded files (KYC docs, product images)

### AML/CFT Compliance
- Report suspicious transactions to Uzbekistan Financial Information Department (FID)
- Threshold for mandatory reporting: 100,000,000 UZS (≈$8,000 USD)
- PEP screening on all sellers, providers, and couriers
- Transaction monitoring: velocity checks, amount thresholds, geographic anomalies
- Record keeping: 5 years for all financial transactions

### Age Verification
- Minimum age: 18 years (Uzbekistan Civil Code)
- Registration: require date of birth field
- Age verification: automated check on registration
- Parental consent: mechanism for 14-17 year olds (Uzbek law allows with guardian consent)
- Age-gated content: adult cleaning services (if any) require age verification

### Terms of Service & Privacy Policy
- Acceptance required at registration (acceptedTos, acceptedPrivacyPolicy flags)
- Versioned legal documents (tos_v1, privacy_policy_v1) stored in SystemConfig
- Version history: all past versions retained for legal reference
- Mandatory renewal: notify users when documents are updated, require re-acceptance
- Display requirements: clear, plain language, available in Uzbek, Russian, English

### GDPR Rights Implementation
| Right | Implementation | API |
|-------|---------------|-----|
| Access (Art. 15) | GET /users/me returns all personal data | Implemented |
| Rectification (Art. 16) | PATCH /users/me | Implemented |
| Erasure (Art. 17) | Soft delete + anonymization | Implemented |
| Restriction (Art. 18) | Flag account as restricted, pause processing | Needs endpoint |
| Portability (Art. 20) | GET /users/me/export as JSON | Implemented |
| Objection (Art. 21) | Opt-out of marketing, analytics, location tracking | Needs endpoint |
| Automated decisions (Art. 22) | Assignment algorithm explanation: GET /assignments/:id/score-breakdown | Needs endpoint |
| Breach notification (Art. 33-34) | See Breach Notification section above | Needs process |
