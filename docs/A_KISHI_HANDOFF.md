# A-kishi uchun Handoff

> **Kimdan:** B-kishi (frontend)  
> **Kimga:** A-kishi (backend)  
> **Sana:** 2026-07-16  
> **Maqsad:** B-kishi client app'larni qurish davomida aniqlagan barcha backend bo'shliqlar va A-kishi bajarishi kerak bo'lgan ishlar ro'yxati.

---

## 0. B-kishi nimalarni qurdi (tayyor)

### gloss_design (`packages/gloss_design`)
Flutter design system — 4 app'ning hammasi bitta dizayn tilida:
- **36 semantic color token** — `gloss_design/lib/src/colors.dart` da: `glossBg`, `glossGreen`, `glossText`, `glossRed`, `glossOrange`, `glossStar`, catBlue/Orange/Purple/Brown/Pink/Cyan/Amber, greenBgLight/Soft/Pale/Mint, grayLight/Medium/Dark, border/divider/disabled, shadow/tint va boshqalar.
- **GlossTheme** — `ThemeExtension<GlossTheme>` — `context.gloss.green` orqali ishlatiladi. `light` static varianti mavjud. copyWith/lerp implementatsiya qilingan.
- **5 widget:** `app_back_button.dart`, `gloss_widgets.dart` (umumiy widget eksporti).
- `gloss_design/lib/src/typography.dart` — tipografika maydoni ajratilgan.

### gloss_routing (`packages/gloss_routing`)
GoRouter + role guardlar:
- **3 ta router:** `customerRouter()`, `workerRouter()`, `deliveryRouter()` — har biri o'z route daraxti bilan.
- **RoleGuard:** `platformAdmin`, `tenantAdmin`, `worker`, `customer`, `courier` rollari bilan `canAccess()` validatsiyasi.
- **23 ta customer route**, **9 ta worker route**, **3 ta delivery route** — hammasi `GlossRoutes` konstantalaridan olinadi.
- Route'lar `Placeholder()` widget bilan to'ldirilgan — real ekranlar `apps/` ichida.

### gloss_models (`packages/gloss_models`)
10 ta model stub — hammasi qo'lda yozilgan oddiy Dart class. Freezed ishlatilmagan:
- `User` — `id, name, phone, email, role, avatarUrl, tenantId, createdAt` — `fromJson/toJson/copyWith`
- `Order` — `id, serviceId, serviceName, customerId, teamId, address, status, totalAmount, commissionAmount, tenantId, createdAt, completedAt`
- `CleaningService` — `id, name, description, iconUrl, category, basePrice, tenantId`
- `Team` — `id, name, tenantId, rating, totalOrders, members: List<TeamMember>`
- `TeamMember` — `id, name, phone, role`
- `Wallet` — `balance, transactions: List<Transaction>`
- `Transaction` — `id, amount, description, type (credit/debit), createdAt`
- `Review` — `id, orderId, customerName, quality, punctuality, communication, comment, createdAt` — `averageRating` getter
- `Product` — `id, name, description, imageUrl, category, price, stock, rating`
- `AppNotification` — `id, title, message, type, isRead, createdAt`
- `Address` — `id, label, address, floor, apartment, lat, lng` — `fromJson/toJson`
- `Tenant` — `id, name, phone, city, status (active/suspended), createdAt`
- `UserRole` / `UserRoleEnum` — role konstantalari + enum xaritasi

**MUHIM:** B-kishi stub modellar hozir `camelCase` JSON formatida ishlaydi (`.fromJson`). A-kishi freezed bilan qayta yozganda `@JsonKey(name: 'tenant_id')` orqali `snake_case` ga moslashi kerak.

### gloss_core (`packages/gloss_core`)
3 ta stub — skeleton holatda, real implementatsiya YO'Q:
- **ApiClient** — singleton, `Dio` instance, `init(baseUrl)`, `get/post/put/delete` metodlari, token set/clear. **Auto-refresh token yo'q** — faqat 401 da tokenni o'chiradi, refresh qilmaydi.
- **SocketClient** — singleton, `connect/disconnect/on/emit/off` metodlari stub. Haqiqiy `socket.io` client ulanmagan.
- **SecureStorage** — `write/read/delete/deleteAll` stub. `flutter_secure_storage` paketi ulanmagan.

### gloss_user (`apps/gloss_user`) — Mijoz app (Flutter)
**23 ta ekran**, feature-first strukturasi:
```
features/
├── auth/        — Splash, Auth (telefon raqam kiritish), Verify (OTP), Register (ism kiritish)
├── home/        — Home (2 tab: Xizmatlar + Market)
├── services/    — Xizmatlar (katalog), Booking (8 qadam), TimeSlot, AddressSearch,
│                  Order (4-bosqich timeline), TeamInfo, CancelReason, MultiAspectRating,
│                  OrderHistory, OrderSuccess
├── market/      — Market, ProductDetail, Cart, Checkout, Favorites
├── profile/     — Profile, SavedAddresses
└── notifications/ — Notifications
```
Har bir feature'da `screens/`, `providers/` mavjud. `core/` da `repositories/`, `services/`, `api/`, `models/`, `logging/`, `theme/` bor. Repositories: `auth`, `service`, `order`, `team`, `product`, `cart`, `payment`, `notification`.

### gloss_worker (`apps/gloss_worker`) — Ishchi app (Flutter)
**14 ta ekran**, feature-first strukturasi:
```
features/
├── auth/         — Splash, Auth, Verify, Register
├── home/         — WorkerHome (online/offline toggle)
├── orders/       — Orders (status tab'lari), OrderDetail
├── availability/ — SetAvailability (ish vaqti, zona)
├── stats/        — Stats (daromad, reyting, bajarilgan)
├── profile/      — Profile
├── wallet/       — Wallet (balans, tranzaksiyalar, yechib olish)
├── support/      — Support
├── notifications/— Notifications
└── settings/     — Settings
```

### gloss_delivery (`apps/gloss_delivery`) — Kuryer app (Flutter)
Skelet holatida — `main.dart` + router mavjud. Ekranlar to'liq qurilmagan.

### gloss_admin (`apps/gloss_admin`) — Admin panel (React + Vite + TypeScript)
**15 ta sahifa**, role-based:
```
pages/
├── login.tsx
├── platform/   — Dashboard, Tenants (CRUD), Commissions (xizmat turi %),
│                 Orders (barcha tenantlar), Users, Market (products CRUD),
│                 Payouts, Settings
└── tenant/     — Dashboard, Workers (CRUD), Orders (o'z firmasi),
                  Wallet, Ratings (sharhlar), Settings
```
`src/components/ui/` da shadcn/ui komponentlari (button, card, input, select, table, tabs, badge, dialog, dropdown-menu). `src/components/layout/` da sidebar, header, dashboard-layout. `src/lib/api-client.ts`, `src/hooks/use-auth.ts`, `src/context/auth-context.tsx` mavjud.

---

## 1. gloss_models — A-kishi qurishi kerak

B-kishi **oddiy Dart class stub** yozdi. A-kishi **freezed + json_serializable** bilan immutable modellarni yozishi kerak. Har model `snake_case` JSON bilan ishlashi shart.

### 1.1. User
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String phone,
    String? email,
    String? avatarUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<UserRole> roles,
    @JsonKey(name: 'tenant_id') String? tenantId,
    @JsonKey(name: 'marketing_consent') @Default(false) bool marketingConsent,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**Maydon izohlari:**
