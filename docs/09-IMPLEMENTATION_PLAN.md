# Implementation Plan — Gloss Ecosystem

## Overview

- **Total duration**: ~15 weeks (3.5 months)
- **Team size**: 1-2 backend + 1-2 Flutter developers
- **Phases**: 8 phases, sequential with some parallelism
- **Delivery**: MVP after Phase 6, production after Phase 7

---

## Phase 0: Foundation (Week 1)

**Goal**: Monorepo setup, infrastructure, basic auth, CI/CD, splash screen

| ID | Task | Scope | Effort | Dependencies |
|----|------|-------|--------|--------------|
| 0.1 | Create monorepo structure: Melos init, root pubspec.yaml, melos.yaml | Shared | 4h | — |
| 0.2 | Create Docker Compose: PostgreSQL 15, Redis 7, MinIO | DevOps | 3h | — |
| 0.3 | Scaffold NestJS project: src structure, AppModule, ConfigModule, logger | Backend | 6h | — |
| 0.4 | Setup Prisma: schema.prisma (User, Role, Permission, UserRole, RefreshToken, DeviceToken), migration, seed | Backend | 8h | 0.2 |
| 0.5 | Auth module: JWT strategy (access+refresh), Passport guards, register/login/refresh endpoints | Backend | 12h | 0.4 |
| 0.6 | RBAC module: RolesGuard, PermissionsGuard, @Roles(), @Permissions() decorators | Backend | 8h | 0.5 |
| 0.7 | Auth interceptor in Flutter: Dio + Retrofit scaffold, token refresh, auth storage | Shared | 8h | 0.5 |
| 0.8 | Flutter 3 apps scaffold: main.dart, app.dart, go_router, Riverpod ProviderScope | Apps | 12h | 0.1 |
| 0.9 | Google Cloud / Firebase project setup (FCM) | DevOps | 3h | — |
| 0.10 | CI/CD: GitHub Actions (lint, test, build), conventional commit lint | DevOps | 8h | 0.1 |
| 0.11 | Shared models package: Freezed config, build.yaml, User model, Role model | Shared | 6h | 0.1 |
| 0.12 | Shared constants: enums (OrderStatus, PaymentStatus, etc), AppConstants | Shared | 4h | 0.1 |
| 0.13 | UI Kit scaffold: AppTheme, AppColors, AppTypography, base widgets | Shared | 6h | 0.1 |
| 0.14 | Splash screen + First-launch onboarding (3 pages, language select, perms) | Apps/Shared | 10h | 0.8 |
| 0.15 | Deep linking setup: scheme config, GoRouter redirect logic | Apps/Shared | 6h | 0.8 |

**Phase 0 total**: 88h (~11 days)

**Deliverables**: Running monorepo, Docker stack, auth working in all 3 apps, CI passes

---

## Phase 1: Core Domain (Week 2-3)

**Goal**: User management, addresses, roles API, admin endpoints

| ID | Task | Scope | Effort | Dependencies |
|----|------|-------|--------|--------------|
| 1.1 | Users module: CRUD, profile update, avatar upload (MinIO) | Backend | 12h | 0.4 |
| 1.2 | Addresses module: CRUD, geocoding, set default | Backend | 8h | 1.1 |
| 1.3 | Admin module: user list, KYC queue, moderate products | Backend | 10h | 0.6 |
| 1.4 | Audit log module: interceptor for all CUD operations | Backend | 6h | 0.3 |
| 1.5 | Rate limiting middleware (express-rate-limit + rate-limit-redis) | Backend | 4h | 0.2 |
| 1.6 | Generate Dart models from Prisma → Freezed (user, address, role) | Shared | 4h | 1.1 |
| 1.7 | Generate Retrofit API client for auth, users, addresses | Shared | 6h | 0.7 |
| 1.8 | Client app: Auth pages (login, register, verify phone), Profile page | Apps | 16h | 0.8 |
| 1.9 | Provider app: Auth pages (with role selection), Role switch UI | Apps | 12h | 0.8 |
| 1.10 | Seller app: Auth pages, Profile page | Apps | 10h | 0.8 |
| 1.11 | i18n setup: ARB files (uz, ru, en), localization delegate | Shared | 6h | 0.8 |
| 1.12 | Drift local DB scaffold: migration, sync queue | Shared | 8h | 0.8 |

**Phase 1 total**: 102h (~13 days)

