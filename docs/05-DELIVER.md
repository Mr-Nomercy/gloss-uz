# Gloss Deliver App

> Bu — Gloss'ning o'z (platform-level) yetkazish floti, tenant/firmalarga bog'liq emas, faqat market buyurtmalarini yetkazadi (batafsil: [12-END-TO-END-ROADMAP.md](12-END-TO-END-ROADMAP.md)).

Kuryer ilovasi. Mahsulotlarni ombordan mijozga yetkazib berish uchun mo'ljallangan.

## Texnologiyalar

Flutter 3.x, Riverpod, GoRouter, Dio + Retrofit, Freezed, Firebase Messaging

## Ekranlar tuzilishi

```
Splash → Onboarding → Login/Register → Verify
                ↓
            HomeScreen (asosiy dashboard)
            ├── Buyurtmalar (tab: Faol/Tugallangan)
            │   └── Buyurtma detali (bottom sheet)
            ├── Statistika (daromad, haftalik grafik)
            └── Profil (ma'lumotlar, sozlamalar)
```

## Asosiy flux

### 1. Online/offline holat
```
HomeScreen'da toggle:
    ONLINE → Yangi yetkazish buyurtmalarini qabul qiladi
    OFFLINE → Yangi buyurtma kelmaydi
```

### 2. Yetkazish jarayoni
```
1. Buyurtmani qabul qilish
2. Ombordan olib ketish (en_route_to_pickup)
3. Mahsulotni olish (picked_up)
4. Mijozga yetkazish (en_route_to_delivery)
5. Yetkazish (delivered)
6. Tugallash (completed)
```

### 3. Buyurtma detali (bottom sheet)
```
    → Mahsulot nomi + holat
    → Manzil (Qayerdan → Qayerga)
    → Narx
    → Mijoz telefoni
    → Vaqt
```

## Backend bilan bog'lanish (hali amalga oshirilmagan)

| API endpoint | Maqsad | Holat |
|-------------|--------|-------|
| `POST /auth/register` | Ro'yxatdan o'tish | ❌ |
| `POST /auth/login` | Kirish | ❌ |
| `GET /courier/orders` | Buyurtmalar ro'yxati | ❌ |
| `PATCH /courier/orders/:id/accept` | Buyurtmani qabul qilish | ❌ |
| `PATCH /courier/orders/:id/status` | Holat o'zgartirish | ❌ |
| `GET /courier/stats` | Statistika | ❌ |
| `GET /courier/wallet` | Hamyon | ❌ |
| `POST /courier/wallet/withdraw` | Pul chiqarish | ❌ |
| `GET /courier/profile` | Profil | ❌ |

## UI komponentlari

| Komponent | Foydalanish |
|-----------|-------------|
| `GlossCard` | Balans, buyurtma kartochkalari |
| `GlossButton` | Tugmalar |
| `GlossTextField` | Forma maydonlari |
| `GlossTheme` | Dizayn tizimi |

## Xususiyatlar

| Xususiyat | Tavsif | Holat |
|-----------|--------|-------|
| Online/offline | Buyurtma qabul qilish holati | UI only |
| Balans | 2 450 000 so'm (hardcode) | Hardcode |
| Statistika | Buyurtmalar, daromad, reyting | Hardcode |
| Haftalik grafik | Maxsulot yetkazish soni | Hardcode |
| Buyurtmalar | Faol/Tugallangan tablari | Hardcode |
| Profil | Ism, telefon, reyting | Hardcode |
| Til tanlash | UZ/RU/EN (onboarding) | UI only |
| Bildirishnomalar | Firebase dependency bor | ❌ |

## Loyiha tuzilishi

```
gloss_deliver/
├── lib/
│   ├── main.dart
│   ├── app.dart                  # GoRouter konfiguratsiyasi
│   ├── firebase_options.dart
│   ├── l10n/
│   └── screens/
│       ├── splash_screen.dart
│       ├── onboarding_screen.dart
│       ├── login_screen.dart     # Riverpod LoginFormProvider
│       ├── register_screen.dart
│       ├── verify_phone_screen.dart
│       ├── home_screen.dart      # Online toggle, balans, statistika
│       ├── orders_screen.dart    # Faol/Tugallangan tablari
│       ├── stats_screen.dart     # Daromad, haftalik grafik
│       └── profile_screen.dart   # Profil, sozlamalar
```
