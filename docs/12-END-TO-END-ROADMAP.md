# Gloss — End-to-End Roadmap (v2, tasdiqlangan biznes-model asosida)

> Bu hujjat `GLOSS_BUILD_PLAN.md`dagi dastlabki rejani, keyingi suhbatlarda aniqlashtirilgan qarorlar bilan yangilaydi. Farqlar pastda **[YANGILANDI]** deb belgilangan.

## 0. Tasdiqlangan biznes-model

```
Gloss (platforma, super-admin)
    ├── Product Owner = Gloss'ning o'zi   [YANGILANDI] — market mahsulotlarini FAQAT superadmin qo'shadi, alohida seller app/rol yo'q
    ├── Delivery = Gloss'ning o'z floti    [YANGILANDI] — cleaning ishchilarga aloqasi yo'q, tenant'ga bog'liq emas, platform-level
    └── Firmalar (tenant, cleaning kompaniyalar)
         ├── avval Gloss bilan shartnoma → keyin buyurtma olish huquqi
         ├── buyurtma taqsimoti: geolokatsiya + firma bo'yicha
         └── ishchi/kuryer ro'yxatdan o'tishi — firma admin bergan invite-ID orqali  [YANGILANDI]
```

**4 ta app:**
| App | Foydalanuvchi | Asosiy funksiya |
|---|---|---|
| `gloss_client` (Client) | Mijoz | Cleaning order + Market (faqat ko'rish/xarid, sotmaydi) |
| `gloss_worker` | Firma ishchisi | Invite-ID bilan ro'yxatdan o'tadi, buyurtma qabul qiladi |
| `gloss_delivery` | Gloss kuryeri | Faqat market buyurtmalarini yetkazadi, platform-level |
| `gloss_admin` (React) | platform_admin / tenant_admin | Bitta app, rolga qarab ko'rinish |

`gloss_seller` **kerak emas** — market CRUD `platform_admin` orqali.

---

## 1. Tech Stack (yakuniy)

| Qatlam | Texnologiya | Izoh |
|---|---|---|
| Backend | **Django 5.1 + DRF** | Modulli monolit, `apps/` bo'yicha bo'lingan |
| Geo | **GeoDjango + PostGIS** | Dispatch uchun geo-query (`Distance`, `select_for_update(skip_locked=True)`) |
| DB | **PostgreSQL 16 + PostGIS 3.4** | |
| Cache/Queue broker | **Redis 7** | Celery broker + Channels layer + cache |
| Real-time | **Django Channels** | WebSocket — order/dispatch/delivery eventlari |
| Background jobs | **Celery** | Dispatch timeout (15s/30s), payout, notification |
| Auth | **djangorestframework-simplejwt** | JWT + refresh, multi-role claim |
| Mobil (4 app) | **Flutter 3.x + Riverpod + GoRouter** | `packages/shared/*` orqali umumiy kod |
| Admin panel | **React 18 + TS + Vite + Tailwind + Radix UI** | Rolga qarab route (`pages/platform`, `pages/tenant`) |
| Push | **Firebase Cloud Messaging** | `firebase-admin` (Python SDK) |
| Xarita | **Yandex MapKit (mobil) + GeoDjango (backend)** | |
| To'lov | **Payme / Click** | Platforma pulni to'g'ridan-to'g'ri ushlamaydi (huquqiy talab) |
| OTP | Telegram Gateway (default) / Eskiz-PlayMobile SMS / flash-call | Strategy pattern, foydalanuvchi tanlaydi |
| Infra | Docker Compose (dev) → UZCLOUD/Ahost (prod, UZ data-markaz) | Lokalizatsiya qonuni (§11.1) |
| CI | GitHub Actions | `backend-test` job qo'shildi (M0'da tayyor) |

---

## 2. Ma'lumotlar bazasi sxemasi (asosiy jadvallar)