**Deliverables**: Full user management, addresses, admin panel basics, all 3 apps with auth/profile

---

## Phase 2: Catalog (Week 3-5)

**Goal**: Service types, cleaning services, pricing engine, categories, products, seller CRUD

| ID | Task | Scope | Effort | Dependencies |
|----|------|-------|--------|--------------|
| 2.1 | Prisma: ServiceType, Service, ServiceImage, ServicePricing, Category, Product, ProductVariant, ProductImage, SellerProfile, KYCDocument, CourierProfile, PromoCode, OrderPromoCode, PayoutAccount, CourierAssignmentItem | Backend | 16h | 0.4 |
| 2.1a | Add ProviderProfile + ProviderAvailability models | Backend | 2h | 2.1 |
| 2.1b | Add Notification model + FCM push service | Backend | 2h | 2.1 |
| 2.1c | Add AuditLog model + audit logging interceptor | Backend | 2h | 2.1 |
| 2.1d | Add SystemConfig model + config service | Backend | 2h | 2.1 |
| 2.1e | Add Wallet + WalletTransaction models | Backend | 2h | 2.1 |
| 2.1f | Add TaxLine model + VAT calculation service | Backend | 2h | 2.1 |
| 2.1g | Add Cart + CartItem models | Backend | 2h | 2.1 |
| 2.2 | Service types & services CRUD endpoints | Backend | 12h | 2.1 |
| 2.3 | Pricing engine: price calculation (base + area + extras), availability check | Backend | 16h | 2.2 |
| 2.4 | Categories CRUD (tree structure) | Backend | 6h | 2.1 |
| 2.5 | Products CRUD (seller scoped), search (full-text + filters + sort) | Backend | 16h | 2.4 |
| 2.6 | Product variants & images | Backend | 8h | 2.5 |
| 2.7 | Seller profile creation + KYC document submission | Backend | 10h | 2.1 |
| 2.7a | Full-text search: PostgreSQL tsvector + GIN indexes for products and services | Backend | 3h | 2.5 |
| 2.7b | Trigram search setup for partial matching (pg_trgm extension) | Backend | 2h | 2.7a |
| 2.8 | Admin: product moderation (approve/reject), seller verification | Backend | 8h | 1.3 |
| 2.9 | Generate Dart models (service, product, category, seller, KYC) | Shared | 6h | 2.1 |
| 2.10 | Generate Retrofit API client (services, products, categories, seller) | Shared | 8h | 1.7 |
| 2.11 | Client app: Services list, Service detail, Booking form (area, rooms, extras) | Apps | 20h | 2.2 |
| 2.12 | Client app: Categories tree, Products list (grid/list), Product detail | Apps | 20h | 2.5 |
| 2.13 | Seller app: Dashboard, Products list, Add/Edit product (with variants/images) | Apps | 24h | 2.7 |
| 2.14 | Seller app: KYC page (document upload, status display) | Apps | 10h | 2.7 |
| 2.14a | Automated identity verification (liveness detection, face matching) | Backend | 3h | 2.14 |
| 2.14b | Document expiry validation + automated reminders | Backend | 2h | 2.14 |
| 2.14c | AML/PEP sanctions screening integration | Backend | 4h | 2.14 |
| 2.15 | File upload UI + MinIO upload logic (type whitelist, size limit, signed URLs) | Shared/Apps | 14h | 0.2 |
| 2.16 | Promo code module: CRUD, validate, apply to order | Backend | 10h | 2.1 |
| 2.17 | Service image upload + display for service types | Backend/Apps | 6h | 2.15 |

**Phase 2 total**: 216h (~27 days)

**Deliverables**: Full catalog management, seller can list products, client can browse services + products

---

## Phase 3: Orders & Logistics (Week 6-9) — CRITICAL PATH

**Goal**: Unified order engine, Yandex-style courier/prov assignment, real-time tracking with MapKit

