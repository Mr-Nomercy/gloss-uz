# Gloss — Cleaning Service & Marketplace Platform

## Business Model

Gloss — bu O'zbekiston bo'ylab tozalash xizmatlari va mahsulotlar marketini birlashtirgan on-demand platforma.

### Asosiy tamoyillar

1. **Gloss o'zining tozalash xizmatlarini boshqaradi** — uchinchi tomon sellerlari tozalash xizmatiga qo'shilmaydi
2. **Gloss o'zining marketi** — mahsulotlarni faqat Gloss sotadi, uchinchi tomon sellerlari marketga qo'shilmaydi
3. **Cleaning service providerlari** — mustaqil tozalash kompaniyalari platformaga qo'shiladi, KYC'dan o'tadi va xizmat ko'rsatadi
4. **Deliver va seller bog'langan** — mahsulotlar yetkazib berish deliver orqali amalga oshiriladi

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
| **Provider** | Tozalash xizmatini ko'rsatadi, xodimlarni boshqaradi | `gloss_provider` |
| **Seller** | Mahsulotlarni joylaydi, omborni boshqaradi | `gloss_seller` |
| **Deliver** | Mahsulotlarni yetkazib beradi | `gloss_deliver` |
| **Platform Admin** | Butun platformani boshqaradi | `gloss_admin` |
| **Tenant Admin** | O'z tozalash kompaniyasini boshqaradi | `gloss_admin` |

### Daromad modeli

- **Komissiya (20%)** — tozalash xizmatlaridan
- **Komissiya (15%)** — mahsulot sotishdan
- **Yetkazish xizmati** — 100 000 so'mdan ortiq buyurtmalar uchun bepul, pastda 15 000 so'm

### Texnologiya stack

| Qatlam | Texnologiya |
|--------|-------------|
| Mobile (Client, Provider, Deliver, Seller) | Flutter 3.x, Riverpod, GoRouter, Freezed |
| Admin Panel | React 18, TypeScript, Vite, Tailwind CSS, Radix UI |
| Backend API | NestJS, Prisma, PostgreSQL |
| Real-time | Socket.IO |
| Push notifications | Firebase Cloud Messaging |
| Maps | Yandex Maps API |

### Monorepo tuzilishi

```
gloss/
├── apps/
│   ├── gloss_client/        # Mijoz ilovasi (Flutter)
│   ├── gloss_provider/      # Tozalash xizmati provayderi (Flutter)
│   ├── gloss_seller/        # Sotuvchi ilovasi (Flutter)
│   ├── gloss_deliver/       # Kuryer ilovasi (Flutter)
│   └── gloss_admin/         # Admin panel (React)
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
