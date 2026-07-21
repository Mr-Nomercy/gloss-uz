# Shared Packages

Barcha app'lar o'rtasida umumiy kod. Monorepo tuzilishida 7 ta package mavjud.

## Package tuzilishi

```
packages/
├── shared/
│   ├── models/           # Freezed data modellari
│   ├── api-client/       # Retrofit API client
│   ├── constants/        # Biznes qoidalari, enum'lar
│   ├── i18n/             # Lokalizatsiya (uz/ru/en)
│   ├── socket-client/    # WebSocket client
│   └── drift-db/         # Lokal SQLite ma'lumotlar bazasi
└── ui-kit/               # Shared dizayn tizimi
```

## 1. models (`packages/shared/models/`)

Freezed yordamida yaratilgan immutable data modellari.

### Asosiy modellar

| Model | Asosiy maydonlar | Maqsad |
|-------|-----------------|--------|
| `User` | id, phone, email, fullName, avatar, roles[], isBlocked | Foydalanuvchi |
| `Profile` | id, phone, fullName, isActive, roles[], sellerProfile, addresses[] | To'liq profil |
| `AuthTokens` | accessToken, refreshToken, user | Autentifikatsiya |
| `Order` | id, orderNumber, clientId, type, status, subtotal, total, paymentStatus, addressId | Buyurtma |
| `OrderItem` | id, orderId, productId, serviceId, quantity, unitPrice, totalPrice | Buyurtma qatori |
| `Service` | id, serviceTypeId, name, durationMinutes, basePrice, pricings[] | Tozalash xizmati |
| `ServiceType` | id, code, name, icon, services[] | Xizmat turi |
| `ServicePricing` | id, serviceId, areaFrom, areaTo, pricePerSqm, fixedPrice | Maydon asosida narx |
| `Product` | id, sellerId, categoryId, name, basePrice, salePrice, stockQty, rating | Mahsulot |
| `ProductVariant` | id, productId, name, price, stockQty, attributes | Mahsulot varianti |
| `ProductImage` | id, productId, url, isPrimary | Mahsulot rasmi |
| `Category` | id, parentId, name, slug, children[] | Kategoriya daraxti |
| `Address` | id, userId, lat, lng, addressLine, floor, apartment, isDefault | Manzil |
| `SellerProfile` | id, shopName, shopSlug, rating, totalSales, commissionRate, isVerified | Sotuvchi profili |
| `KycDocument` | id, userId, type, fileUrl, status, rejectionReason | KYC hujjati |
| `PromoCode` | id, code, type, value, minOrderAmount, appliesTo, isActive | Promo-kod |
| `Role` | id, name, description, isSystem | Foydalanuvchi roli |

### Narx formatlash
Narxlar `String` formatida saqlanadi (masalan, `"50000"`), floating-point xatoliklarni oldini olish uchun.

## 2. api-client (`packages/shared/api-client/`)

Retrofit yordamida yaratilgan REST API client.

### API endpointlari

#### Auth
| Method | Endpoint | Maqsad |
|--------|----------|--------|
| POST | `/auth/register` | Ro'yxatdan o'tish |
| POST | `/auth/login` | Kirish |
| POST | `/auth/refresh` | Token yangilash |
| POST | `/auth/forgot-password` | Parolni tiklash |
| POST | `/auth/reset-password` | Parolni qayta belgilash |
| POST | `/auth/change-password` | Parolni o'zgartirish |
| POST | `/auth/logout` | Chiqish |

#### User
| Method | Endpoint | Maqsad |
|--------|----------|--------|
| GET | `/users/me` | Profil olish |
| PATCH | `/users/me` | Profil tahrirlash |
| POST | `/users/me/avatar` | Avatar yuklash |

#### Services
| Method | Endpoint | Maqsad |
|--------|----------|--------|
| GET | `/service-types` | Xizmat turlari |
| GET | `/services` | Xizmatlar ro'yxati |
| GET | `/services/{id}/price` | Narx hisoblash |

#### Products
| Method | Endpoint | Maqsad |
|--------|----------|--------|
| GET | `/products` | Mahsulotlar (pagination, filter) |
| GET | `/products/{id}` | Mahsulot detali |
| POST | `/products` | Mahsulot qo'shish |
| PATCH | `/products/{id}` | Mahsulot tahrirlash |
| DELETE | `/products/{id}` | Mahsulot o'chirish |

#### Seller
| Method | Endpoint | Maqsad |
|--------|----------|--------|
| POST | `/seller/profile` | Profil yaratish |
| GET | `/seller/profile` | Profil olish |
| PATCH | `/seller/profile` | Profil tahrirlash |
| GET | `/seller/dashboard` | Dashboard |
| POST | `/seller/kyc` | KYC yuborish |
| GET | `/seller/kyc` | KYC holati |

#### Addresses
| Method | Endpoint | Maqsad |
|--------|----------|--------|
| GET | `/addresses` | Manzillar ro'yxati |
| POST | `/addresses` | Manzil qo'shish |
| PATCH | `/addresses/{id}` | Manzil tahrirlash |
| PATCH | `/addresses/{id}/default` | Standart manzil |
| DELETE | `/addresses/{id}` | Manzil o'chirish |