| ID | Task | Scope | Effort | Dependencies |
|----|------|-------|--------|--------------|
| 3.1 | Prisma: Order, OrderItem, OrderStatusHistory, ProviderAssignment, CourierAssignment, Tracking, LocationPoint | Backend | 12h | 2.1 |
| 3.2 | Unified Order Engine: create order (service/product/mixed), state machine, validation | Backend | 24h | 3.1 |
| 3.2a | Add minimum amount validation: service orders min 30,000 UZS, product orders min 20,000 UZS, mixed orders min 50,000 UZS | Backend | 2h | 3.2 |
| 3.3 | Provider/Courier assignment algorithm: weighted scoring, radius expansion, timeouts | Backend | 20h | 3.2 |
| 3.4 | Mixed order processing: single courier, TSP route optimization | Backend | 16h | 3.3 |
| 3.5 | Order scheduling: ASAP + 30min windows, provider availability slots | Backend | 12h | 3.2 |
| 3.5a | Add booking hours validation: service orders only between 08:00-22:00, last slot at 21:00 | Backend | 2h | 3.5 |
| 3.5b | Add courier shift scheduling (morning/afternoon/night shifts) | Backend | 2h | 3.5 |
| 3.5c | Add provider no-show auto-cancel logic (15min grace period) | Backend | 2h | 3.5 |
| 3.6 | Order assignment WebSocket: notify nearby providers/couriers, accept/reject | Backend | 16h | 3.3 |
| 3.7 | Order status history + audit trail | Backend | 8h | 3.2 |
| 3.8 | Tracking WebSocket gateway: location stream (3-5s intervals), polyline, ETA calculation | Backend | 20h | 3.6 |
| 3.9 | Yandex Maps API integration: geocoding, routing, polyline encoding | Backend | 12h | 0.2 |
| 3.10 | Order cancellation flow with tiered fee logic:
  - Free cancellation within 5 minutes of booking
  - 10% fee (min 5,000 UZS) after provider assigned
  - 25% fee within 1 hour of scheduled time
  - 50% fee if provider on-site
  - Provider/courier acceptance → cancellation penalty (15,000 UZS / 10,000 UZS)
  - Provider no-show → 30,000 UZS penalty + client refund
  - Fee revenue allocation: client fees → provider, provider penalties → platform
  - Audit all cancellations in AuditLog | Backend | 10h | 3.2 |
| 3.11 | Generate Dart models (order, tracking, assignment) | Shared | 6h | 3.1 |
| 3.12 | Generate Retrofit API client (orders, tracking) | Shared | 8h | 3.11 |
| 3.13 | Client app: Cart implementation (products), Checkout flow (address, payment selection) | Apps | 20h | 2.12 |
| 3.14 | Client app: Service booking flow (select type → address → schedule → confirm) | Apps | 16h | 2.11 |
| 3.15 | Client app: Orders list, Order detail with status timeline | Apps | 12h | 3.2 |
| 3.16 | Client app: Live tracking page (Yandex MapKit, courier marker, ETA, route) | Apps | 24h | 3.8 |
| 3.17 | Provider app: Available orders feed (geo-filtered), Accept button, Timer countdown | Apps | 16h | 3.6 |
| 3.18 | Provider app: Active order, status updates, completion | Apps | 12h | 3.2 |
| 3.19 | Courier app: Available deliveries, Accept, Navigation to pickup/delivery | Apps | 16h | 3.6 |
| 3.20 | Courier app: Live map with route, location sharing, Proof of delivery (photo/signature) | Apps | 20h | 3.8 |
| 3.21 | Seller: Orders dashboard (incoming orders), Mark ready for pickup | Apps | 10h | 3.2 |
| 3.22 | WebSocket Flutter client: SocketClient, auto-reconnect, event handlers | Shared | 12h | 3.6 |
| 3.23 | Drift local cache for orders + tracking points (offline fallback) | Shared | 10h | 3.11 |

**Phase 3 total**: 350h (~44 days)

**Deliverables**: Complete order lifecycle, Yandex-style tracking, all 4 roles (client, provider, courier, seller) functional

---

## Phase 4: Real-Time Comms (Week 9-11) — starts after Phase 3 critical modules

**Goal**: Chat system, FCM push notifications, in-app notification center