### Platform-level (tenant_id YO'Q)
```
User            (id, phone, is_active, created_at)
UserRole        (id, user_id→User, role[platform_admin|tenant_admin|tenant_worker|customer|courier], tenant_id→Tenant NULL)
Tenant          (id, name, phone, city, status[pending|active|suspended], contract_signed_at, created_at)
CommissionRule  (id, service_type, tenant_id→Tenant NULL, percentage)
ServiceCategory (id, name, description)
Tariff          (id, service_category_id, name, base_price, duration_min)
Addon           (id, tariff_id, name, price)
Product         (id, name, description, price, stock_qty, category, image_url, is_active)  # faqat platform_admin yozadi
Courier         (id, user_id→User 1:1, status[available|busy|offline], location Point)      # Gloss'ning o'z floti
DeviceToken     (id, user_id, token, platform[android|ios])
OtpRequest      (id, phone, channel, code_hash, expires_at, verified_at, attempts)
AuditLog        (id, actor_user_id, action, target_model, target_id, before JSON, after JSON, created_at)
Notification    (id, user_id, title, body, type, read_at, created_at)
```

### Tenant-scoped (har birida `tenant_id` majburiy + RLS)
```
Team            (id, tenant_id, name, status[available|busy|offline], location Point, rating_avg)
WorkerProfile   (id, user_id→User 1:1, tenant_id, team_id NULL, status)
WorkerInviteCode(id, tenant_id, code, is_used, used_by_user_id NULL, expires_at, created_at)
Order           (id, customer_id, tenant_id NULL-until-assigned, team_id NULL, tariff_id, address_id,
                 status[searching|assigned|en_route|arrived|in_progress|completed|rated|cancelled],
                 scheduled_time, total_price, commission_amount, net_amount, created_at, completed_at)
DispatchQueue   (id, order_id, team_id, status[pending|accepted|timeout], is_winner, offered_at, responded_at)
Review          (id, order_id 1:1, customer_id, team_id, aspect1, aspect2, aspect3, comment, created_at)
Wallet          (id, tenant_id 1:1, balance)
Transaction     (id, wallet_id, order_id NULL, type[commission_credit|payout|adjustment], amount, created_at)
```

### Market/Delivery (platform-level, tenant_id YO'Q — [YANGILANDI])
```
Address           (id, user_id, label, point, raw_address, city)
Cart              (id, customer_id 1:1)
CartItem          (id, cart_id, product_id, qty)
MarketOrder       (id, customer_id, address_id, status[pending|confirmed|assigned_courier|
                   en_route_to_pickup|picked_up|en_route_to_delivery|delivered|completed|cancelled],
                   total_price, payment_method, created_at)
MarketOrderItem   (id, market_order_id, product_id, qty, unit_price)
DeliveryAssignment(id, market_order_id, courier_id, status, assigned_at, picked_up_at, delivered_at)
```

**Muhim RLS qoidasi:** `Order`, `Team`, `WorkerProfile`, `Wallet`, `Transaction`, `WorkerInviteCode`, `DispatchQueue`, `Review` — shu jadvallarga Postgres RLS policy + Django manager filter ikkalasi ham qo'llanadi. `Product`, `MarketOrder`, `Courier`, `CommissionRule` (default), `ServiceCategory` — tenant filtridan **ozod**, chunki platform-level.

---

## 3. API Endpointlar (modul bo'yicha)

### Auth (`/api/auth/`)
```
POST   /otp/send/                    # {phone, channel}
POST   /otp/verify/                  # {phone, code} → temp token
POST   /register/                    # customer/courier — {temp_token, name}
POST   /worker/register/             # {temp_token, invite_code, name}  [YANGILANDI]
POST   /login/refresh/
POST   /device-token/                # FCM token ro'yxatdan o'tkazish
POST   /marketing-consent/           # {consent: true/false}
```

### Tenants (`/api/tenants/`) — faqat platform_admin
```
GET    /                             # ro'yxat
POST   /                             # yangi firma yaratish (qo'lda, M5)
GET    /{id}/
PATCH  /{id}/
POST   /{id}/suspend/
POST   /{id}/activate/
```

### Workers (`/api/workers/`) — tenant_admin o'z tenantida
```
GET    /
POST   /invite-codes/                # kod generatsiya  [YANGILANDI]
GET    /invite-codes/{code}/validate/
DELETE /{id}/                        # ishdan bo'shatish
```

