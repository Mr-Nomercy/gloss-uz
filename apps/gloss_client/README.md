# Gloss Client (Yandex Go analog)

Customer app for booking cleaning services + purchasing cleaning products.

## Screen Flow

```
┌──────────────────┐
│     Auth Flow     │
│ Login/Register/   │
│ Verify Phone      │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│     Home Page    │
│ • Promo banners  │
│ • Quick actions  │
│ • Featured serv  │
│ • Popular prods  │
└────┬────────┬────┘
     │        │
     ▼        ▼
┌─────────┐ ┌──────────┐
│ Services│ │ Products │
│ List    │ │ List     │
│ • Types │ │ • Categ  │
│ • Prices│ │ • Search │
└────┬────┘ │ • Filters│
     │      └─────┬────┘
     ▼            ▼
┌─────────┐ ┌──────────┐
│ Booking │ │ Product  │
│ • Area  │ │ Detail   │
│ • Rooms │ │ • Add to │
│ • Extra │ │   cart   │
│ • Time  │ └────┬─────┘
│ • Addr  │      │
└────┬────┘      ▼
     │       ┌─────────┐
     │       │   Cart  │
     │       └────┬────┘
     │            │
     └────┬───────┘
          ▼
    ┌──────────┐
    │ Checkout │
    │ • Addr   │
    │ • Pay    │
    │ • Confirm│
    └────┬─────┘
         │
         ▼
    ┌──────────┐
    │  Order   │
    │  Detail  │
    │ • Status │
    │ • Track  │
    │ • Chat   │
    └──────────┘
```

## Roles
- **client**: Book services, buy products, track orders, chat, write reviews

## Key Features
1. Service booking (Standard, Deep, Post-const, Office, Carpet, Window)
2. Product marketplace (search, filter, cart, checkout)
3. Mixed orders (service + products in one order)
4. Real-time tracking (Yandex MapKit)
5. Chat with provider and courier
6. Reviews & ratings
7. Order history & reorder
8. Push notifications
9. Multiple payment methods (Click, Payme, Cash)

## Tech Stack
- Riverpod + Freezed (state / models)
- Dio + Retrofit (API)
- Yandex MapKit (maps / tracking)
- Drift (offline cache)
- GoRouter (navigation)
- Firebase FCM (push)