| ID | Task | Scope | Effort | Dependencies |
|----|------|-------|--------|--------------|
| 4.1 | Prisma: Chat, Message | Backend | 4h | 3.1 |
| 4.2 | Chat WebSocket gateway: create chat, send message, typing, read receipts | Backend | 16h | 4.1 |
| 4.3 | System messages: auto-generate on order status changes → chat | Backend | 6h | 4.2 |
| 4.4 | FCM service: send push notifications (single, topic, multicast) | Backend | 10h | 0.5 |
| 4.5 | Notification triggers: order_assigned, status_change, payment, chat | Backend | 12h | 4.4 |
| 4.6 | In-app notification module: list, mark read, badge count | Backend | 8h | 4.5 |
| 4.7 | Device token registration + management | Backend | 6h | 4.5 |
| 4.8 | Generate Dart models (chat, message, notification) | Shared | 4h | 4.1 |
| 4.9 | Client app: Chat list page, Chat page (messages, typing, image sending) | Apps | 16h | 4.2 |
| 4.10 | Provider app: Chat integration for active orders | Apps | 10h | 4.2 |
| 4.11 | Courier app: Chat with client and provider | Apps | 10h | 4.2 |
| 4.12 | Seller app: Chat with client | Apps | 8h | 4.2 |
| 4.13 | Notifications UI: notification list, badge on app icon, deep linking | Apps | 14h | 4.6 |
| 4.14 | FCM integration on Flutter: firebase_messaging, background handler, foreground handler | Apps | 12h | 4.7 |
| 4.15 | Drift cache for chat messages (offline) | Shared | 6h | 4.8 |

**Phase 4 total**: 132h (~16 days)

**Deliverables**: Real-time chat between all roles, push notifications working on all 3 apps

---

## Phase 5: Payments & KYC (Week 11-13)

**Goal**: Click/Payme integration, auto-split payouts, KYC verification, earnings

| ID | Task | Scope | Effort | Dependencies |
|----|------|-------|--------|--------------|
| 5.0a | Add PayoutBatch model + batch processing service | Backend | 3h | 3.1 |
| 5.0b | Add Dispute + Refund models + dispute management endpoints | Backend | 4h | 5.0a |
| 5.0c | Add cart → checkout → order conversion flow | Backend | 5h | 2.1g, 3.2 |
| 5.1 | Prisma: Payment, Payout models | Backend | 4h | 3.1 |
| 5.2 | Click integration: init payment, callback webhook (idempotent), check status, refund | Backend | 22h | 5.1 |
| 5.3 | Payme integration: init payment, webhook, check status, refund | Backend | 22h | 5.1 |
| 5.4 | Payment flow: order → initiate → redirect → webhook → confirm → order status update | Backend | 12h | 5.2, 5.3 |
| 5.5 | Commission calculator: 15% split, platform fee, net amount | Backend | 6h | 5.4 |
| 5.6 | Auto-payout: on delivery_confirmed → commission calc → queue → batch
  - Provider payout: weekly Tuesday, min 100,000 UZS
  - Courier payout: weekly Wednesday, min 50,000 UZS (or daily if balance > 200,000 UZS)
  - Seller payout: weekly Monday, min 50,000 UZS
  - Configurable schedule via SystemConfig | Backend | 14h | 5.5 |
| 5.7 | Return & refund flow: 14-day return window, inspection, refund processing | Backend | 4h | 5.4 |
| 5.8 | Customer dispute resolution workflow (ticketing, admin review, escalation) | Backend | 3h | 5.7 |
| 5.9 | KYC moderation UI endpoints: pending list, approve/reject with reason | Backend | 8h | 2.8 |
| 5.10 | Cash payment handling (marked as paid on delivery) | Backend | 4h | 5.4 |
| 5.11 | Generate Dart models (payment, payout) | Shared | 3h | 5.1 |
| 5.12 | Client app: Payment sheet (Click/Payme), Payment status display | Apps | 14h | 5.4 |
| 5.13 | Provider app: Earnings summary, payout history | Apps | 10h | 5.6 |
| 5.14 | Courier app: Earnings per delivery, daily/weekly summary | Apps | 10h | 5.6 |
| 5.15 | Seller app: Sales analytics, payout history, commission display | Apps | 12h | 5.6 |
| 5.16 | KYC UI: document upload (passport, selfie, bank card, inn), status tracking | Apps | 12h | 2.14 |

**Phase 5 total**: 172h (~21 days)

**Deliverables**: Working payments (Click/Payme), auto-payouts, KYC verification flow, returns & disputes

---

## Phase 6: Flutter Apps Polish (Week 13-16)

**Goal**: Feature completion, UX polish, offline-first, all 3 apps ready

