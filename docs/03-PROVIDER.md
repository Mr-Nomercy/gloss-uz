# Gloss Provider App

> Ro'yxatdan o'tish endi firma admin bergan invite-ID orqali bo'ladi (batafsil: [12-END-TO-END-ROADMAP.md](12-END-TO-END-ROADMAP.md)).

Tozalash xizmati provayderi ilovasi. Cleaning service kompaniyalari o'z xizmatlarini ko'rsatadi, buyurtmalarni qabul qiladi va xodimlarini boshqaradi.

## Texnologiyalar

Flutter 3.x, Riverpod, GoRouter, Dio + Retrofit, Freezed, Firebase Messaging

## Ekranlar tuzilishi

```
Splash → Auth → Verify → Register
                ↓
            HomeScreen (asosiy dashboard)
            ├── Buyurtmalar (3 tab: Faol/Rejalashtirilgan/Tugallangan)
            │   └── Buyurtma detali (7 qadamli stepper)
            ├── Vaqtlarim (haftalik jadval)
            ├── Statistika (performans dashboard)
            ├── Hamyon (balans, tranzaksiyalar)
            ├── Profil (ma'lumotlar, jamoa)
            ├── Yordam (FAQ, aloqa)
            └── Sozlamalar (til, bildirishnomalar)
```

## Asosiy flux

### 1. Online/Offline holat
```
HomeScreen'da toggle:
    ONLINE → Yangi buyurtma takliflarini qabul qiladi
    OFFLINE → Yangi buyurtma kelmaydi
```

### 2. Yangi buyurtma qabul qilish
```
15 soniyalik countdown timer bilan taklif keladi:
    → Buyurtma ma'lumotlari (xizmat turi, manzil, narx)
    → "Qabul qilish" yoki "Rad etish"
    → Vaqt tugasa — avtomatik rad etiladi
```

### 3. Buyurtma hayoti (7 qadam)
```
0. Buyurtma yuborildi
1. Qabul qilindi
2. Yo'lda (mijozga)
3. Yetib keldi
4. Xizmat ko'rsatilmoqda
5. Tugallangan
6. Baholangan
```

Har bir qadamda tegishli tugma:
- "Yo'lga chiqdim" → 3-qadam
- "Yetib keldim" → 4-qadam
- "Boshlash" → 4-qadam (xizmat boshlash)
- "Tugatish" → 5-qadam

### 4. Vaqtlarni boshqarish
```
Haftalik jadval (7 kun):
    Har bir kun uchun:
    - Yoqish/O'chirish (Switch)
    - Boshlanish vaqti
    - Tugash vaqti
    Saqlash → Muvaffaqiyat SnackBar
```

## Backend bilan bog'lanish (hali amalga oshirilmagan)

| API endpoint | Maqsad | Holat |
|-------------|--------|-------|
| `POST /auth/register` | Ro'yxatdan o'tish | ❌ |
| `POST /auth/login` | Kirish | ❌ |
| `GET /provider/orders` | Buyurtmalar ro'yxati | ❌ |
| `PATCH /provider/orders/:id/accept` | Buyurtmani qabul qilish | ❌ |
| `PATCH /provider/orders/:id/status` | Holat o'zgartirish | ❌ |
| `PATCH /provider/orders/:id/cancel` | Bekor qilish | ❌ |
| `GET /provider/stats` | Statistika | ❌ |
| `GET /provider/wallet` | Hamyon | ❌ |
| `POST /provider/wallet/withdraw` | Pul chiqarish | ❌ |
| `GET /provider/availability` | Vaqtlar | ❌ |
| `PATCH /provider/availability` | Vaqtlarni yangilash | ❌ |
| `GET /provider/notifications` | Bildirishnomalar | ❌ |

## UI komponentlari

| Komponent | Foydalanish |
|-----------|-------------|
| `GlossCard` | Kartochkalar (balans, buyurtma, statistika) |
| `GlossButton` | Tugmalar (qabul qilish, rad etish, boshlash) |
| `GlossTextField` | Matn kiritish |
| `GlossTheme` | Dizayn tizimi |

## Xususiyatlar

| Xususiyat | Tavsif | Holat |
|-----------|--------|-------|
| Online/offline | Buyurtma qabul qilish holati | UI only |
| 15 soniya timer | Yangi taklif uchun vaqt | UI only |
| 7 qadamli stepper | Buyurtma hayoti | UI only |
| Haftalik jadval | Ish vaqtlari | UI only |
| Statistika | Buyurtmalar, daromad, reyting | Hardcode |
| Hamyon | Balans, tranzaksiyalar | Hardcode |
| Bildirishnomalar | Buyurtma, to'lov, tizim | Hardcode |
| Til tanlash | O'zbekcha/Rусский | UI only |
| FAQ | Yordam savollari | Statik |
