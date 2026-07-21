# Gloss Client App

> Endpoint jadvali pastda hozircha rejalashtirilgan (backend Django, batafsil: [12-END-TO-END-ROADMAP.md](12-END-TO-END-ROADMAP.md)).

Mijoz ilovasi — Flutter platformasida yaratilgan. Tozalash xizmatlarini buyurtma qilish va mahsulotlar marketidan xarid qilish imkonini beradi.

## Texnologiyalar

| Texnologiya | Maqsad |
|-------------|--------|
| Flutter 3.x | Cross-platform mobile ilova |
| Riverpod | State management |
| GoRouter | Navigation/routing |
| Dio + Retrofit | API calls |
| Freezed | Data modellari |
| Firebase Messaging | Push notifications |
| flutter_secure_storage | Token saqlash |

## Ekranlar tuzilishi

```
Splash → Auth → Verify → Register
                ↓
            HomeScreen
            ├── Buyurtmalar (Xizmatlar)
            │   ├── Xizmatlar ro'yxati
            │   ├── Booking (buyurtma berish)
            │   │   ├── Sana tanlash
            │   │   ├── Vaqt tanlash
            │   │   ├── Manzil tanlash
            │   │   ├── Tariff tanlash (Iqtisod/Standart/Premium)
            │   │   ├── To'lov usuli
            │   │   └️ Promo-kod
            │   ├── Buyurtma kuzatish
            │   ├── Bekor qilish (sabab tanlash)
            │   └️ Baholash (sifat, punctuallik, muloqot)
            │
            ├── Market (Mahsulotlar)
            │   ├── Kategoriyalar
            │   ├── Qidirish
            │   ├── Flash sale
            │   ├── Mahsulot detali
            │   ├── Savat
            │   ├── Sevimlilar
            │   └️ Checkout (to'lov)
            │
            ├── Profile
            │   ├── Buyurtmalarim
            │   ├── Sevimlilar
            │   ├── Manzillar
            │   └️ Yordam
            │
            └── Bildirishnomalar
```

## Asosiy flux

### 1. Autentifikatsiya
```
Telefon raqam kiritish (+998 XX XXX XX XX)
    → SMS OTP (4 xonali kod)
    → Ism kiritish (ro'yxatdan o'tish)
    → Bosh sahifa
```

### 2. Tozalash xizmatini buyurtma qilish
```
Xizmat tanlash (Tozalash/Kir yuvish/Tamirlash/Market)
    → Xizmat turi tanlash (Umumiy/Premium/Kir yuvish)
    → Booking ekraniga o'tish
    → Sana + vaqt tanlash
    → Manzil tanlash (autocomplete)
    → Tariff tanlash:
        - Iqtisod: 35 000 so'm, 2 soat
        - Standart: 50 000 so'm, 3 soat
        - Premium: 85 000 so'm, 4 soat
    → To'lov usuli (Naqd/Karta)
    → Promo-kod (ixtiyoriy, 10% chegirma)
    → Narx hisob-kitobi
    → Buyurtma berish
```

### 3. Buyurtmani kuzatish
```
OrderScreen:
    1. Buyurtma qabul qilindi
    2. Yo'lda
    3. Tozalash jarayonda
    4. Yakunlandi → Baholash dialogi
```

### 4. Mahsulot sotib olish
```
Market ekranidan mahsulot tanlash
    → Mahsulot detali (tavsif, sharhlar, reyting)
    → Savatga qo'shish (miqdor tanlash)
    → Savatni boshqarish (o'chirish, promo-kod)
    → Checkout:
        - Manzil tanlash
        - To'lov usuli (Naqd/Click/Payme/Karta)
        - Buyurtmani tasdiqlash
    → Muvaffaqiyat ekraniga o'tish
```

## Backend bilan bog'lanish (hali amalga oshirilmagan)

Hozirgi vaqtda barcha ma'lumotlar hardcode qilingan. Backend bilan bog'lanish kerak:

| API endpoint | Maqsad | Holat |
|-------------|--------|-------|
| `POST /auth/register` | Ro'yxatdan o'tish | ❌ |
| `POST /auth/login` | Kirish | ❌ |
| `POST /auth/refresh` | Token yangilash | ❌ |
| `GET /services` | Xizmatlar ro'yxati | ❌ |
| `GET /services/{id}/price` | Narx hisoblash | ❌ |
| `POST /orders` | Buyurtma yaratish | ❌ |
| `GET /orders/{id}` | Buyurtma holati | ❌ |
| `PATCH /orders/{id}/cancel` | Bekor qilish | ❌ |
| `POST /orders/{id}/rate` | Baholash | ❌ |
| `GET /products` | Mahsulotlar | ❌ |
| `GET /products/{id}` | Mahsulot detali | ❌ |
| `POST /promo-codes/validate` | Promo-kod tekshirish | ❌ |
| `GET /addresses` | Manzillar | ❌ |

## UI komponentlari

| Komponent | Foydalanish |
|-----------|-------------|
| `GlossButton` | Asosiy tugmalar (primary/outlined) |
| `GlossCard` | Kartochkalar |
| `GlossTextField` | Matn kiritish maydonlari |
| `GlossTheme` | Dizayn tizimi (ranglar, tipografiya) |

## Lokalizatsiya

- Asosiy til: **O'zbekcha (uz)**
- Qo'shimcha: Русский (ru), English (en)
- Hozirgi holat: Skeleton — asosiy UI matnlari hardcode qilingan