| Maydon | Tip | Izoh |
|---|---|---|
| `id` | UUID | PK |
| `name` | String | Ism |
| `phone` | String | Telefon raqam, unique |
| `email` | String? | Ixtiyoriy |
| `avatarUrl` | String? | Profil rasmi URL |
| `roles` | List\<UserRole\> | Ko'p rolli — `customer`, `tenant_admin`, `tenant_worker`, `courier`, `platform_admin` |
| `tenant_id` | String? (FK → tenants) | Agar worker yoki tenant_admin bo'lsa, tegishli tenant. Customer uchun NULL |
| `marketing_consent` | bool | Marketing SMS/qo'ng'iroq roziligi (2026 qonuni) |
| `createdAt` | DateTime | |
| `updatedAt` | DateTime | |

### 1.2. Order (Status Machine)
```dart
enum OrderStatus { searching, assigned, enRoute, arrived, inProgress, completed, rated, cancelled }

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'service_name') String? serviceName,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'team_id') String? teamId,
    @JsonKey(name: 'tenant_id') String? tenantId,
    @JsonKey(name: 'address_id') required String addressId,
    Address? address,
    required OrderStatus status,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'commission_amount') double? commissionAmount,
    @JsonKey(name: 'commission_rate') double? commissionRate,
    @JsonKey(name: 'scheduled_at') DateTime? scheduledAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'cancel_reason') String? cancelReason,
    @JsonKey(name: 'cancel_note') String? cancelNote,
    @JsonKey(name: 'eta_minutes') int? etaMinutes,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? completedAt,
    Review? review,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
```

**Status machine qoidalari:**
```
searching → assigned (team qabul qilganda)
assigned → enRoute (team yo'lga chiqqanda)
enRoute → arrived (manzilga yetganda)
arrived → inProgress (ish boshlanganda)
inProgress → completed (ish tugaganda)
completed → rated (mijoz baho berdi)

searching/assigned/enRoute → cancelled (bekor qilish)
arrived → cancelled (mijoz sababi bilan)
inProgress → cancelled (FAQAT admin)
completed → cancelled (MUMKIN EMAS)
```

### 1.3. Service / Tariff / Addon
```dart
@freezed
class Service with _$Service {
  const factory Service({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? category,
    @JsonKey(name: 'base_price') required double basePrice,
    @JsonKey(name: 'price_unit') @Default('hour') String priceUnit, // hour, sqm, fixed
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'tenant_id') String? tenantId, // NULL = platforma darajasida
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Service;
  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
}

@freezed
class Tariff with _$Tariff {
  const factory Tariff({
    required String id,
    @JsonKey(name: 'service_id') required String serviceId,
    required String name,
    required double price,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    String? description,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    required DateTime createdAt,
  }) = _Tariff;
  factory Tariff.fromJson(Map<String, dynamic> json) => _$TariffFromJson(json);
}

@freezed
class Addon with _$Addon {
  const factory Addon({
    required String id,
    @JsonKey(name: 'service_id') required String serviceId,
    required String name,
    required double price,
    String? description,
    required DateTime createdAt,
  }) = _Addon;
  factory Addon.fromJson(Map<String, dynamic> json) => _$AddonFromJson(json);
}
```

### 1.4. Team / TeamMember
```dart
@freezed
class Team with _$Team {
  const factory Team({
    required String id,
    required String name,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @Default(0.0) double rating,
    @JsonKey(name: 'total_orders') @Default(0) int totalOrders,
    @Default([]) List<TeamMember> members,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    @JsonKey(name: 'current_lat') double? currentLat,
    @JsonKey(name: 'current_lng') double? currentLng,
    required DateTime createdAt,
  }) = _Team;
  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}

@freezed
class TeamMember with _$TeamMember {
  const factory TeamMember({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'team_id') required String teamId,
    required String name,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default('member') String role, // leader, member
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    DateTime? joinedAt,
  }) = _TeamMember;
  factory TeamMember.fromJson(Map<String, dynamic> json) => _$TeamMemberFromJson(json);
}
```

### 1.5. Product (Market)
```dart
@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    List<String>? images,
    String? category,
    required double price,
    @JsonKey(name: 'compare_price') double? comparePrice,
    required int stock,
    @Default(0.0) double rating,
    @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Product;
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
```

### 1.6. Wallet / Transaction
```dart
enum TransactionType { credit, debit }

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required String id,
    @JsonKey(name: 'tenant_id') String? tenantId,
    @JsonKey(name: 'user_id') String? userId,
    @Default(0.0) double balance,
    @JsonKey(name: 'pending_balance') @Default(0.0) double pendingBalance,
    @Default([]) List<Transaction> transactions,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Wallet;
  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    @JsonKey(name: 'wallet_id') required String walletId,
    required double amount,
    required String description,
    required TransactionType type,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'reference_type') String? referenceType, // commission, payout, refund
    required DateTime createdAt,
  }) = _Transaction;
  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}
```

### 1.7. Review (3 aspect)
```dart
@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'customer_name') required String customerName,
    @Default(0) int quality,       // 1-5
    @Default(0) int punctuality,   // 1-5
    @Default(0) int communication,  // 1-5
    String? comment,
    required DateTime createdAt,
  }) = _Review {
    double get averageRating => (quality + punctuality + communication) / 3;
  }
  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
```

### 1.8. Address
```dart
@freezed
class Address with _$Address {
  const factory Address({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String label, // Uy, Ish, Boshqa
    required String address,
    String? floor,
    String? apartment,
    String? entrance,
    @JsonKey(name: 'intercom_code') String? intercomCode,
    String? comment,
    double? lat,
    double? lng,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    required DateTime createdAt,
  }) = _Address;
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}
```

### 1.9. Tenant
```dart
enum TenantStatus { active, suspended, pending }

@freezed
class Tenant with _$Tenant {
  const factory Tenant({
    required String id,
    required String name,
    String? phone,
    String? email,
    String? city,
    String? address,
    @JsonKey(name: 'contact_person') String? contactPerson,
    @JsonKey(name: 'contract_number') String? contractNumber,
    required TenantStatus status,
    @JsonKey(name: 'suspended_reason') String? suspendedReason,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Tenant;
  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
}
```

### 1.10. CommissionRule
```dart
@freezed
class CommissionRule with _$CommissionRule {
  const factory CommissionRule({
    required String id,
    @JsonKey(name: 'service_id') String? serviceId, // NULL = barcha xizmatlar uchun default
    @JsonKey(name: 'service_name') String? serviceName,
    @JsonKey(name: 'commission_percent') required double commissionPercent, // masalan 15.0 = 15%
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CommissionRule;
  factory CommissionRule.fromJson(Map<String, dynamic> json) => _$CommissionRuleFromJson(json);
}
```

### 1.11. AppNotification
```dart
@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required String message,
    String? type, // order_update, payment, promo, system
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _AppNotification;
  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
}
```