### Teams (`/api/teams/`)
```
GET    /                             # tenant_admin: o'ziniki; platform_admin: filtr bilan hammasi
PATCH  /{id}/status/                 # online/offline toggle (worker app)
```

### Catalog (`/api/services/`) — platform-level, hammaga ochiq (auth talab qilinadi)
```
GET    /categories/
GET    /tariffs/
GET    /addons/
GET    /time-slots/
```

### Addresses (`/api/addresses/`)
```
GET / POST / PATCH / DELETE
```

### Orders — cleaning (`/api/orders/`)
```
POST   /                             # order yaratish → status: searching
GET    /                             # tarix
GET    /{id}/
POST   /{id}/cancel/                 # {reason?} — status-based validatsiya
POST   /{id}/rate/                   # {aspect1, aspect2, aspect3, comment}
```

### Dispatch (`/api/dispatch/`) — worker app
```
POST   /orders/{id}/accept/          # atomik, select_for_update(skip_locked=True)
GET    /offers/                      # fallback poll (asosiy — WebSocket)
```

### Billing (`/api/billing/`)
```
GET    /wallet/                      # tenant_admin — o'ziniki
GET    /wallet/transactions/
POST   /payouts/                     # platform_admin trigger qiladi
```

### Market (`/api/market/`)
```
GET    /products/                    # public (auth bilan)
POST   /products/                    # faqat platform_admin
PATCH  /products/{id}/
DELETE /products/{id}/
GET    /cart/
POST   /cart/items/
POST   /cart/checkout/               # → MarketOrder yaratadi
GET    /market-orders/
POST   /market-orders/{id}/cancel/
```

### Delivery (`/api/delivery/`) — courier app
```
GET    /assignments/
POST   /assignments/{id}/accept/
PATCH  /assignments/{id}/status/     # picked_up / delivered
```

### Notifications (`/api/notifications/`)
```
GET    /
POST   /{id}/read/
```

### Audit (`/api/audit-logs/`) — faqat platform_admin
```
GET    /                             # filtr: actor, action, date range
```

### Health
```
GET    /health/                      # M0'da tayyor
```

---

## 4. WebSocket Event Shartnomasi

| Event | Yo'nalish | Payload |
|---|---|---|
| `order.new_offer` | server → team | order_id, service, address, deadline (15s) |
| `order.assigned` | server → g'olib team | order_id, team_id |
| `order.cancelled` | server → qolgan teamlar | order_id |
| `order.status_changed` | server → client | order_id, status |
| `order.team_location` | server → client | order_id, lat, lng (10s throttle) |
| `order.eta_updated` | server → client | order_id, eta |
| `delivery.new_offer` | server → courier | market_order_id, pickup, deadline |
| `delivery.assigned` | server → courier | market_order_id |
| `delivery.status_changed` | server → client | market_order_id, status |
| `delivery.courier_location` | server → client | market_order_id, lat, lng |

---

## 5. Bosqichli Roadmap

### ✅ M0 — Skeleton (BAJARILDI)
Django + GeoDjango + DRF + Channels + Celery skeleton, Docker Compose (Postgres+PostGIS, Redis), `/health/`, CI (`backend-test` job), `melos.yaml` tuzatildi.

