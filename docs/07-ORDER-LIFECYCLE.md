# Order Lifecycle — Buyurtma Hayoti

To'lov, yetkazish va tozalash xizmatlari uchun to'liq buyurtma sikli.

## 1. Tozalash xizmati (Cleaning Service)

```
┌─────────────┐
│   Client     │  Buyurtma beradi
│   buyurtma   │  (sana, vaqt, manzil, tariff)
│   beradi     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  searching   │  Tizim yaqinidagi providerlarni qidiradi
│  (qidirilmoq)│  15 soniya ichida javob kutiladi
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  assigned    │  Provider buyurtmani qabul qildi
│ (tayinlangan)│  Xodimlar tayinlandi
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  en_route    │  Provider / xodimlar mijozga yo'l olgan
│  (yo'lda)    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  arrived     │  Provider / xodimlar yetib keldi
│ (yetib keldi)│
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ in_progress  │  Tozalash ishlari bajarilmoqda
│ (jarayonda)  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  completed   │  Tozalash tugallandi
│ (tugallandi) │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   rated      │  Client baholadi (sifat, punctuallik, muloqot)
│  (baholandi) │
└─────────────┘
```

### Provider tomonidan boshqariladigan qadamlar

| Qadam | Provider harakati | Client ko'rishi |
|-------|-------------------|-----------------|
| searching | — | "Qidirilmoqda..." |
| assigned | "Qabul qilish" / "Rad etish" | "Provider tayinlandi" |
| en_route | "Yo'lga chiqdim" tugmasi | "Yo'lda" |
| arrived | "Yetib keldim" tugmasi | "Yetib keldi" |
| in_progress | "Boshlash" tugmasi | "Tozalash jarayonda" |
| completed | "Tugatish" tugmasi | "Tugallandi" |
| rated | — | Baholash dialogi |

### Bekor qilish sabablari

1. Rejam o'zgardi
2. Arzonroq topdim
3. Juda uzoq kutdim
4. Manzil noto'g'ri (izoh kerak)
5. Xizmat kerak emas
6. Provider bilan muammo (izoh kerak)
7. Boshqa (izoh kerak)

### Baholash tizimi

Client 3 ta bo'yicha baholaydi (har biri 5 yulduz):
- Tozalash sifati
- Vaqtida kelishi
- Muloqot

## 2. Mahsulot yetkazish (Product Delivery)

```
┌─────────────┐
│   Client     │  Buyurtma beradi (mahsulot + manzil)
│   buyurtma   │
│   beradi     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   pending    │  Buyurtma qabul qilindi
│ (kutilmoqda) │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  confirmed   │  Admin / tizim tasdiqladi
│ (tasdiqlangan)│
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ assigned_    │  Kuryer tayinlandi
│ courier      │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ en_route_    │  Kuryer ombor oldiga yo'l olgan
│ pickup       │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  picked_up   │  Mahsulot ombordan olindi
│  (olindi)    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ en_route_    │  Kuryer mijozga yo'l olgan
│ delivery     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  delivered   │  Mahsulot yetkazildi
│ (yetkazildi) │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  completed   │  Buyurtma tugallandi
│ (tugallandi) │
└─────────────┘
```

## 3. Narx hisob-kitobi

### Tozalash xizmati

```
Xizmat narxi (tariff bo'yicha):
    Iqtisod:    35 000 so'm
    Standart:   50 000 so'm
    Premium:    85 000 so'm

Chegirma (promo-kod): -10%
Yetkazish: Bepul (100 000 so'mdan ortiq)
Platforma komissiyasi: 20%

Jami = Xizmat narxi - Chegirma + Yetkazish
Provider oladi = Jami - (Jami × 20%)
```

### Mahsulot yetkazish

```
Mahsulot narxi:
    Umumiy: summa(mahsulotlar narxi)
    Chegirma: -promo-kod
    Yetkazish: 15 000 so'm (100 000 so'mdan pastda)
               Bepul (100 000 so'mdan yuqorida)

Jami = Mahsulot narxi - Chegirma + Yetkazish
Platforma komissiyasi: 15%
Seller oladi = Jami - (Jami × 15%)
Kuryer oladi = Yetkazish narxi
```

## 4. To'lov holatlari

| Holat | Tavsif |
|-------|--------|
| `pending` | To'lov kutilmoqda |
| `paid` | To'lov amalga oshirildi |
| `failed` | To'lov xatolik bilan tugadi |
| `refunded` | Pul qaytarildi |

## 5. Hamyon (Wallet) tizimi

### Provider hamyoni
```
Tushumlar:
    + Buyurtma to'lovi (har bir tugallangan buyurtma uchun)
    + Bonuslar (reytingga qarab)

Chiqimlar:
    - Komissiya (platforma komissiyasi)
    - Pul chiqarish (minimum 100 000 so'm)

Tranzaksiya tarixi:
    15 Iyul: +100 000 (buyurtma to'lovi)
    14 Iyul: +150 000 (buyurtma to'lovi)
    12 Iyul: -500 000 (pul chiqarish)
    10 Iyul: +80 000 (buyurtma to'lovi)
```

### Seller hamyoni
```
Tushumlar:
    + Mahsulot sotishdan tushgan pul

Chiqimlar:
    - Platforma komissiyasi (15%)
    - Yetkazish xizmati uchun to'lov

Tranzaksiya tarixi:
    Har bir buyurtma uchun alohida yozuv
```

## 6. Real-time kuzatish

### Socket.IO event'lari

| Event | Yo'nalish | Maqsad |
|-------|-----------|--------|
| `order:created` | Client → Server | Yangi buyurtma |
| `order:status_changed` | Server → Client | Holat o'zgardi |
| `order:assigned` | Server → Provider | Kuryer/provider tayinlandi |
| `order:location_update` | Provider → Client | Joylashuv yangilandi |
| `order:cancelled` | Har qanday | Buyurtma bekor qilindi |
| `offer:new` | Server → Provider | Yangi taklif |
| `offer:accepted` | Provider → Server | Taklif qabul qilindi |
| `offer:rejected` | Provider → Server | Taklif rad etildi |

## 7. Push notifications

| Bildirishnoma | Qabul qiluvchi | Maqsad |
|---------------|----------------|--------|
| Yangi buyurtma | Provider | "Yangi buyurtma keldi!" |
| Buyurtma tasdiqlandi | Client | "Buyurtmangiz tasdiqlandi" |
| Kuryer yo'lda | Client | "Kuryer yo'lda" |
| Buyurtma yetkazildi | Client | "Buyurtmangiz yetkazildi" |
| To'lov keldi | Provider/Seller | "To'lov qabul qilindi" |
| Buyurtma bekor qilindi | Client | "Buyurtma bekor qilindi" |
