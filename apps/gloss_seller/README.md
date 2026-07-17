# Gloss Seller (Yandex Eats analog)

App for marketplace sellers to manage their cleaning product store.

## Screen Flow

```
┌─────────────┐
│  Auth Flow   │
│ + KYC        │
│ (Passport    │
│  Selfie      │
│  Bank Card   │
│  INN)        │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│   Dashboard     │
│ • Sales today   │
│ • Orders        │
│ • Revenue       │
│ • Stock alerts  │
│ • Rating        │
└────┬────────┬───┘
     │        │
     ▼        ▼
┌─────────┐ ┌──────────┐
│Products │ │  Orders  │
│ List    │ │ • Incom- │
│ Add     │ │   ing    │
│ Edit    │ │ • Ready  │
│ Stock   │ │ • History│
│ Variants│ └────┬─────┘
│ Images  │      │
└────┬────┘      │
     │           ▼
     │    ┌──────────────┐
     │    │  Mark Ready  │
     │    │  for Pickup  │
     │    └──────────────┘
     │
     ▼
┌─────────┐
│Analytics│
│ • Chart │
│ • Top   │
│ • Trend │
│ • Period│
└─────────┘

┌──────────┐
│ Earnings │
│ • Payout │
│ • History│
│ • Tax    │
└──────────┘

┌──────────┐
│ Profile  │
│ • Shop   │
│ • KYC    │
│ • Chat   │
│ • Config │
└──────────┘
```

## Key Features
1. Product CRUD (name, price, images, variants, stock)
2. Category assignment
3. Inventory management (stock alerts)
4. Incoming orders with status management
5. Mark items ready for pickup
6. Live chat with clients
7. Sales analytics (charts, trends, top products)
8. Payout history & commission tracking
9. KYC verification (passport, selfie, bank card, INN)
10. Shop profile management