### M1 — Tenancy + RBAC poydevori
- Yuqoridagi platform-level va tenant-scoped modellar (Prisma o'rniga Django ORM + GeoDjango)
- `TenantScopedManager` (avtomatik `tenant_id` filtri) + Postgres RLS policy
- JWT multi-role claim, `IsPlatformAdmin` / `IsTenantAdmin` permission klasslari
- **`AuditLog` modeli + signal-based yozish** (kim, nima, qachon) — bu yerda qoladi, chunki strukturaviy va UI'ga bog'liq emas
- ~~2FA~~ → **M5'ga ko'chirildi** (admin login ekrani faqat M5'da paydo bo'ladi, undan oldin 2FA qo'yish uchun joy yo'q)
- **Gate:** tenant A tokeni bilan tenant B ma'lumotiga so'rov — 0 natija, RLS ham, manager filtri ham ishlaganini alohida test qilib tasdiqlash

### M2 — Auth + Catalog + Booking
- OTP strategy pattern (Telegram/SMS/flash-call), `marketing_consent`
- **Worker invite-code oqimi**: tenant_admin kod yaratadi → worker ro'yxatdan o'tishda kiritadi → `WorkerProfile` yaratiladi (`tenant_id` shu kod orqali biriktiriladi)
- Catalog (categories/tariffs/addons/time-slots), Addresses
- `POST /orders/` — real yozuv, status `searching`, hech qanday mock yo'q
- **Gate:** client app orqali real order yaratiladi, worker invite-code bilan ro'yxatdan o'tadi

> **[YANGI] M2'dan keyin tarmoqlanish nuqtasi:** M3 (dispatch) — eng qiyin va eng ko'p vaqt talab qiladigan qism. M6 (Market+Delivery) esa multi-tenant dispatch murakkabligiga **umuman bog'liq emas** — faqat shu yerdagi auth+addresses'ga muhtoj. Ya'ni pastdagi M3→M4→M5 ketma-ketligi **majburiy emas**: xohlasang M6'ni M2'dan keyin darrov qilib, keyin M3'ga o'tishing ham mumkin (masalan tezroq daromad/demo kerak bo'lsa). Standart tartib pastda — chunki asosiy MVP (loyihaning "og'ir" qismi) cleaning-service sikli, market esa qo'shimcha.

### M3 — Dispatch + Real-time (eng murakkab, eng ko'p vaqt shu yerga ketadi)
- `findEligibleTeams` — GeoDjango distance query, **barcha aktiv tenantlar bo'ylab**, `select_for_update(skip_locked=True)`
- Celery: 15s offer timeout, 30s/3-marta escalation
- Channels consumers — yuqoridagi event jadvali
- Order state machine + cancel guard'lar
- **Gate:** concurrency test — ikkita team bir vaqtda accept qilsa, faqat bittasi g'olib (avtomatlashtirilgan test, qo'lda emas)

### M4 — Loop yopish + Billing
- Cancel, Review (3-aspect), Notification (FCM)
- `Order.completed` → signal → commission hisoblash → `Wallet` + `Transaction`
- **Gate:** to'liq customer↔worker sikli + komissiya to'g'ri tenant wallet'ga tushadi (e2e test)

### M5 — Tenant Onboarding + Admin Panel + Admin xavfsizligi
- Qo'lda tenant yaratish (platform_admin), suspend/activate
- Payout/settlement endpoint
- `gloss_admin` React: platform-admin (tenantlar, komissiya, **market CRUD — Product Owner shu yerda**, barcha buyurtmalar, audit log ko'rinishi) + tenant-admin (o'z ishchilari + invite-code, o'z buyurtmalari, wallet)
- **[YANGI] Platform_admin login uchun majburiy 2FA (TOTP) + qisqa session muddati** — endi admin login ekrani mavjud bo'lgani uchun shu yerda qo'shiladi
- **Gate:** platform_admin yangi firma yaratadi → firma tenant_admin panelga kiradi → invite-code bilan ishchi qo'shadi → buyurtma qabul qilinadi

### M6 — Market + Delivery
- Market: `Product` (faqat platform_admin), Cart, Checkout, `MarketOrder`
- `gloss_delivery` app + `Courier`/`DeliveryAssignment` — **platform-level flot, tenant'ga bog'liq emas**
- Payme/Click integratsiyasi
- **[YANGI] Bu bosqich M2'dan keyin istalgan payt ko'chirilishi mumkin** — yuqoridagi tarmoqlanish nuqtasiga qarang

---

## 6. Keyingi bosqich (MVP'dan keyin, real ehtiyoj chiqqanda)
- Granular permission/sub-rollar (hozircha 2-rol yetarli)
- Avtomatik suspend qoidalari (hozircha qo'lda)
- Impersonation/support mode
- Real-time analytics dashboard (M3 Channels infratuzilmasidan foydalanadi, arzon qo'shimcha)

Batafsil kontekst: [[GLOSS_BUILD_PLAN.md]] (dastlabki reja, ba'zi qismlari bu hujjat bilan yangilangan).
