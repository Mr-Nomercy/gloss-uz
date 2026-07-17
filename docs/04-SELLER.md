# Gloss Seller App

Sotuvchi ilovasi. Gloss marketiga mahsulotlar joylash, omborni boshqarish va shaxsiy profilingizni ko'rish imkonini beradi.

## Texnologiyalar

Flutter 3.x, Riverpod, GoRouter, Dio + Retrofit, Freezed, Firebase Messaging

## Ekranlar tuzilishi

```
Splash → Onboarding → Login/Register → Verify
                ↓
            HomeScreen (NavigationBar bilan)
            ├── Mahsulotlar (tab 1)
            │   ├── Mahsulotlar ro'yxati
            │   ├── Yangi mahsulot qo'shish
            │   └── Dashboard (statistika)
            ├── Buyurtmalar (tab 2) — hali placeholder
            └── Profil (tab 3)
                ├── Do'kon ma'lumotlari
                ├── KYC hujjatlari
                ├── To'lov hisobi
                ├── Yordam
                └️ Chiqish
```

## Asosiy flux

### 1. Ro'yxatdan o'tish
```
Telefon raqam + Ism + Parol
    → Shartnomalarga rozilik
    → SMS OTP (6 xonali kod)
    → Bosh sahifa
```

### 2. Mahsulot qo'shish
```
Yangi mahsulot formasi:
    → Rasm yuklash
    → Mahsulot nomi
    → Narxi (so'm)
    → Soni (ombor)
    → Tavsifi
    → Kategoriya tanlash
    → Saqlash
```

### 3. KYC tekshiruvi
```
Shaxsni tasdiqlash:
    → Hujjat turi tanlash:
        - Pasport
        - Selfie
        - Bank kartasi
        - INN
        - Litsenziya
        - Sertifikat
    → Hujjat rasmini yuklash
    → Yuborish
```

### 4. Dashboard
```
Do'kon identifikatsiyasi:
    → Mahsulotlar soni: 12
    → Buyurtmalar soni: 45
    → Daromad: 2 500 000 so'm
    → Reyting: 4.8
```

## Backend bilan bog'lanish (hali amalga oshirilmagan)

| API endpoint | Maqsad | Holat |
|-------------|--------|-------|
| `POST /auth/register` | Ro'yxatdan o'tish | ❌ |
| `POST /auth/login` | Kirish | ❌ |
| `GET /seller/profile` | Profil | ❌ |
| `PATCH /seller/profile` | Profil tahrirlash | ❌ |
| `GET /seller/dashboard` | Dashboard | ❌ |
| `GET /products` | Mahsulotlar ro'yxati | ❌ |
| `POST /products` | Mahsulot qo'shish | ❌ |
| `PATCH /products/:id` | Mahsulot tahrirlash | ❌ |
| `DELETE /products/:id` | Mahsulot o'chirish | ❌ |
| `POST /seller/kyc` | KYC yuborish | ❌ |
| `GET /seller/kyc` | KYC holati | ❌ |

## UI komponentlari

| Komponent | Foydalanish |
|-----------|-------------|
| `GlossCard` | Mahsulot kartochkalari |
| `GlossButton` | Tugmalar |
| `GlossTextField` | Forma maydonlari |
| `GlossTheme` | Dizayn tizimi |

## Xususiyatlar

| Xususiyat | Tavsif | Holat |
|-----------|--------|-------|
| Onboarding | 3 sahifalik tushuntirish | UI only |
| Ro'yxatdan o'tish | Telefon + ism + parol | UI only |
| Kirish | Telefon + parol | UI only |
| Mahsulotlar ro'yxati | 5 ta placeholder | Hardcode |
| Mahsulot qo'shish | To'liq forma | UI only |
| Dashboard | Statistika kartochkalari | Hardcode |
| KYC | Hujjat turi + rasm | UI only |
| Profil | Do'kon ma'lumotlari | Hardcode |
| Til tanlash | UZ/RU/EN | UI only |

## Loyiha tuzilishi

```
gloss_seller/
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
│       ├── home_screen.dart      # NavigationBar (3 tab)
│       ├── dashboard_screen.dart
│       ├── add_product_screen.dart
│       ├── kyc_screen.dart
│       └── profile_screen.dart
```