### Multi-tenancy talablari
Har bir **tenant-scoped** modelda `tenant_id` majburiy:
- `User` (agar worker yoki tenant_admin bo'lsa)
- `Order`
- `Service` (agar tenant-ga xos bo'lsa; NULL = platforma darajasida)
- `Team` / `TeamMember`
- `Wallet` (tenant firmasi uchun)
- `Transaction`

**Tenantsiz modellar** (platforma darajasida, hamma tenant ko'ra oladi):
- `CommissionRule` — platform-admin boshqaradi
- `Product` — market mahsulotlari umumiy
- `Address` — user'ga tegishli, tenant'ga emas
- `AppNotification` — user'ga tegishli
- `Review` — buyurtmaga tegishli, tenant order orqali aniqlanadi

---

## 2. API Endpoint'lar kerak (B-kishi kutayotgan endpoint'lar)

B-kishi har bir screen'da mana shu endpoint'larga so'rov jo'natadi. Endpoint'lar hali mavjud EMAS.

### Javob formati (barcha endpoint uchun yagona):
```json
{
  "success": true,
  "data": { ... },
  "message": "string (ixtiyoriy)",
  "error": "string (xatolik bo'lsa)"
}
```

**Diqqat:** B-kishi `snake_case` JSON kutadi. Barcha DTO'lar `snake_case` da bo'lishi shart. NestJS `snake_case` interceptor orqali avtomatik konvertatsiya.

**Auth header:** `Authorization: Bearer <token>` — JWT access token.

---

### 2.1. Auth moduli

| Method | Path | Request Body | Response (data) | Izoh |
|---|---|---|---|---|
| POST | `/auth/send-otp` | `{ "phone": "998901234567", "channel": "telegram" }` | `{ "expires_in": 60 }` | Channel: `telegram` (default), `sms`, `flash_call`. OTP 4 xonali. |
| POST | `/auth/verify` | `{ "phone": "998901234567", "code": "1234" }` | `{ "access_token": "jwt...", "refresh_token": "uuid...", "expires_in": 3600, "user": User }` | Agar user yangi bo'lsa `user` null, `is_new_user: true` |
| POST | `/auth/register` | `{ "phone": "998901234567", "name": "Ism", "email?": "..." }` | `{ "access_token": "jwt...", "refresh_token": "uuid...", "user": User }` | |
| GET | `/auth/profile` | — | `User` | JWT'dan user_id olinadi |
| POST | `/auth/refresh` | `{ "refresh_token": "uuid..." }` | `{ "access_token": "jwt...", "refresh_token": "new-uuid...", "expires_in": 3600 }` | Eski refresh_token invalid bo'ladi |
| POST | `/auth/switch-role` | `{ "target_role": "tenant_worker" }` | `{ "access_token": "jwt...(yangi role bilan)" }` | User'da target_role bo'lishi shart, aks holda 403 |
| POST | `/auth/delete-account` | — | `{ }` | GDPR/Shaxsiy ma'lumotlar — o'chirish huquqi. Soft-delete. |
| POST | `/auth/marketing-consent` | `{ "consent": true }` | `{ }` | Marketing roziligini yangilash |

**OTP limit:** 1 daqiqada 3 marta, 1 soatda 10 marta. Rate-limit Redis orqali.

---

### 2.2. Services moduli

| Method | Path | Query Params | Response (data) |
|---|---|---|---|
| GET | `/services` | `?category=deep_cleaning` (ixtiyoriy) | `List<Service>` |
| GET | `/services/:id` | — | `Service` |
| GET | `/services/:id/tariffs` | — | `List<Tariff>` |
| GET | `/services/:id/addons` | — | `List<Addon>` |
| GET | `/services/:id/time-slots` | `?date=2026-07-20` | `List<TimeSlot>` |

**TimeSlot modeli:**
```json
{
  "time": "09:00",
  "available": true
}
```
Time slotlar **30 daqiqalik intervallarda** (09:00, 09:30, 10:00, ...). Ish vaqti: **08:00–22:00**. Har slotda parallel buyurtma limiti bor (tenant'ning aktiv team'lar soniga qarab). Slot band bo'lsa `available: false`.

---

### 2.3. Orders moduli

| Method | Path | Request Body | Response (data) | Izoh |
|---|---|---|---|---|
| POST | `/orders` | `{ "service_id", "tariff_id?", "addon_ids?": [], "address_id", "scheduled_at", "preferred_tenant_id?": null, "note?" }` | `Order (status: searching)` | `preferred_tenant_id` — mijoz firma tanlasa (ixtiyoriy) |
| GET | `/orders/:id` | — | `Order` (address, team, review bilan) | |
| GET | `/orders` | `?status=active&page=1&limit=20` | `{ "orders": List<Order>, "total": int }` | Paginatsiya. `status=active` = `searching,assigned,enRoute,arrived,inProgress` |
| GET | `/orders/:id/tracking` | — | `OrderTracking` | |
| PUT | `/orders/:id/status` | `{ "status": "arrived", "lat?": 41.2995, "lng?": 69.2401 }` | `Order` | Worker status'ni o'zgartiradi. Validatsiya: status machine bo'yicha |
| POST | `/orders/:id/cancel` | `{ "reason": "Vaqt yetmay qoldi", "note?": "..." }` | `Order (status: cancelled)` | Cancel qoidalari: `searching` da sababsiz; `assigned/enRoute/arrived` da sabab majburiy; `inProgress` faqat admin; `completed` mumkin emas |
| POST | `/orders/:id/rate` | `{ "quality": 5, "punctuality": 4, "communication": 5, "comment?": "A'lo" }` | `Review` | FAQAT `completed` statusda. Har aspect 1-5. Bir marta baho beriladi. |

**OrderTracking modeli:**
```json
{
  "order_id": "uuid",
  "status": "enRoute",
  "team": Team,
  "team_lat": 41.2995,
  "team_lng": 69.2401,
  "eta_minutes": 15,
  "timeline": [
    { "status": "searching", "timestamp": "..." },
    { "status": "assigned", "timestamp": "..." },
    { "status": "enRoute", "timestamp": "..." }
  ]
}
```

---

### 2.4. Dispatch moduli (M3)

| Method | Path | Request Body | Response | Izoh |
|---|---|---|---|---|
| POST | `/dispatch/orders/:id/accept` | `{ "team_id": "uuid" }` | `{ "success": true, "order": Order }` | Atomik: `dispatch_queue` lock, g'olibni belgilash |
| POST | `/dispatch/orders/:id/reject` | `{ "team_id": "uuid" }` | `{ "success": true }` | Team rad etishi (15s timeout ichida yoki keyin) |
| GET | `/dispatch/orders/:id/offers` | — | `{ "offers": List<DispatchOffer> }` | Qaysi team'larga taklif yuborilgan |

**DispatchOffer modeli:**
```json
{
  "team_id": "uuid",
  "team_name": "Alpha Team",
  "tenant_id": "uuid",
  "tenant_name": "CleanPro",
  "distance_km": 2.3,
  "rating": 4.8,
  "expires_at": "ISO8601"
}
```

**Dispatch logikasi (A-kishi qurishi kerak):**
1. Order create → status `searching`
2. `findEligibleTeams()` — PostGIS, 5-10 eng yaqin team **barcha aktiv tenantlar bo'ylab** (yoki `preferred_tenant_id` bo'lsa faqat o'sha tenant). `FOR UPDATE SKIP LOCKED` bilan atomik.
3. Tanlangan team'larga `dispatch_queue` ga yozish (`pending` status)
4. WebSocket orqali barcha tanlangan team a'zolariga `order.new_offer` eventi (15s timeout)
5. Birorta team `accept` bosganda → `dispatch_queue` lock, `is_winner: true`, order `assigned`, g'olibga `order.assigned`, qolganlarga `order.cancelled`
6. **Timeout:** 30s ichida hech kim qabul qilmasa → boshqa round'ga o'tish. 3 round → order `cancelled` + "Team topilmadi" sababi
7. **Concurrency e'tibor:** Ikki team bir vaqtda accept bossa — `FOR UPDATE SKIP LOCKED` orqali faqat bittasi yutadi

---

### 2.5. Market moduli

| Method | Path | Request | Response | Izoh |
|---|---|---|---|---|
| GET | `/products` | `?category=cleaning_supplies&page=1&limit=20&sort=price_asc` | `{ "products": List<Product>, "total": int }` | |
| GET | `/products/:id` | — | `Product` | |
| GET | `/cart` | — | `Cart` | |
| POST | `/cart/items` | `{ "product_id", "quantity": 1 }` | `Cart` | |
| PUT | `/cart/items/:id` | `{ "quantity": 3 }` | `Cart` | |
| DELETE | `/cart/items/:id` | — | `Cart` | |
| POST | `/checkout` | `{ "address_id", "payment_method": "payme", "note?" }` | `Order (market)` | Market buyurtmasi — `order_type: market` |

**Cart modeli:**
```json
{
  "id": "uuid",
  "items": [
    { "id": "uuid", "product": Product, "quantity": 2, "subtotal": 50000 }
  ],
  "total": 50000,
  "item_count": 1
}
```

---

### 2.6. Profile moduli

| Method | Path | Request | Response |
|---|---|---|---|
| GET | `/users/addresses` | — | `List<Address>` |
| POST | `/users/addresses` | `Address` (to'liq, `user_id`siz) | `Address` |
| PUT | `/users/addresses/:id` | `Address` (qisman) | `Address` |
| DELETE | `/users/addresses/:id` | — | `{ "success": true }` |
| GET | `/notifications` | `?page=1&limit=30` | `{ "notifications": List<AppNotification>, "unread_count": 5 }` |
| PUT | `/notifications/:id/read` | — | `AppNotification` |
| PUT | `/notifications/read-all` | — | `{ "success": true }` |

---

### 2.7. Worker moduli

| Method | Path | Request Body | Response |
|---|---|---|---|
| PUT | `/workers/availability` | `{ "is_online": true, "lat?": 41.2995, "lng?": 69.2401 }` | `{ "success": true }` |
| GET | `/workers/stats` | `?from=2026-07-01&to=2026-07-31` | `WorkerStats` |
| GET | `/workers/wallet` | — | `Wallet` |
| POST | `/workers/wallet/withdraw` | `{ "amount": 500000, "card_number?": "8600****" }` | `Transaction` |

**WorkerStats modeli:**
```json
{
  "total_orders": 45,
  "completed_orders": 42,
  "cancelled_orders": 3,
  "total_earnings": 4500000,
  "average_rating": 4.7,
  "rating_breakdown": { "quality": 4.8, "punctuality": 4.6, "communication": 4.7 },
  "period": { "from": "2026-07-01", "to": "2026-07-31" }
}
```

---

### 2.8. Tenant Admin moduli

| Method | Path | Request | Response | Izoh |
|---|---|---|---|---|
| GET | `/tenant/workers` | `?page=1&limit=20` | `{ "workers": List<User>, "total": int }` | Faqat o'z tenant'ining worker'lari |
| POST | `/tenant/workers` | `{ "phone", "name", "team_id?" }` | `User` | Yangi worker qo'shish yoki mavjud user'ni worker role'ga o'tkazish |
| PUT | `/tenant/workers/:id` | `{ "name?", "team_id?", "is_active?" }` | `User` | |
| GET | `/tenant/orders` | `?status=active&page=1&limit=20` | `{ "orders": List<Order>, "total": int }` | |
| GET | `/tenant/reviews` | `?page=1&limit=20` | `{ "reviews": List<Review>, "average": 4.5 }` | |

---

### 2.9. Platform Admin moduli

| Method | Path | Request | Response | Izoh |
|---|---|---|---|---|
| GET | `/platform/tenants` | `?status=active&page=1&limit=20` | `{ "tenants": List<Tenant>, "total": int }` | |
| POST | `/platform/tenants` | `{ "name", "phone", "email?", "city", "address?", "contact_person", "contract_number" }` | `Tenant` | Yangi tenant yaratish (QO'LDA — sales-led onboarding) |
| PUT | `/platform/tenants/:id/status` | `{ "status": "suspended", "reason?": "SLA violation" }` | `Tenant` | |
| GET | `/platform/commissions` | — | `List<CommissionRule>` | |
| PUT | `/platform/commissions/:id` | `{ "commission_percent": 15.0 }` | `CommissionRule` | |
| POST | `/platform/commissions` | `{ "service_id?", "commission_percent" }` | `CommissionRule` | service_id null = default |
| GET | `/platform/orders` | `?tenant_id=&status=&page=1&limit=20` | `{ "orders": List<Order>, "total": int }` | Barcha tenantlar |
| GET | `/platform/payouts` | `?tenant_id=&page=1&limit=20` | `{ "payouts": List<Payout>, "total": int }` | |
| POST | `/platform/payouts` | `{ "tenant_id", "amount", "note?" }` | `Payout` | |
| GET | `/platform/users` | `?role=&phone=&page=1&limit=20` | `{ "users": List<User>, "total": int }` | |
| GET | `/platform/dashboard` | — | `DashboardStats` | |
| GET | `/platform/market/products` | `?page=1&limit=20` | `{ "products": List<Product>, "total": int }` | |
| POST | `/platform/market/products` | Product (full) | `Product` | |
| PUT | `/platform/market/products/:id` | Product (partial) | `Product` | |
| DELETE | `/platform/market/products/:id` | — | `{ "success": true }` | |

**DashboardStats:**
```json
{
  "gmv": 15000000,
  "platform_revenue": 2250000,
  "total_orders": 156,
  "active_orders": 12,
  "total_tenants": 8,
  "total_users": 450,
  "period": { "from": "2026-07-01", "to": "2026-07-31" }
}
```

**Payout modeli:**
```json
{
  "id": "uuid",
  "tenant_id": "uuid",
  "tenant_name": "CleanPro",
  "amount": 5000000,
  "status": "pending", // pending, processing, completed, failed
  "note": "Iyul oyi uchun",
  "created_at": "ISO8601",
  "processed_at": null
}
```

---

### 2.10. Geocoding (ixtiyoriy, lekin kerak bo'ladi)

| Method | Path | Query | Response |
|---|---|---|---|
| GET | `/geo/search` | `?q=Toshkent+Amir+Temur+108` | `List<GeoResult>` |
| GET | `/geo/reverse` | `?lat=41.2995&lng=69.2401` | `GeoResult` |

**GeoResult:**
```json
{
  "address": "Toshkent, Amir Temur ko'chasi, 108",
  "lat": 41.2995,
  "lng": 69.2401
}
```

---

## 3. WebSocket Event'lar (A-kishi socket.io server)

### 3.1. Server → Worker (team) event'lar

| Event | Payload | Trigger |
|---|---|---|
| `order.new_offer` | `{ "order_id", "service_name", "address", "price", "scheduled_at", "deadline_seconds": 15 }` | Dispatch topilgan eligible team'larga yangi buyurtma taklifi |
| `order.assigned` | `{ "order_id", "team_id" }` | Team accept qilganda — FAQAT g'olibga yuboriladi |
| `order.cancelled` | `{ "order_id", "reason": "accepted_by_another" }` | Boshqa team yutganda — qolgan team'larga "band qilindi" |

### 3.2. Server → Customer event'lar

| Event | Payload | Trigger |
|---|---|---|
| `order.status_changed` | `{ "order_id", "status": "enRoute" }` | Order status'i o'zgarganda |
| `order.team_location` | `{ "order_id", "lat": 41.2995, "lng": 69.2401 }` | Har 10 soniyada worker GPS jo'natganda |
| `order.eta_updated` | `{ "order_id", "eta_minutes": 12 }` | ETA qayta hisoblanganda (OSRM yoki simple distance) |
| `order.team_info` | `{ "order_id", "team": Team }` | Team tayinlanganda — team haqida to'liq ma'lumot |

### 3.3. Worker → Server event'lar

| Event | Payload | Izoh |
|---|---|---|
| `worker.online` | `{ "status": "online", "lat?": 41.2995, "lng?": 69.2401, "team_id" }` | Worker online/offline bo'lganda. Online bo'lganda GPS majburiy |
| `worker.location` | `{ "lat": 41.2995, "lng": 69.2401 }` | Har 10 soniyada GPS yangilanish. Faqat `enRoute` va `arrived` statusda jo'natiladi |

### 3.4. Socket.IO Room structure (A-kishi qurishi kerak)

```
/user:<userId>           — user'ning shaxsiy kanali (customer/worker)
/order:<orderId>         — buyurtma bo'yicha hamma event'lar
/team:<teamId>           — team a'zolariga broadcast
/tenant:<tenantId>       — tenant admin'ga broadcast
```

**Socket.IO auth:**
Worker ulanganda `token` query param orqali autentifikatsiya. Invalid token → disconnect.

---

## 4. gloss_core — A-kishi to'ldirishi kerak

B-kishi stub yozgan, lekin real implementatsiya YO'Q:

### 4.1. ApiClient (`gloss_core/lib/src/api_client.dart`)
**Hozir:** Dio bilan GET/POST/PUT/DELETE. Token header'ga qo'shiladi. 401 da tokenni o'chiradi, lekin refresh qilmaydi.

**A-kishi qilishi kerak:**
- [ ] **Auto-refresh token interceptor:** 401 kelsa → `POST /auth/refresh` → yangi token → original so'rovni qayta yuborish. Refresh ham 401 bersa → logout.
- [ ] **Retry logic:** Network xatolikda 3 marta retry (exponential backoff: 1s, 2s, 4s).
- [ ] **Token'ni SecureStorage'da saqlash** va ilova ochilganda avtomatik o'qish.
- [ ] **Base URL ni env'dan olish** (`GLOSS_API_URL` environment variable yoki `--dart-define`).
- [ ] **Timeoutlar:** connect 10s, receive 30s.

### 4.2. SocketClient (`gloss_core/lib/src/socket_client.dart`)
**Hozir:** Stub. Faqat `connect/disconnect/on/emit/off` metod signaturalari mavjud.

**A-kishi qilishi kerak:**
- [ ] **`socket_io_client` yoki `socket_io_client_flutter`** paketini integratsiya qilish.
- [ ] **Auto-reconnect:** ulanish uzilganda 5 martagacha qayta ulanish (backoff: 1s, 2s, 4s, 8s, 16s).
- [ ] **Token bilan autentifikatsiya:** `io('url', Options(query: {'token': jwt}))`.
- [ ] **Online/offline state tracking:** `isConnected` stream orqali kuzatiladi.
- [ ] **Order lifecycle event'larini tinglash:**
  - Customer: `order.status_changed`, `order.team_location`, `order.eta_updated`, `order.team_info`
  - Worker: `order.new_offer`, `order.assigned`, `order.cancelled`
- [ ] **Worker GPS stream:** `worker.location` event'ini har 10s jo'natish (`enRoute`/`arrived` statusda).
- [ ] **Worker online/offline:** `worker.online` event'i.

### 4.3. SecureStorage (`gloss_core/lib/src/secure_storage.dart`)
**Hozir:** Stub. Metod signaturalari mavjud, body bo'sh.

**A-kishi qilishi kerak:**
- [ ] **`flutter_secure_storage`** paketini integratsiya qilish.
- [ ] Saqlanadigan kalitlar:
  - `access_token` — JWT
  - `refresh_token` — UUID
  - `user_id` — tez o'qish uchun
  - `current_role` — `customer` / `tenant_worker` / `courier`

---

## 5. Bekend arxitektura (M0-M1 poydevor)

### 5.1. Texnologiyalar
- **NestJS** (TypeScript) — modulli monolit. 17+ modul.
- **Prisma** — ORM + migratsiya. Schema `backend/prisma/schema.prisma` da.
- **PostgreSQL + PostGIS** — asosiy DB. Geo-query'lar dispatch uchun.
- **Redis** — cache, OTP saqlash (60s TTL), dispatch queue lock, timeout job'lar.
- **BullMQ** — job queue (order timeout, notification, komissiya hisoblash).
- **Socket.IO** — WebSocket server (NestJS `@nestjs/websockets` adapter).
- **JWT** — access (1 soat) + refresh (30 kun). `@nestjs/jwt`.
- **snake_case interceptor** — NestJS global interceptor. Barcha response JSON avtomatik `snake_case` ga o'tadi. Request ham `snake_case` da keladi, NestJS pipe orqali `camelCase` ga aylantiriladi.

### 5.2. Modullar ro'yxati
```
backend/src/
├── main.ts
├── app.module.ts
├── common/             — interceptors, guards, decorators, filters, pipes
├── prisma/             — PrismaModule, PrismaService
├── auth/               — JWT, refresh, OTP, register, switch-role
├── users/              — User CRUD, addresses
├── tenants/            — Tenant CRUD (faqat platform_admin)
├── services/           — Service/Tariff/Addon CRUD, time-slots
├── orders/             — Order CRUD, status machine, cancel, rate
├── dispatch/           — findEligibleTeams, accept/reject, queue
├── teams/              — Team/TeamMember CRUD
├── workers/            — Availability, stats, wallet
├── products/           — Market product CRUD
├── cart/               — Cart/Checkout
├── reviews/            — Review CRUD (read-only for most)
├── commissions/        — CommissionRule CRUD, hisoblash
├── wallets/            — Wallet, Transaction, withdraw
├── payouts/            — Payout CRUD (platform → tenant)
├── notifications/      — Notification CRUD, push (FCM)
├── geo/                — Geocoding search/reverse (Nominatim yoki Yandex Geocoder)
├── websocket/          — Socket.IO gateway, rooms, auth
└── health/             — HealthCheck (Terminus)
```

### 5.3. Multi-tenancy — Prisma middleware + RLS
**Shared DB + tenant_id.** Prisma middleware har query'ga avtomatik `WHERE tenant_id = ?` qo'shadi:
```typescript
// Prisma tenant-scope middleware
prisma.$use(async (params, next) => {
  if (TENANT_SCOPED_MODELS.includes(params.model)) {
    const tenantId = getCurrentTenantId(); // request context'dan
    if (tenantId) {
      params.args.where = {
        ...params.args.where,
        tenant_id: tenantId,
      };
    }
  }
  return next(params);
});
```

**Row-Level Security (PostgreSQL):**
```sql
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON orders
  USING (tenant_id = current_setting('app.current_tenant_id')::uuid);
```

**Tenant-scoped modellar:** `users`, `orders`, `teams`, `team_members`, `services` (agar tenant-ga xos bo'lsa), `wallets`.

**Global modellar (tenantsiz):** `tenants`, `commission_rules`, `products`, `payouts`.

### 5.4. RBAC
```typescript
enum Role {
  PLATFORM_ADMIN = 'platform_admin',   // hamma narsani ko'radi
  TENANT_ADMIN = 'tenant_admin',       // faqat o'z tenant'ini
  TENANT_WORKER = 'tenant_worker',     // faqat o'ziga tegishli order'lar
  CUSTOMER = 'customer',               // faqat o'z order'lari
  COURIER = 'courier',                 // delivery order'lari
}
```

NestJS guard:
```typescript
@Roles(Role.TENANT_ADMIN)
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('tenant')
```

`platform_admin` hamma narsaga ruxsat. `tenant_admin` faqat o'z `tenant_id` bo'yicha. `customer` faqat o'z `user_id` bo'yicha.

---

## 6. Ma'lumotlar bazasi sxemasi (Prisma)

### 6.1. `tenants`
```prisma
model Tenant {
  id              String   @id @default(uuid()) @db.Uuid
  name            String
  phone           String?
  email           String?
  city            String?
  address         String?
  contactPerson   String?  @map("contact_person")
  contractNumber  String?  @map("contract_number")
  status          String   @default("pending") // active, suspended, pending
  suspendedReason String?  @map("suspended_reason")
  createdAt       DateTime @default(now()) @map("created_at")
  updatedAt       DateTime @updatedAt @map("updated_at")

  users  User[]
  teams  Team[]
  orders Order[]
  wallet Wallet?

  @@map("tenants")
}
```

### 6.2. `users`
```prisma
model User {
  id                String   @id @default(uuid()) @db.Uuid
  phone             String   @unique
  name              String
  email             String?
  avatarUrl         String?  @map("avatar_url")
  marketingConsent  Boolean  @default(false) @map("marketing_consent")
  tenantId          String?  @map("tenant_id") @db.Uuid
  refreshToken      String?  @map("refresh_token")
  deviceToken       String?  @map("device_token")
  isDeleted         Boolean  @default(false) @map("is_deleted")
  createdAt         DateTime @default(now()) @map("created_at")
  updatedAt         DateTime @updatedAt @map("updated_at")

  tenant        Tenant?       @relation(fields: [tenantId], references: [id])
  roles         UserRole[]
  addresses     Address[]
  orders        Order[]
  reviews       Review[]
  notifications Notification[]
  cartItems     CartItem[]
  teamMembers   TeamMember[]
  wallet        Wallet?

  @@map("users")
}

model UserRole {
  id     String @id @default(uuid()) @db.Uuid
  userId String @map("user_id") @db.Uuid
  role   String // platform_admin, tenant_admin, tenant_worker, customer, courier

  user User @relation(fields: [userId], references: [id])

  @@unique([userId, role])
  @@map("user_roles")
}
```

### 6.3. `services`, `tariffs`, `addons`
```prisma
model Service {
  id          String   @id @default(uuid()) @db.Uuid
  name        String
  description String?
  iconUrl     String?  @map("icon_url")
  category    String?  // deep_cleaning, regular_cleaning, laundry, etc.
  basePrice   Decimal  @map("base_price")
  priceUnit   String   @default("hour") @map("price_unit") // hour, sqm, fixed
  isActive    Boolean  @default(true) @map("is_active")
  tenantId    String?  @map("tenant_id") @db.Uuid
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")

  tenant  Tenant?   @relation(fields: [tenantId], references: [id])
  tariffs Tariff[]
  addons  Addon[]
  orders  Order[]

  @@map("services")
}

model Tariff {
  id              String   @id @default(uuid()) @db.Uuid
  serviceId       String   @map("service_id") @db.Uuid
  name            String
  price           Decimal
  durationMinutes Int?     @map("duration_minutes")
  description     String?
  isDefault       Boolean  @default(false) @map("is_default")
  createdAt       DateTime @default(now()) @map("created_at")

  service Service @relation(fields: [serviceId], references: [id])

  @@map("tariffs")
}

model Addon {
  id          String   @id @default(uuid()) @db.Uuid
  serviceId   String   @map("service_id") @db.Uuid
  name        String
  price       Decimal
  description String?
  createdAt   DateTime @default(now()) @map("created_at")

  service Service @relation(fields: [serviceId], references: [id])

  @@map("addons")
}
```

### 6.4. `orders` (status machine)
```prisma
model Order {
  id               String    @id @default(uuid()) @db.Uuid
  serviceId        String    @map("service_id") @db.Uuid
  tariffId         String?   @map("tariff_id") @db.Uuid
  customerId       String    @map("customer_id") @db.Uuid
  teamId           String?   @map("team_id") @db.Uuid
  tenantId         String?   @map("tenant_id") @db.Uuid
  addressId        String    @map("address_id") @db.Uuid
  status           String    @default("searching") // OrderStatus enum
  orderType        String    @default("service") @map("order_type") // service, market
  totalAmount      Decimal   @map("total_amount")
  commissionAmount Decimal?  @map("commission_amount")
  commissionRate   Decimal?  @map("commission_rate") // masalan 15.00
  scheduledAt      DateTime? @map("scheduled_at")
  cancelledAt      DateTime? @map("cancelled_at")
  cancelReason     String?   @map("cancel_reason")
  cancelNote       String?   @map("cancel_note")
  note             String?
  etaMinutes       Int?      @map("eta_minutes")
  createdAt        DateTime  @default(now()) @map("created_at")
  updatedAt        DateTime  @updatedAt @map("updated_at")
  completedAt      DateTime? @map("completed_at")

  service  Service        @relation(fields: [serviceId], references: [id])
  customer User           @relation(fields: [customerId], references: [id])
  team     Team?          @relation(fields: [teamId], references: [id])
  tenant   Tenant?        @relation(fields: [tenantId], references: [id])
  address  Address        @relation(fields: [addressId], references: [id])
  review   Review?
  addons   OrderAddon[]

  @@index([status])
  @@index([customerId])
  @@index([teamId])
  @@index([tenantId])
  @@index([createdAt])
  @@map("orders")
}

model OrderAddon {
  id      String @id @default(uuid()) @db.Uuid
  orderId String @map("order_id") @db.Uuid
  addonId String @map("addon_id") @db.Uuid

  order Order @relation(fields: [orderId], references: [id])
  addon Addon @relation(fields: [addonId], references: [id])

  @@map("order_addons")
}
```

### 6.5. `teams`, `team_members`
```prisma
model Team {
  id         String   @id @default(uuid()) @db.Uuid
  name       String
  tenantId   String   @map("tenant_id") @db.Uuid
  rating     Float    @default(0)
  totalOrders Int     @default(0) @map("total_orders")
  isActive   Boolean  @default(true) @map("is_active")
  isOnline   Boolean  @default(false) @map("is_online")
  currentLat Float?   @map("current_lat")
  currentLng Float?   @map("current_lng")
  location   Unsupported("geometry(Point, 4326)")? // PostGIS
  createdAt  DateTime @default(now()) @map("created_at")

  tenant  Tenant       @relation(fields: [tenantId], references: [id])
  members TeamMember[]
  orders  Order[]

  @@map("teams")
}

model TeamMember {
  id       String   @id @default(uuid()) @db.Uuid
  userId   String   @map("user_id") @db.Uuid
  teamId   String   @map("team_id") @db.Uuid
  role     String   @default("member") // leader, member
  isOnline Boolean  @default(false) @map("is_online")
  joinedAt DateTime @default(now()) @map("joined_at")

  user User @relation(fields: [userId], references: [id])
  team Team @relation(fields: [teamId], references: [id])

  @@unique([userId, teamId])
  @@map("team_members")
}
```

### 6.6. `commission_rules`
```prisma
model CommissionRule {
  id                String   @id @default(uuid()) @db.Uuid
  serviceId         String?  @map("service_id") @db.Uuid // NULL = default barcha xizmatlar uchun
  commissionPercent Decimal  @map("commission_percent") // masalan 15.00
  isActive          Boolean  @default(true) @map("is_active")
  createdAt         DateTime @default(now()) @map("created_at")
  updatedAt         DateTime @updatedAt @map("updated_at")

  @@map("commission_rules")
}
```

### 6.7. `wallets`, `transactions`
```prisma
model Wallet {
  id             String   @id @default(uuid()) @db.Uuid
  tenantId       String?  @map("tenant_id") @db.Uuid @unique
  userId         String?  @map("user_id") @db.Uuid @unique
  balance        Decimal  @default(0)
  pendingBalance Decimal  @default(0) @map("pending_balance")
  createdAt      DateTime @default(now()) @map("created_at")
  updatedAt      DateTime @updatedAt @map("updated_at")

  tenant       Tenant?       @relation(fields: [tenantId], references: [id])
  user         User?         @relation(fields: [userId], references: [id])
  transactions Transaction[]

  @@map("wallets")
}

model Transaction {
  id            String   @id @default(uuid()) @db.Uuid
  walletId      String   @map("wallet_id") @db.Uuid
  amount        Decimal
  description   String
  type          String   // credit, debit
  orderId       String?  @map("order_id") @db.Uuid
  referenceType String?  @map("reference_type") // commission, payout, withdraw, refund
  createdAt     DateTime @default(now()) @map("created_at")

  wallet Wallet @relation(fields: [walletId], references: [id])

  @@map("transactions")
}
```

### 6.8. `reviews`
```prisma
model Review {
  id            String   @id @default(uuid()) @db.Uuid
  orderId       String   @unique @map("order_id") @db.Uuid
  customerId    String   @map("customer_id") @db.Uuid
  quality       Int      // 1-5
  punctuality   Int      // 1-5
  communication Int      // 1-5
  comment       String?
  createdAt     DateTime @default(now()) @map("created_at")

  order    Order @relation(fields: [orderId], references: [id])
  customer User  @relation(fields: [customerId], references: [id])

  @@map("reviews")
}
```

### 6.9. `products`
```prisma
model Product {
  id           String   @id @default(uuid()) @db.Uuid
  name         String
  description  String?
  imageUrl     String?  @map("image_url")
  images       Json?    // String[]
  category     String?
  price        Decimal
  comparePrice Decimal? @map("compare_price")
  stock        Int      @default(0)
  rating       Float    @default(0)
  reviewCount  Int      @default(0) @map("review_count")
  isActive     Boolean  @default(true) @map("is_active")
  createdAt    DateTime @default(now()) @map("created_at")
  updatedAt    DateTime @updatedAt @map("updated_at")

  cartItems CartItem[]

  @@map("products")
}
```

### 6.10. `addresses`
```prisma
model Address {
  id           String   @id @default(uuid()) @db.Uuid
  userId       String   @map("user_id") @db.Uuid
  label        String   @default("Boshqa") // Uy, Ish, Boshqa
  address      String
  floor        String?
  apartment    String?
  entrance     String?
  intercomCode String?  @map("intercom_code")
  comment      String?
  lat          Float?
  lng          Float?
  isDefault    Boolean  @default(false) @map("is_default")
  createdAt    DateTime @default(now()) @map("created_at")

  user   User    @relation(fields: [userId], references: [id])
  orders Order[]

  @@map("addresses")
}
```

### 6.11. `notifications`
```prisma
model Notification {
  id        String   @id @default(uuid()) @db.Uuid
  userId    String   @map("user_id") @db.Uuid
  title     String
  message   String
  type      String?  // order_update, payment, promo, system
  orderId   String?  @map("order_id") @db.Uuid
  isRead    Boolean  @default(false) @map("is_read")
  createdAt DateTime @default(now()) @map("created_at")

  user User @relation(fields: [userId], references: [id])

  @@map("notifications")
}
```

### 6.12. `dispatch_queue` (ichki, REST emas)
```prisma
model DispatchQueue {
  id        String   @id @default(uuid()) @db.Uuid
  orderId   String   @map("order_id") @db.Uuid
  teamId    String   @map("team_id") @db.Uuid
  status    String   @default("pending") // pending, accepted, rejected, expired
  isWinner  Boolean  @default(false) @map("is_winner")
  round     Int      @default(1)
  expiresAt DateTime @map("expires_at")
  createdAt DateTime @default(now()) @map("created_at")

  @@index([orderId, status])
  @@map("dispatch_queue")
}
```

### 6.13. `payouts`
```prisma
model Payout {
  id          String    @id @default(uuid()) @db.Uuid
  tenantId    String    @map("tenant_id") @db.Uuid
  amount      Decimal
  status      String    @default("pending") // pending, processing, completed, failed
  note        String?
  createdAt   DateTime  @default(now()) @map("created_at")
  processedAt DateTime? @map("processed_at")

  tenant Tenant @relation(fields: [tenantId], references: [id])

  @@map("payouts")
}
```

### 6.14. `carts`, `cart_items`
```prisma
model Cart {
  id     String     @id @default(uuid()) @db.Uuid
  userId String     @unique @map("user_id") @db.Uuid
  items  CartItem[]

  @@map("carts")
}

model CartItem {
  id        String @id @default(uuid()) @db.Uuid
  cartId    String @map("cart_id") @db.Uuid
  productId String @map("product_id") @db.Uuid
  quantity  Int    @default(1)

  cart    Cart    @relation(fields: [cartId], references: [id])
  product Product @relation(fields: [productId], references: [id])

  @@unique([cartId, productId])
  @@map("cart_items")
}
```

---

## 7. API Contract

### 7.1. JSON formati
B-kishi `snake_case` da yozilgan JSON'ni kutadi. NestJS da buning uchun:

```typescript
// main.ts da global interceptor
app.useGlobalInterceptors(new SnakeCaseInterceptor());
```

Response misol:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "total_amount": 150000,
    "commission_amount": 22500,
    "created_at": "2026-07-16T10:30:00.000Z"
  },
  "message": "Buyurtma qabul qilindi"
}
```

Error misol:
```json
{
  "success": false,
  "data": null,
  "error": "Bu status'dan keyingi status'ga o'tib bo'lmaydi"
}
```

### 7.2. HTTP status kodlari
| Status | Holat |
|---|---|
| 200 | Muvaffaqiyatli |
| 201 | Yaratildi |
| 400 | Validatsiya xatosi |
| 401 | Token muddati o'tgan yoki yo'q |
| 403 | Ruxsat yo'q (RBAC) |
| 404 | Topilmadi |
| 409 | Konflikt (masalan ikki team bir vaqtda accept) |
| 422 | Business-logika xatosi (masalan status machine validatsiyasi) |
| 429 | Rate limit |
| 500 | Server xatosi |

### 7.3. Paginatsiya
Barcha list endpoint'lar yagona formatda:
```json
{
  "success": true,
  "data": {
    "items": [...],
    "total": 156,
    "page": 1,
    "limit": 20,
    "total_pages": 8
  }
}
```

Query parametrlar: `?page=1&limit=20`. Default: `page=1, limit=20`. Max limit: `100`.

### 7.4. DTO ↔ Model 1:1
Har bir Prisma model'ga mos NestJS DTO bo'lishi kerak. `class-transformer` + `class-validator` orqali:

```typescript
export class CreateOrderDto {
  @IsUUID()
  service_id: string;

  @IsUUID()
  address_id: string;

  @IsOptional()
  @IsUUID()
  tariff_id?: string;

  @IsOptional()
  @IsArray()
  @IsUUID('4', { each: true })
  addon_ids?: string[];

  @IsISO8601()
  scheduled_at: string;

  @IsOptional()
  @IsUUID()
  preferred_tenant_id?: string;

  @IsOptional()
  @IsString()
  note?: string;
}
```

B-kishi frontend'da `@JsonKey(name: 'service_id')` orqali aynan shu DTO field nomlariga mos keladi. Field nomlari o'zgarsa, contract buziladi.

---

## 8. A-kishi M0 bosqichida nima qilishi kerak

_B-kishi M0 da frontend packages va app'larning skeleton strukturasini qurdi. Endi A-kishi backend poydevorini qurishi kerak._

### 8.1. `docker-compose.yml` ishga tushirish
```yaml
version: '3.8'
services:
  postgres:
    image: postgis/postgis:16-3.4
    environment:
      POSTGRES_USER: gloss
      POSTGRES_PASSWORD: gloss_dev
      POSTGRES_DB: gloss_dev
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  pgdata:
```

### 8.2. NestJS skeleton yaratish
```bash
cd backend/
npx @nestjs/cli new . --package-manager pnpm --skip-git
```
Modullar: `app`, `prisma`, `auth`, `users`, `tenants`, `services`, `orders`, `dispatch`, `teams`, `workers`, `products`, `cart`, `reviews`, `commissions`, `wallets`, `payouts`, `notifications`, `geo`, `websocket`, `health`.

### 8.3. Prisma schema + migratsiya
`backend/prisma/schema.prisma` — yuqoridagi 14 model. Barcha `tenant_id` lar to'g'ri reference bilan. `PostGIS` geometry type dispatch uchun.

```bash
npx prisma migrate dev --name initial
```

### 8.4. Multi-tenancy + RBAC implementatsiya
- **TenantScopeMiddleware** — har request'da JWT'ga qarab `current_tenant_id` aniqlash va Prisma query'ga qo'shish.
- **JwtAuthGuard** — `@nestjs/passport` + `passport-jwt`.
- **RolesGuard** — `@Roles(Role.TENANT_ADMIN)` decorator.

### 8.5. gloss_models freezed bilan to'ldirish
B-kishi stub'larini freezed ga o'tkazish. Har modelda `@JsonKey(name: 'field_name')` orqali `snake_case` mapping. `packages/gloss_models/pubspec.yaml` ga `freezed_annotation`, `json_annotation` qo'shish.

### 8.6. gloss_core real qilish
- `ApiClient` — auto-refresh interceptor, retry, SecureStorage bilan bog'lash.
- `SocketClient` — `socket_io_client` integratsiyasi, event handler'lar, auto-reconnect.
- `SecureStorage` — `flutter_secure_storage` integratsiyasi.

### 8.7. CI/CD setup
GitHub Actions:
- Backend: `pnpm test`, `pnpm lint` (ESLint), `npx prisma generate`
- Flutter: `melos analyze`, `melos test`
- Admin: `pnpm lint`, `pnpm build`

---

## 9. Eslatmalar (B-kishi uchun muhim deb topgan narsalar)

### 9.1. Dispatch concurrency — eng murakkab qism
```sql
-- Race condition oldini olish uchun:
SELECT * FROM dispatch_queue
WHERE order_id = $1 AND status = 'pending'
ORDER BY created_at
LIMIT 1
FOR UPDATE SKIP LOCKED;
```
Bu query **atomik** — bir vaqtda ikkita team accept bossa, faqat bittasi lock qila oladi. PostgreSQL `SERIALIZABLE` transaction isolation bilan ishlash tavsiya qilinadi.

### 9.2. Komissiya hisoblash
Buyurtma `completed` bo'lganda:
```
commission_amount = order.total_amount × (commission_percent / 100)
tenant_netto = order.total_amount - commission_amount
```
`commission_rules` jadvalidan xizmat turiga mos % olinadi (xizmat bo'yicha topilmasa, `service_id IS NULL` bo'lgan default rule). Keyin:
1. `tenant.wallet` ga `credit` tranzaksiya (netto)
2. Platforma daromadi yoziladi (alohida jadval yoki log)

### 9.3. ETA hisoblash
Worker `enRoute` statusga o'tganda:
```typescript
const distance = haversine(teamLocation, orderLocation); // yoki OSRM API
const eta = Math.ceil(distance / avgSpeed * 60); // daqiqada
```
Har 10 soniyada worker location yangilanganda qayta hisoblanadi.

### 9.4. OTP kanallari — multi-channel
`send-otp` da `channel` parametri:
- `telegram` — Telegram Gateway orqali (default, arzon)
- `sms` — Eskiz / Play Mobile orqali (qimmat, lekin ishonchli)
- `flash_call` — oxirgi 4 raqam bilan (eng arzon, lekin iPhone'da muammo bo'lishi mumkin)

Foydalanuvchi "Boshqa usul" tugmasi orqali kanal almashtira oladi.

### 9.5. Huquqiy moslik (O'zbekiston)
- **Lokalizatsiya:** Serverlar O'zbekiston hududida bo'lishi shart (UZINFOCOM / UZCLOUD). Chet el cloud (AWS/GCP chet region) mumkin emas.
- **Marketing roziligi:** `marketing_consent` maydoni. 18:00–09:00 marketing SMS taqiq.
- **To'lov:** Platforma pulni o'zi ushlamasligi kerak (to'lov tashkiloti litsenziyasi kerak bo'ladi). To'lov Payme/Click orqali, platforma faqat hisob-kitob ko'rsatkichi sifatida wallet yuritadi.
- **PINFL/Passport:** Shifrlangan saqlash, blind-index.

### 9.6. B-kishi kutayotgan narsalar (ish tartibi)
1. **Birinchi:** `gloss_models` freezed — B-kishi barcha ekranlarni shu modellarga bog'lagan
2. **Ikkinchi:** `POST /auth/send-otp` + `POST /auth/verify` — autentifikatsiya ishlasa, hamma screen ishlaydi
3. **Uchinchi:** `GET /services` + `GET /services/:id` — xizmatlar katalogi
4. **To'rtinchi:** `POST /orders` — booking flow

B-kishi har bir endpoint tayyor bo'lishi bilan integratsiya qila oladi. Endpoint'lar ketma-ket emas — parallel qurish mumkin.

---

## 10. Status kuzatuvi

| # | Vazifa | Holat | Eslatma |
|---|---|---|---|
| 1 | docker-compose (PostGIS + Redis) | ❌ qurilmagan | |
| 2 | NestJS skeleton | ❌ qurilmagan | |
| 3 | Prisma schema + migratsiya | ❌ qurilmagan | |
| 4 | Tenant middleware + RLS | ❌ qurilmagan | |
| 5 | RBAC (JWT + RolesGuard) | ❌ qurilmagan | |
| 6 | gloss_models freezed | ❌ qurilmagan | B-kishi stub yozgan |
| 7 | gloss_core auto-refresh | ❌ qurilmagan | B-kishi stub yozgan |
| 8 | gloss_core SocketClient real | ❌ qurilmagan | B-kishi stub yozgan |
| 9 | gloss_core SecureStorage real | ❌ qurilmagan | B-kishi stub yozgan |
| 10 | Auth endpoint'lari (6 ta) | ❌ qurilmagan | |
| 11 | Services endpoint'lari (5 ta) | ❌ qurilmagan | |
| 12 | Orders endpoint'lari (6 ta) | ❌ qurilmagan | |
| 13 | Dispatch moduli (M3) | ❌ qurilmagan | |
| 14 | Market endpoint'lari (8 ta) | ❌ qurilmagan | |
| 15 | Profile endpoint'lari (5 ta) | ❌ qurilmagan | |
| 16 | Worker endpoint'lari (3 ta) | ❌ qurilmagan | |
| 17 | Tenant Admin endpoint'lari (4 ta) | ❌ qurilmagan | |
| 18 | Platform Admin endpoint'lari (11 ta) | ❌ qurilmagan | |
| 19 | WebSocket server (Socket.IO) | ❌ qurilmagan | |
| 20 | CI/CD (GitHub Actions) | ❌ qurilmagan | |
| 21 | snake_case interceptor | ❌ qurilmagan | |

---

*Ushbu hujjat B-kishi (frontend) tomonidan 2026-07-16 holatiga ko'ra tuzildi. Savollar bo'lsa — muloqot qilamiz.*
