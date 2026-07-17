# Gloss — To'liq Qurish Rejasi (0 dan)

> **Gloss** — Yandex Go "Уборка" uslubidagi **multi-tenant B2B2C platforma**: tozalash xizmatlari (team dispatch bilan) + mahsulot marketi. O'zbekiston bo'yicha boshqa cleaning firmalar ro'yxatdan o'tib, shartnoma asosida platformadan foydalanadi; platforma har buyurtmadan komissiya oladi. Real-time tracking, RBAC, WebSocket.
>
> Jamoa: **2 kishi + AI**. Monorepo. Taqsimot: **paket bo'yicha**.

---

## 0. Biznes Modeli — Multi-Tenant Platforma

**Model:** Cleaning xizmatlari uchun "Yandex Go fleet" usuli. Bir nechta mustaqil firma (tenant) bitta platforma ostida ishlaydi.

```
Platforma (BIZ) — super-admin
    │ komissiya oladi (xizmat turiga qarab %)
    ├── Tenant A (cleaning firma) — o'z admin paneli, o'z ishchilari
    ├── Tenant B (cleaning firma) — o'z admin paneli, o'z ishchilari
    └── Tenant C ...
         ▲
         │ buyurtma (gibrid dispatch)
Mijozlar (umumiy user app — tenantsiz)
```

### Rollar iyerarxiyasi (RBAC)
```
platform_admin (biz)                 — hamma narsani ko'radi
    └── tenant_admin (firma egasi)   — faqat O'Z firmasini ko'radi
            ├── tenant_dispatcher    — buyurtma taqsimlash (ixtiyoriy)
            └── tenant_worker        — ishchi (worker app)
customer (mijoz)                     — tenantsiz, platformaga tegishli
courier (kuryer)                     — market yetkazish
```

### Tenant onboarding — qo'lda (sales-led)
`firma ariza qoldiradi (nomi, telefon, shahar) → biz qo'ng'iroq qilamiz → shartnoma → platform-admin QO'LDA tenant yaratadi + login beradi → firma ishga tushadi`
KYC/OneID integratsiyasi keyinга qoldiriladi. Yomon ishlagan tenant **suspend** qilinadi (reyting/SLA bo'yicha).

### Dispatch — **Gibrid**
- **Default:** platforma eng yaqin bo'sh teamni tanlaydi (qaysi firmadan bo'lishidan qat'iy nazar — barcha aktiv tenantlar bo'ylab)
- **Ixtiyoriy:** mijoz xohlasa reyting/narx bo'yicha firmani o'zi tanlaydi

### Komissiya + Billing — **xizmat turiga qarab**
- Komissiya % xizmat turi bo'yicha (masalan tozalash 15%, kir yuvish 20%) — `commission_rules` jadvali
- Har buyurtmada avtomatik hisoblanadi → **tenant wallet**ga netto tushadi
- **Payout** — firmaga davriy pul o'tkazish + invoice
- Platforma daromadi = yig'ilgan komissiyalar

### Tenant izolyatsiyasi
- **Shared DB + `tenant_id`** har jadvalda + **Row-Level Security**
- Prisma middleware har query'ni avtomatik `tenant_id` bo'yicha filtrlaydi → ma'lumot sizib chiqmaydi
- `customer`, `market products`, `commission_rules` — platforma darajasida (tenantsiz)

---

## 1. Tech Stack

### Backend
- **NestJS** (TypeScript) — modulli monolit
- **PostgreSQL + PostGIS** — dispatch geo-query uchun majburiy
- **Prisma** — ORM, migratsiya
- **Redis + BullMQ** — queue, cache, OTP, timeout job'lar
- **Socket.IO** — real-time (order status, team location)
- **JWT + refresh** — auth, multi-role (`user_roles`)

### Frontend (mobil)
- **Flutter 3.x** — 3 app: user (mijoz), worker (ishchi), delivery (kuryer)
- **Riverpod** — state management
- **GoRouter** — navigatsiya + role guard
- **Dio + Retrofit** — network (interceptor, retry, auto-refresh)
- **freezed + json_serializable** — immutable modellar
- **Yandex MapKit + OSRM** — xarita, routing