#### Promo Codes
| Method | Endpoint | Maqsad |
|--------|----------|--------|
| POST | `/promo-codes/validate` | Promo-kod tekshirish |

### Dio konfiguratsiyasi

- **Base URL:** `http://localhost:3000/api/v1` (dev) / `https://api.gloss.com.uz` (prod)
- **Timeout:** 10s connect, 30s receive
- **AuthInterceptor:** Bearer token qo'shadi, 401 xatoda avtomatik token yangilaydi
- **RetryInterceptor:** Timeout/connection xatolarida 3 marta qayta urinadi

## 3. constants (`packages/shared/constants/`)

### OrderStatus (12 ta holat)
```
pending → confirmed → assigned_provider → assigned_courier
→ ready_for_pickup → in_progress → en_route_to_pickup
→ picked_up → en_route_to_delivery → delivered → completed → cancelled
```

### CleaningOrderStatus (8 ta holat)
```
searching → assigned → en_route → arrived → in_progress
→ completed → rated → cancelled
```

### PaymentStatus
```
pending → paid → failed → refunded
```

### UserRole
```
client, provider, courier, seller, admin, super_admin
```
> ⚠️ `seller` — legacy, endi kerak emas (market `platform_admin`/`super_admin` orqali). Yangilangan rol nomlari uchun `12-END-TO-END-ROADMAP.md`: `platform_admin`, `tenant_admin`, `tenant_worker`, `customer`, `courier`.

### BusinessRules

| Qoida | Qiymat |
|-------|--------|
| Minimal xizmat buyurtmasi | 30 000 so'm |
| Minimal mahsulot buyurtmasi | 20 000 so'm |
| Minimal aralash buyurtma | 50 000 so'm |
| Xizmat komissiyasi | 20% |
| Mahsulot komissiyasi | 15% |
| Bandlik vaqti | 08:00 - 22:00 |
| Oxirgi slot | 21:00 |
| Maksimal rejalashtirish | 14 kun |

### AppConstants

| Konstanta | Qiymat |
|-----------|--------|
| Ilova nomi | Gloss |
| OTP qayta yuborish | 30 soniya |
| Taklif vaqti | 15 soniya |
| Qayta urinishlar | 3 marta |
| Standart sahifa hajmi | 20 |

## 4. ui-kit (`packages/ui-kit/`)

Shared dizayn tizimi.

### Ranglar palitrası

| Rang | Kod | Maqsad |
|------|-----|--------|
| glossGreen | #00AA13 | Asosiy brend rangi |
| glossDarkGreen | #004A00 | Qorong'i variant |
| glossBg | #F5F5F5 | Fond rangi |
| glossCard | #FFFFFF | Kartochka foni |
| glossText | #1A1A1A | Asosiy matn |
| glossHint | #757575 | Yordamchi matn |
| glossRed | #E53935 | Xatolik |
| glossOrange | #E65100 | Ogohlantirish |
| glossStar | #FFB300 | Reyting yulduzlari |

### Typografiya

| Stil | O'lcham | Og'irlik |
|------|---------|----------|
| displayLarge | 32px | Bold |
| headlineLarge | 24px | W600 |
| titleLarge | 18px | W600 |
| bodyLarge | 16px | Normal |
| bodyMedium | 14px | Normal |
| labelLarge | 14px | W600 |

### Widget'lar

| Widget | Tavsif |
|--------|--------|
| `GlossButton` | Primary/outlined tugma, loading holati |
| `GlossCard` | 12px radius, elevation 1, optional onTap |
| `GlossTextField` | Label, hint, validation, obscureText |
| `context.gloss` | GlossTheme extension getter |

## 5. i18n (`packages/shared/i18n/`)

3 ta til: O'zbekcha (uz), Русский (ru), English (en).

20 ta tarjima kaliti: appName, login, register, phone, password, search, orders, profile, home, logout, save, cancel, confirm, loading, error, retry, noInternet, hello, settings, language, notifications, location.

## 6. socket-client (`packages/shared/socket-client/`)

WebSocket client (singleton). Hozirgi holatda skeleton — interfeys tayyor, lekin implementatsiya bo'sh.

> ⚠️ **Texnik nomuvofiqlik:** bu paket `socket_io_client` (haqiqiy Socket.IO protokoli) ga bog'liq, lekin backend **Django Channels** ishlatadi — bu oddiy WebSocket protokoli, Socket.IO emas. Ular bir-biriga to'g'ridan-to'g'ri ulanmaydi. M3 (dispatch + real-time) boshlanganda bu paketni `web_socket_channel` (yoki shunga o'xshash oddiy WS client) bilan almashtirish kerak bo'ladi.

## 7. drift-db (`packages/shared/drift-db/`)

Lokal SQLite ma'lumotlar bazasi. Offline qo'llab-quvvatlash uchun sync queue jadvali mavjud.

### SyncQueue jadvali
| Ustun | Tur | Maqsad |
|-------|-----|--------|
| entity | Text | Entity turi |
| entityId | Text | Entity ID |
| action | Text | create/update/delete |
| payload | Text | JSON ma'lumot |
| status | Text | pending/syncing/failed |
| retryCount | Int | Qayta urinishlar soni |