| ID | Task | Scope | Effort | Dependencies |
|----|------|-------|--------|--------------|
| 6.0a | Guest browsing mode: unauthenticated catalog browsing, sign-in gated checkout | Apps/Backend | 3h | 0.8 |
| 6.1 | Client app: Home screen (featured services, popular products, promo banners) | Apps | 12h | Phase 2 |
| 6.2 | Client app: Product search & filter (category, price range, brand, rating) | Apps | 8h | 2.12 |
| 6.3 | Client app: Cart persistence (Drift), quantity management, saved for later | Apps | 10h | 3.13 |
| 6.3a | LocationPoint monthly partitioning: automated partition creation, drop partitions older than 90 days | Backend | 2h | 3.8 |
| 6.4 | Client app: Order reorder (repeat previous order) | Apps | 6h | 3.15 |
| 6.5 | Client app: Review & rate provider/courier after order completion | Apps | 8h | Phase 3 |
| 6.5a | Insurance module: provider insurance verification, damage claim filing | Backend | 2h | 6.5 |
| 6.6 | Client app: Address management page (add/edit/delete) | Apps | 6h | 1.2 |
| 6.7 | Client app: Settings page (language, notifications, about, logout) | Apps | 6h | 1.8 |
| 6.8 | Provider app: Weekly schedule manager (set available days/times) | Apps | 8h | Phase 3 |
| 6.9 | Provider app: Service history, completed orders | Apps | 6h | 3.18 |
| 6.10 | Courier app: Daily route overview, multi-order batch view | Apps | 10h | 3.20 |
| 6.11 | Courier app: Proof of delivery (photo capture + signature pad) | Apps | 8h | 3.20 |
| 6.12 | Seller app: Product inventory management, stock alerts | Apps | 10h | 2.13 |
| 6.13 | Seller app: Sales analytics charts (revenue, orders, top products) | Apps | 10h | 5.15 |
| 6.14 | Seller app: Customer reviews page, respond to reviews | Apps | 6h | 6.5 |
| 6.15 | All apps: Error boundaries (GlossError widget, retry, empty states) | Apps/Shared | 8h | Phase 1 |
| 6.16 | All apps: Loading skeletons for all list/detail pages | Apps | 8h | — |
| 6.17 | Offline sync queue: Drift cache → background sync on connectivity | Shared | 10h | 1.12 |
| 6.18 | i18n completion: all user-facing strings in uz/ru/en | Apps/Shared | 16h | 1.11 |
| 6.19 | Accessibility: semantic labels, large fonts, contrast | Apps | 8h | — |
| 6.20 | Deep linking: notification → specific order/chat page | Apps | 6h | 4.13 |
| 6.21 | Performance optimization: image caching, lazy loading, shimmer | Apps | 8h | — |
| 6.22 | Analytics events: track user actions (GA4/Firebase Analytics) | Apps | 8h | — |
| 6.22a | Certificate pinning implementation | Apps/Shared | 2h | 0.8 |
| 6.22b | Root/jailbreak detection | Apps/Shared | 2h | 0.8 |
| 6.22c | Password hashing (argon2id) implementation | Backend | 2h | 0.4 |
| 6.22d | OTP brute force protection + rate limiting | Backend | 3h | 0.5 |
| 6.22e | CORS configuration + CSRF protection | Backend | 2h | 0.3 |
| 6.22f | GDPR data export endpoint + account deletion flow | Backend/Apps | 5h | 0.5 |
| 6.23 | Theme customization: light/dark mode toggle | Apps | 6h | — |
| 6.24 | Yandex MapKit permissions handling (location permit, API key mgmt per platform) | Apps | 8h | Phase 3 |
| 6.25 | Offline conflict resolution UI: show conflicts, user choices | Apps | 8h | 6.17 |
| 6.26 | Webhook security: HMAC signature verification for Click + Payme | Backend | 8h | Phase 5 |
| 6.27 | File upload security: MIME whitelist, ClamAV scan, signed URL expiry | Backend | 6h | 2.15 |
| 6.28 | Add forgot password / change password UI to all 3 apps | Apps | 8h | 0.8 |

**Phase 6 total**: 217h (~27 days)

**Deliverables**: 3 production-ready Flutter apps with offline support, i18n, full feature set

---

## Phase 7: Hardening & Launch (Week 16-17) — 2 weeks buffer

**Goal**: Testing, security, monitoring, documentation, deployment