### Admin panel (web) — bitta app, role-based
- **React + Vite + TypeScript**
- **Tailwind + shadcn/ui**
- **TanStack Query**
- 2 ko'rinish: **platform-admin** (biz — barcha tenantlar, komissiya, tasdiqlash) va **tenant-admin** (firma — o'z ishchilari, buyurtmalari, wallet)

### Infra
- 🔴 **Hosting: O'zbekiston data-markazi** (lokalizatsiya qonuni — §11.1) — UZINFOCOM / mahalliy bulut, chet el region emas
- **Docker Compose** (dev), **Kubernetes** (prod)
- **GitHub Actions** (CI/CD)
- **Grafana + Prometheus** (monitoring)
- **Melos** (Flutter monorepo boshqaruvi)

### Integratsiya
- **Payme / Click** — to'lov
- **Firebase Cloud Messaging** — push
- **Auth OTP — multi-channel, tanlanadigan:** Telegram Gateway (default) → SMS (Eskiz/Play Mobile) → Flash-call. Foydalanuvchi kanalni tanlashi mumkin ("boshqa usul")
- **OneID / E-IMZO** — keyinroq (tenant KYC uchun)

---

## 2. Monorepo Strukturasi

```
gloss/
├── apps/
│   ├── gloss_user/            # Mijoz — oddiy foydalanuvchi (umumiy, tenantsiz)
│   ├── gloss_worker/          # Ishchilar — tenant'ga tegishli (MVP fokus)
│   ├── gloss_delivery/        # Kuryerlar — market yetkazish
│   └── gloss_admin/           # React — platform-admin + tenant-admin (role-based)
├── packages/
│   ├── gloss_core/            # ApiClient, auth, socket, storage, retry
│   ├── gloss_design/          # 36 color token + theme + widgetlar
│   ├── gloss_models/          # user, team, order, service, product...
│   └── gloss_routing/         # GoRouter + role guards
├── backend/                   # NestJS (17 modul)
├── docs/                      # FRONTEND / SCREENS / FLOWS / YANDEX_GO_MAPPING
├── docker-compose.yml
└── melos.yaml
```

**Har app ichida** — feature-first:
```
apps/gloss_user/lib/
├── main.dart
├── app.dart
├── core/            # api, storage, config
└── features/
    ├── auth/        # screens/ repositories/ providers/
    ├── home/
    ├── services/    # booking, time_slot, address, order, team_info...
    ├── market/      # product, cart, checkout, favorites
    ├── profile/     # saved_addresses, settings
    └── notifications/
```

---

## 3. Ikki Kishi Taqsimoti (paket bo'yicha)

| | **A-kishi** | **B-kishi** |
|---|---|---|
| Zona | `backend/`, `gloss_core`, `gloss_models` | `apps/*`, `gloss_design`, `gloss_routing` |
| Mas'uliyat | API, DB, dispatch, WebSocket, auth, **tenancy/RBAC, billing/komissiya** | Ekranlar, dizayn, navigatsiya, socket client, **admin panel (React)** |
| Umumiy chegara | **API contract** (`gloss_models` + OpenAPI) — birga kelishiladi |

Fayllar kesishmaydi → merge konflikt yo'q. Yagona sinxron nuqta — `gloss_models`.

### Git strategiyasi (trunk-based)
```
master                    ← himoyalangan, faqat PR orqali
 ├─ feat/<ism>/<feature>  ← qisqa umrli, tez merge
 └─ fix/<ism>/<bug>
```
- `master`: PR majburiy, 1 approval, CI yashil bo'lishi shart
- Har PR ikkinchi kishi tomonidan review
- Commit: Conventional Commits — `feat(backend): ...`, `fix(client): ...`

---

## 4. Bosqichli Yo'l Xaritasi (dependency bo'yicha)

Har bosqich = ishlaydigan, demo qilinadigan natija. Har biri oldingisiga bog'liq.

