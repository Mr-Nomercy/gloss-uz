# Gloss — Cleaning Service & Marketplace Platform

> ⚠️ **Bu hujjat qisman eskirgan.** Joriy manba: [`12-END-TO-END-ROADMAP.md`](12-END-TO-END-ROADMAP.md) — backend stack (Django, NestJS emas), to'liq DB sxemasi, endpointlar va yangilangan biznes-model tafsilotlari o'sha yerda. Pastdagi tuzilma yangilangan, lekin ekran/UI tafsilotlari uchun 01-05 fayllarga qarang.

## Business Model

Gloss — bu O'zbekiston bo'ylab tozalash xizmatlari va mahsulotlar marketini birlashtirgan on-demand, **multi-tenant** platforma.

### Asosiy tamoyillar

1. **Gloss = Product Owner** — market mahsulotlarini FAQAT Gloss (platform_admin) qo'shadi, uchinchi tomon sotuvchisi/alohida seller app yo'q
2. **Delivery = Gloss'ning o'z floti** — platform-level, tenant/firmalarga bog'liq emas, faqat market buyurtmalarini yetkazadi, cleaning ishchilariga aloqasi yo'q
3. **Firmalar (tenant)** — mustaqil tozalash kompaniyalari, avval Gloss bilan shartnoma tuzadi, so'ng buyurtma olish huquqiga ega bo'ladi; taqsimot geolokatsiya + firma bo'yicha
4. **Ishchi/kuryer ro'yxatdan o'tishi** — firma admin bergan invite-ID orqali; ID yo'q bo'lsa, avval firma shartnoma tuzishi kerak

### Business Model Tuzilishi

```
┌─────────────────────────────────────────────────────────┐
│                    GLOSS PLATFORM                        │
│                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │
│  │  Client   │  │ Provider │  │  Seller  │  │ Deliver  │ │
│  │   App     │  │   App    │  │   App    │  │   App    │ │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘ │
│       │              │              │              │       │
│       └──────────────┴──────┬───────┴──────────────┘       │
│                             │                              │
│                    ┌────────▼────────┐                     │
│                    │   Admin Panel   │                     │
│                    │  (Boshqaruv)    │                     │
│                    └─────────────────┘                     │
└─────────────────────────────────────────────────────────┘
```

### Foydalanuvchi rollari

| Rol | Vazifasi | App |
|-----|----------|-----|
| **Client** | Tozalash xizmatini buyurtma qiladi, mahsulot sotib oladi | `gloss_client` |
| **Provider (Worker)** | Tozalash xizmatini ko'rsatadi, firma invite-ID orqali ro'yxatdan o'tadi | `gloss_provider` |
| **Deliver (Courier)** | Faqat market mahsulotlarini yetkazadi — Gloss'ning o'z floti, tenant'ga bog'liq emas | `gloss_deliver` |
| **Platform Admin** | Butun platformani boshqaradi — tenantlar, komissiya, **market mahsulotlari (Product Owner shu yerda)**, audit log | `gloss_admin` |
| **Tenant Admin** | O'z tozalash kompaniyasini boshqaradi, ishchi invite-kod generatsiya qiladi | `gloss_admin` |

> `gloss_seller` app **kerak emas** — market CRUD faqat `platform_admin` orqali (yuqoriga qarang).

### Daromad modeli

- **Komissiya** — xizmat turi bo'yicha o'zgaruvchan (`commission_rules` jadvali), bazaviy: tozalash ~20%, mahsulot sotishdan 15%
- **Yetkazish xizmati** — 100 000 so'mdan ortiq buyurtmalar uchun bepul, pastda 15 000 so'm

### Texnologiya stack

| Qatlam | Texnologiya |
|--------|-------------|
| Mobile (Client, Provider, Deliver) | Flutter 3.x, Riverpod, GoRouter, Freezed |
| Admin Panel | React 18, TypeScript, Vite, Tailwind CSS, Radix UI |
| Backend API | **Django 5.1 + DRF + GeoDjango** (batafsil: [12-END-TO-END-ROADMAP.md](12-END-TO-END-ROADMAP.md)) |
| Database | PostgreSQL 16 + PostGIS 3.4 |
| Real-time | Django Channels (WebSocket) |
| Background jobs | Celery + Redis |
| Push notifications | Firebase Cloud Messaging |
| Maps | Yandex Maps API |

### Monorepo tuzilishi

```
gloss-uz/
├── apps/
│   ├── gloss_client/        # Mijoz ilovasi (Flutter)
│   ├── gloss_provider/      # Tozalash xizmati provayderi/ishchi (Flutter)
│   ├── gloss_seller/        # ⚠️ Legacy — endi kerak emas, market platform_admin orqali boshqariladi
│   ├── gloss_deliver/       # Kuryer ilovasi (Flutter) — Gloss'ning o'z floti
│   └── gloss_admin/         # Admin panel (React)
├── backend/                  # Django + DRF + GeoDjango + Channels + Celery (batafsil: 12-END-TO-END-ROADMAP.md)
├── packages/
│   ├── shared/
│   │   ├── models/          # Freezed data modellari
│   │   ├── api-client/      # Retrofit API client
│   │   ├── constants/       # Biznes qoidalari
│   │   ├── i18n/            # Lokalizatsiya (uz/ru/en)
│   │   ├── socket-client/   # WebSocket client
│   │   └── drift-db/        # Lokal SQLite ma'lumotlar bazasi
│   └── ui-kit/              # Shared dizayn tizimi
└── melos.yaml               # Monorepo boshqaruvi
```

### Buyurtma hayoti sikli (Order Lifecycle)

Tozalash xizmati uchun:
```
Client buyurtma beradi
    → searching (qidirilmoqda)
    → assigned (tayinlangan)
    → en_route (yo'lda)
    → arrived yetib keldi)
    → in_progress (jarayonda)
    → completed (tugallandi)
    → rated (baholandi)
```

Mahsulot yetkazish uchun:
```
Client buyurtma beradi
    → pending (kutilmoqda)
    → confirmed (tasdiqlangan)
    → assigned_courier (kuryer tayinlangan)
    → en_route_to_pickup (olib ketishga yo'lda)
    → picked_up (olindi)
    → en_route_to_delivery (yetkazishga yo'lda)
    → delivered (yetkazildi)
    → completed (tugallandi)
```