| ID | Task | Scope | Effort | Dependencies |
|----|------|-------|--------|--------------|
| 7.1 | API load testing: k6 (10k RPS orders, 5k WS connections) | QA | 16h | Phase 3 |
| 7.2 | Security audit: OWASP top 10, dependency scanning (Snyk/Dependabot) | Security | 16h | Phase 5 |
| 7.3 | PII encryption audit: phone, passport, bank card | Security | 8h | Phase 5 |
| 7.4 | Sentry integration: backend error tracking | Observability | 6h | — |
| 7.5 | Logging setup: structured JSON logs (Pino) → Loki | Observability | 8h | — |
| 7.6 | Metrics: Prometheus custom metrics (orders/min, active users, latency) | Observability | 10h | — |
| 7.7 | Grafana dashboards: business & technical KPIs | Observability | 12h | 7.6 |
| 7.8 | E2E tests: critical paths (Flutter Patrol) | QA | 20h | Phase 6 |
| 7.9 | Integration tests: full flows (backend) | QA | 16h | Phase 5 |
| 7.10 | Documentation: API docs (Swagger/OpenAPI), runbooks, deployment guide | Docs | 12h | Phase 5 |
| 7.11 | Docker optimization: multi-stage build, image size reduction | DevOps | 6h | — |
| 7.12 | Staging environment setup, deployment test | DevOps | 8h | — |
| 7.13 | UAT with stakeholders, bug fixing | QA/Dev | 24h | 7.12 |
| 7.14 | Production deployment (blue-green), DNS config, SSL | DevOps | 12h | 7.12 |
| 7.15 | Post-launch monitoring (first 48 hours) | All | 16h | 7.14 |

**Phase 7 total**: 190h (~24 days)

**Deliverables**: Production-ready system, monitoring, documentation

---

## Summary

| Phase | Effort (hours) | Duration (weeks) | Key Deliverable |
|-------|:-------------:|:----------------:|-----------------|
| 0: Foundation | 95h | 1 | Monorepo, Docker, CI, Auth, Splash, Deeplink |
| 1: Core Domain | 102h | 2 | Users, Addresses, RBAC, Admin |
| 2: Catalog | 232h | 3 | Services, Products, Sellers, Promo, Images, Search |
| 3: Orders & Logistics | 350h | 4 | Orders, Assignment, Tracking, Cancellations (CRITICAL) |
| 4: Real-Time Comms | 132h | 2 | Chat, Push Notifications |
| 5: Payments & KYC | 172h | 2 | Payments, Payouts, KYC, Returns, Disputes |
| 6: Flutter Polish | 265h | 4 | All 3 apps complete, security hardening, compliance |
| 7: Hardening & Launch | 190h | 2 | Testing, Security, Monitoring |
| **Total** | **1538h** | **~17 weeks** | **Production launch** |

## Critical Path (Must be on schedule)

```
Phase 0 → Phase 1 → Phase 2 (incl. model additions) → Phase 3 → Phase 5 → Phase 6 → Phase 7
                                                         ↓
                                                    Phase 4 (parallel start after Phase 3.6)
                                                         ↓
                                                    Phase 6.24-6.28 (security polish)
```

Phase 3 (Orders & Logistics) is the **longest and most critical** — 350h across all apps. This is the core Yandex-Go logic.
Phase 2 model additions (2.1a–2.1g, 2.7a–2.7b, 2.14a–2.14c) are on the critical path and must not slip.
Phase 6 now includes security hardening (webhook sig, file upload security, permissions, compliance).

## Risk Mitigation

| Risk | Probability | Impact | Mitigation |
|------|:----------:|:------:|-----------|
| Yandex MapKit integration complexity | High | High | Start POC in Phase 2, API key mgmt documented |
| WebSocket scaling issues | Medium | High | Use Redis adapter from day 1 |
| Payment integration delays | Medium | High | Mock payment in Phase 3, real in Phase 5 |
| Flutter build pipeline issues | Low | Medium | CI build check on every PR |
| DB performance (tracking points) | Medium | Medium | Partition location_points by month |
| Multi-role app complexity | Medium | Medium | Design role switch at Phase 0 |
| Webhook security gaps | Medium | High | HMAC verification + IP whitelist in Phase 5 |
| Offline sync conflicts | Medium | Medium | Conflict resolution UI + FIFO queue in Phase 6 |

## First Milestone: Phase 0 Completion

After Phase 0, the system should have:
- Running backend with PostgreSQL + Redis + MinIO
- User registration/login with JWT
- RBAC guards in place
- 3 Flutter apps showing auth screens
- CI pipeline passing
- Developer can run entire stack with `docker compose up`