### M0 — Konsolidatsiya (poydevor)
- Toza monorepo + melos + CI (analyze, test, lint)
- `docker-compose`: Postgres+PostGIS, Redis
- `gloss_design` ko'chirish + widgetlarni to'ldirish (~12 ta)
- `gloss_core` skeleti: ApiClient (auto-refresh), SocketClient, SecureStorage
- Backend skeleti: NestJS + Prisma + healthcheck + snake_case interceptor
- **Gate:** `melos bootstrap` ishlaydi, CI yashil

### M1 — Contract + Tenancy poydevori
- `gloss_models` — barcha modellar (freezed), har biri `tenant_id` bilan
- **Multi-tenancy:** `tenant`, `user_roles`, `commission_rules` sxemasi; Prisma tenant-scope middleware + Row-Level Security
- **RBAC:** platform_admin / tenant_admin / tenant_worker / customer / courier
- Backend DTO ↔ model 1:1, `snake_case`
- WebSocket event shartnomasi hujjatlangan
- **Gate:** contract qotgan, tenant izolyatsiyasi ishlaydi (bir tenant boshqasini ko'rmaydi)

### M2 — Auth + Katalog + Booking (client vertical slices)
- **A:** `auth` (multi-channel OTP: Telegram/SMS/flash-call tanlanadi, verify, register, refresh, device-token, `marketing_consent`), `services` (categories, tariffs, addons, time-slots), `addresses`
- **B:** Splash→Auth→Verify→Register, Home (2 tab), Xizmatlar, Booking (8 qadam), TimeSlot, AddressSearch, SavedAddresses
- **Gate:** xizmat tanlab, real `POST /orders` (status: searching), hech qanday mock yo'q

### M3 — Cross-Tenant Dispatch + Real-time ⭐ (eng murakkab)
- **A:** `dispatch` moduli — `findEligibleTeams` (PostGIS, **barcha aktiv tenantlar bo'ylab** + `FOR UPDATE SKIP LOCKED`), gibrid (auto yoki mijoz tanlagan firma), `dispatch_queue`, 15s/30s timeout, order state machine, WebSocket eventlar
- **B:** `gloss_worker` (online toggle, offer 15s, GPS stream), user OrderScreen (4-bosqich timeline, xarita, team card), TeamInfoScreen
- **Gate:** mijoz buyurtma → istalgan firma teami qabul qiladi → ikki tomonda real-time timeline
- 🔴 **Diqqat:** concurrency (turli firmalarning ikki teami bir vaqtda qabul qilsa) va timeout — insonlar test qiladi

### M4 — Loop yopish + Komissiya (= MVP)
- **A:** cancel (status-based), rate (3 aspect, team rating avg), `reviews`, notifications, **billing:** buyurtma `completed` bo'lganda komissiya (xizmat turiga qarab %) hisoblanadi → tenant wallet
- **B:** CancelReasonScreen, MultiAspectRatingScreen, Notifications, multi-role switch
- **Gate:** to'liq mijoz↔ishchi sikli + komissiya to'g'ri hisoblanadi

### M5 — Tenant Onboarding + Admin panellar
- **Tenant onboarding (qo'lda):** ochiq "Hamkor bo'lish" ariza formasi → biz qo'ng'iroq/shartnoma → **platform-admin panelda qo'lda tenant yaratadi + login beradi** → suspend imkoni
- **Payout/settlement:** tenant wallet → firmaga o'tkazma + invoice
- `gloss_admin` (React): **platform-admin** (tenantlar CRUD, komissiya, daromad) + **tenant-admin** (o'z ishchilari, buyurtmalari, wallet)
- **Gate:** platform-admin yangi firma yaratadi → firma tenant-admin panelга kirib, ishchi qo'shib, buyurtma qabul qila oladi

### M6 — Market + Delivery
- Market flow (products admin CRUD, cart, favorites, checkout)
- `gloss_delivery` app (kuryer), delivery dispatch
- Karta to'lovi (Payme/Click)

**MVP = M0–M5** (multi-tenant xizmat loop'i). Market/delivery — M6.

---

## 5. Dispatch Dizayni (M3 — yadro)

```
Order create (status: searching)
    │ dispatch service triggered
    ▼
1. findEligibleTeams — PostGIS, 5-10 yaqin team, **barcha aktiv tenantlar bo'ylab** (yoki mijoz tanlagan firma) (FOR UPDATE SKIP LOCKED)
2. dispatch_queue ga yozish (status: pending)
3. WebSocket: order.new_offer (15s timeout) → barcha team a'zolariga
    │
    ▼
Team a'zosi "Qabul qilish" bosdi → POST /dispatch/orders/:id/accept
    │
    ▼
Backend (atomik):
  - dispatch_queue lock (FOR UPDATE SKIP LOCKED)
  - status: accepted, is_winner: true
  - order.team_id = teamA.id, order.status: searching → assigned
  - WebSocket: order.assigned (g'olibga)
  - WebSocket: order.cancelled (qolgan teamlarga — "band qilindi")
```

**Timeout:** 30s ichida hech kim qabul qilmasa → boshqa teamlarga. 3 marta timeout → order cancelled + "Team topilmadi".

**Order state machine:**
```
searching → assigned → enRoute → arrived → inProgress → completed → rated
                                                              ↓
                                                          cancelled
```

**`completed` bo'lganda (billing):** komissiya = buyurtma summasi × (xizmat turi %) → platforma daromadi; qolgani (netto) → tenant wallet.

**Cancel validatsiya:**
- `searching`: sabab kerak emas
- `assigned/enRoute/arrived`: sabab kerak
- `inProgress`: faqat admin
- `completed`: mumkin emas

---

### gloss_user — Mijoz (23 ta)
**Auth (4):** Splash, Auth, Verify, Register
**Home (1):** Home (2 tab: Xizmatlar + Market)
**Services (10):** Xizmatlar, Booking (firma tanlash — ixtiyoriy), TimeSlot, AddressSearch, Order (timeline), TeamInfo, CancelReason, MultiAspectRating, OrderHistory, OrderSuccess
**Market (5):** Market, ProductDetail, Cart, Checkout, Favorites
**Profile (2):** Profile, SavedAddresses
**Notifications (1):** Notifications

### gloss_worker — Ishchi (tenant'ga tegishli, ~12 ta)
Splash, Auth, Home (online toggle), Orders (tabs), OrderDetail, SetAvailability, Stats, Profile, Wallet, Support, Notifications, Settings

### gloss_admin (web) — role-based
**platform-admin (biz):** Dashboard (GMV, daromad), Tenantlar (tasdiq/suspend), Komissiya (xizmat turi %), Barcha buyurtmalar, Foydalanuvchilar, Market CRUD, Payout, Sozlamalar
**tenant-admin (firma):** Dashboard, O'z ishchilari (CRUD), O'z buyurtmalari, Wallet/settlement, Reyting/sharhlar, Sozlamalar

---

## 7. Design System (gloss_design)

`gloss_design/lib/src/colors.dart` — **36 semantic token**, ThemeExtension orqali:
```dart
Container(color: context.gloss.green)
Text(style: TextStyle(color: context.gloss.text))
```
Asosiy: `glossGreen #00AA13` (primary), `glossBg #F5F5F5`, `glossText #1A1A1A`.
Barcha 4 app bitta dizayn tilidan foydalanadi.

---

## 8. AI ↔ Inson Mehnat Taqsimoti

| AI qiladi (inson nazorat qiladi) | Inson qiladi (AI qilmaydi) |
|---|---|
| Boilerplate, CRUD, UI ekran kodi | Arxitektura qarorlari (dispatch, state machine) |
| Test yozish, refactor, migratsiya | API contract'ni kelishish (M1) |
| Hujjat, izohlar | Concurrency/race tekshirish (M3) |
| Xato topish/tuzatish takliflari | Har PR review — AI kodini tasdiqlash |

**Tamoyil:** AI — pastdan yuqoriga (kod), inson — yuqoridan pastga (qaror). Har AI yozgan narsa review'dan o'tadi.

---

## 9. WebSocket Event Shartnomasi

| Event | Yo'nalish | Payload |
|---|---|---|
| `order.new_offer` | server → team | orderId, service, address, 15s deadline |
| `order.assigned` | server → g'olib team | orderId, teamId |
| `order.cancelled` | server → qolgan teamlar | orderId |
| `order.status_changed` | server → client | orderId, status |
| `order.team_location` | server → client | orderId, lat, lng (har 10s) |
| `order.eta_updated` | server → client | orderId, eta |

---

## 10. Definition of Done (har bosqich)

- `flutter analyze` = 0 issue
- Backend e2e test o'tadi (per modul)
- Flutter unit test: store/state machine
- CI yashil
- Ikkinchi kishi PR review qildi
- Demo qilinadigan holat (mock yo'q)

---

## 11. Huquqiy Moslik (O'zbekiston)

> ⚠️ Yurist maslahati emas — yo'nalish. Yakuniy tekshiruvni UZ yuristi bilan.

### 1. Shaxsga doir ma'lumotlar — ЎРҚ-547 (eng muhim, arxitekturaga ta'sir)
- 🔴 **Lokalizatsiya:** UZ fuqarolarining shaxsiy ma'lumotlari **O'zbekiston hududidagi serverlarda** saqlanishi va qayta ishlanishi shart → **hosting UZ data-markazida** (UZINFOCOM / mahalliy bulut). Chet el bulut (AWS/GCP chet region) to'g'ridan-to'g'ri mumkin emas
- **Ro'yxat:** shaxsiy ma'lumotlar bazasini **Davlat personalizatsiya markazi** reyestrida ro'yxatdan o'tkazish
- **Rozilik:** har yig'ishda aniq maqsadli rozilik; maqsaddan tashqari ishlatmaslik
- **PINFL / passport** — sensitive: shifrlash (blind-index), minimal saqlash, kirish cheklovi
- **Subject huquqlari:** ko'rish, tuzatish, o'chirish (delete-my-account)

### 2. Reklama — 2026 Prezident qarori
- Marketing SMS/qo'ng'iroq → **yozma/elektron rozilik** (`marketing_consent`) + istalgan payt opt-out
- **18:00–09:00** marketing taqiq
- **OTP — transactional, taqiq tegmaydi**

### 3. To'lov — 🔴 ehtiyot
- Platforma pulni **o'zi ushlab tursa** (wallet/escrow) → to'lov tashkiloti litsenziyasi talab qilinishi mumkin
- **Xavfsiz yo'l:** to'lov Payme/Click orqali, komissiya split ular orqali — platforma pulni to'g'ridan-to'g'ri ushlamaydi. Tenant "wallet" = faqat hisob-kitob ko'rsatkichi

### 4. Soliq + fiskal chek
- Har buyurtmaga fiskal chek (online-kassa / soliqservis)
- Platforma komissiyasi → QQS/soliq hisoboti

### 5. E-tijorat + iste'molchi huquqlari
- Xizmat/mahsulot ma'lumoti, narx, bekor/qaytarish shartlari oshkora
- Shikoyat kanali

### 6. Ishchini qonuniy jalb qilish
- Har ishchi qonuniy rasmiylashtirilgan: **tenant ishga oladi** yoki **yakka tartibdagi tadbirkor / samozanyatost** (soliq.uz)
- Platforma tenantdan ishchilar qonuniyligini **attestatsiya** qilishni talab qiladi (shartnomada)

---

## 12. Provayder (Firma / Ishchi) Topish Strategiyasi

### A. Tenant (cleaning firma) jalb qilish — B2B, sales-led
- **Maqsad:** mavjud cleaning firmalar (Toshkent → viloyatlar)
- **Kanallar:** to'g'ridan-to'g'ri savdo (qo'ng'iroq/uchrashuv), Telegram biznes-kanallar, sanoat katalog, tavsiya
- **Taklif:** tayyor app + buyurtma oqimi + boshqaruv paneli; ular faqat komissiya to'laydi
- **Onboarding:** "Hamkor bo'lish" arizasi → qo'ng'iroq → shartnoma → qo'lda tenant yaratish (M5)

### B. Yakka ishchi / kichik firma — micro-tenant
- Yakka tartibdagi tadbirkor (samozanyatost) sifatida ro'yxatdan o'tgan ishchini **kichik tenant** qilib qo'shish
- **Kanallar:** ish e'lonlari (OLX, ishkoni, Telegram ish kanallari), og'zaki

### C. Ishonch va xavfsizlik (uyga kiradi — muhim)
- Passport/PINFL tekshiruvi (rozilik bilan, UZ serverda shifrlangan)
- Telefon OTP tasdiq + profil rasmi
- Reyting/sharh tizimi, yomon ishlaganni suspend
- Har ishchi qaysi tenantga tegishli — javobgarlik tenant zimmasida (shartnomada)

---

## 13. Deploy va Infratuzilma

### Domain — `gloss.com.uz` (mavjud)
`.uz` domen brend/ishonch uchun a'lo. **Diqqat:** domen ≠ server joylashuvi — lokalizatsiya (§11.1) serverlar UZ'da bo'lishini talab qiladi, domen o'sha UZ serverга yo'naltiriladi.

**Subdomain arxitekturasi:**
| Subdomain | Vazifa |
|---|---|
| `gloss.com.uz` | Landing + "Hamkor bo'lish" ariza formasi |
| `api.gloss.com.uz` | Backend REST + WebSocket |
| `admin.gloss.com.uz` | Admin panel (platform + tenant, role-based) |
| `cdn.gloss.com.uz` | Rasm/statik fayllar |
| `{firma}.gloss.com.uz` | (kelajakda) tenant white-label |

### Hosting — O'zbekiston (lokalizatsiya shart)
- 🥇 **Production:** UZCLOUD (Uztelecom) — serverlar UZ'da, scalable, compliance uchun ishonchli
- 🥈 **Boshlanғich/dev:** Ahost, PS.uz VPS (arzon, tez)
- Boshqa: UZINFOCOM/Datahost, Sarkor Telecom

**Server o'lchami (bosqichma-bosqich):**
| Bosqich | Konfiguratsiya |
|---|---|
| MVP/dev | 1 VPS (Linux, 4GB+ RAM, 2 vCPU, Docker) |
| Ishga tushish | 1–2 VPS yoki UZCLOUD (backend + DB alohida) |
| O'sish | Managed Kubernetes / ko'p node |

**Tanlashda tekshirish:** serverlar jismonan UZ'da (yozma tasdiq) · PostGIS o'rnatish imkoni · yetarli RAM · kunlik DB backup · statik IP + SSL

### Backend deploy
```
UZ server → Docker Compose (backend + Postgres/PostGIS + Redis + nginx)
DNS A-record → server IP
SSL → Let's Encrypt (har subdomain)
DB → Davlat personalizatsiya markazi reyestrida ro'yxat (§11.1)
```

### Mobil app tarqatish (serverга EMAS!)
Mobil app telefonда ishlaydi, faqat `api.gloss.com.uz` ga ulanadi. Store orqali tarqatiladi:

| App | Kanal |
|---|---|
| `gloss_user` | Google Play + App Store (ochiq) |
| `gloss_worker` | Play Store yoki APK havola |
| `gloss_delivery` | Play Store yoki APK |

**Developer akkaunt:** Google Play $25 (bir martalik) · Apple $99/yil

**Build:**
```
flutter build appbundle   # Android → .aab → Play Console
flutter build ipa         # iOS → App Store Connect
```

**To'lov:** tozalash xizmati + real mahsulot = jismoniy tovar/xizmat → **Payme/Click ruxsat** (Apple/Google IAP majburiy emas).

**Yangilanish:** yangi versiya → qayta build → Store'ga yuklash.

### Admin panel deploy (web)
React build → `admin.gloss.com.uz` (nginx static) yoki UZ serverда konteyner.
