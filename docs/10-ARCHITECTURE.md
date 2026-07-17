# Complete Project Architecture — To'liq Arxitektura

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENTLAR                                │
│                                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │  Client   │  │ Provider │  │  Seller  │  │ Deliver  │       │
│  │   App     │  │   App    │  │   App    │  │   App    │       │
│  │ (Flutter) │  │ (Flutter)│  │ (Flutter)│  │ (Flutter)│       │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘       │
│       │              │              │              │              │
│       └──────────────┴──────┬───────┴──────────────┘              │
│                             │                                    │
│                    ┌────────▼────────┐                           │
│                    │   Admin Panel   │                           │
│                    │   (React + TS)  │                           │
│                    └────────┬────────┘                           │
└─────────────────────────────┼───────────────────────────────────┘
                              │
                              │ HTTPS / WSS
                              │
┌─────────────────────────────┼───────────────────────────────────┐
│                        BACKEND                                   │
│                              │                                   │
│                    ┌────────▼────────┐                           │
│                    │   NestJS API    │                           │
│                    │   (REST + WS)   │                           │
│                    └────────┬────────┘                           │
│                              │                                   │
│              ┌───────────────┼───────────────┐                   │
│              │               │               │                   │
│     ┌────────▼──────┐ ┌─────▼──────┐ ┌─────▼──────┐            │
│     │  PostgreSQL   │ │  Redis     │ │  Firebase  │            │
│     │  (ma'lumotlar)│ │  (cache)   │ │  (push)    │            │
│     └───────────────┘ └────────────┘ └────────────┘            │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow

### 1. Client → Backend

```
Client App
    │
    ├── HTTP POST /auth/login
    │   → { phone, password }
    │   ← { accessToken, refreshToken, user }
    │
    ├── HTTP GET /services
    │   ← [ { id, name, basePrice, ... } ]
    │
    ├── HTTP POST /orders
    │   → { serviceId, addressId, scheduledAt, tariff }
    │   ← { orderId, orderNumber, total }
    │
    └── WSS order:status_changed
        ← { orderId, status, location? }
```

### 2. Provider → Backend

```
Provider App
    │
    ├── HTTP GET /provider/orders?status=active
    │   ← [ { id, service, client, status, ... } ]
    │
    ├── HTTP PATCH /provider/orders/:id/accept
    │   ← { success: true }
    │
    ├── HTTP PATCH /provider/orders/:id/status
    │   → { status: "en_route" }
    │   ← { success: true }
    │
    └── WSS offer:new
        ← { orderId, service, address, price, timeout }
```

### 3. Seller → Backend

```
Seller App
    │
    ├── HTTP GET /products?sellerId=me
    │   ← { products: [...], total, page }
    │
    ├── HTTP POST /products
    │   → { name, price, stockQty, categoryId, ... }
    │   ← { id, name, status: "pending" }
    │
    └── HTTP GET /seller/dashboard
        ← { products: 12, orders: 45, revenue: 2500000 }
```

### 4. Deliver → Backend

```
Deliver App
    │
    ├── HTTP GET /courier/orders?status=active
    │   ← [ { id, product, from, to, status } ]
    │
    ├── HTTP PATCH /courier/orders/:id/status
    │   → { status: "picked_up" }
    │   ← { success: true }
    │
    └── WSS order:assigned_courier
        ← { orderId, product, pickupAddress, deliveryAddress }
```

### 5. Admin → Backend

```
Admin Panel
    │
    ├── HTTP GET /admin/dashboard
    │   ← { revenue, orders, tenants, commission }
    │
    ├── HTTP GET /admin/tenants
    │   ← [ { id, name, phone, status, orders, rating } ]
    │
    ├── HTTP PATCH /admin/commissions/:id
    │   → { percentage: 12 }
    │   ← { success: true }
    │
    └── HTTP POST /admin/payouts/:id/pay
        ← { success: true }
```

## Authentication Flow

```
1. Foydalanuvchi telefon + parol kiritadi
2. Backend: /auth/login → { accessToken, refreshToken, user }
3. Client: accessToken'ni secure_storage'ga saqlaydi
4. Har bir so'rovga: Authorization: Bearer <accessToken>
5. 401 xatoda: /auth/refresh → yangi accessToken
6. Refresh ham xato bo'lsa: logout → /auth ga yo'naltirish
```

## Role-Based Access Control

| Rol | Ruxsatlar |
|-----|-----------|
| `client` | Buyurtma berish, mahsulot sotib olish, baholash |
| `provider` | Buyurtmalarni qabul qilish, xodimlarni boshqarish, jadval |
| `courier` | Yetkazish buyurtmalarini qabul qilish, holat yangilash |
| `seller` | Mahsulotlarni boshqarish, profil, KYC |
| `admin` | Barcha ma'lumotlarni boshqarish, komissiya, to'lovlar |
| `super_admin` | Adminlarni boshqarish, tizim sozlamalari |

## State Management Architecture

### Flutter Apps (Riverpod)

```
ProviderScope
    │
    ├── AuthProvider          # Autentifikatsiya holati
    ├── RouterProvider        # GoRouter konfiguratsiyasi
    ├── ServiceProvider       # Xizmatlar ro'yxati
    ├── OrderProvider         # Buyurtmalar
    ├── CartProvider          # Savat
    ├── AddressProvider       # Manzillar
    ├── ProductProvider       # Mahsulotlar
    ├── WalletProvider        # Hamyon
    └── NotificationProvider  # Bildirishnomalar
```

### Admin Panel (React Context + useState)

```
AuthProvider
    │
    ├── PlatformAdminPages
    │   ├── Dashboard (useState)
    │   ├── Tenants (useState)
    │   ├── Commissions (useState)
    │   ├── Orders (useState)
    │   └── ...
    │
    └── TenantAdminPages
        ├── Dashboard (useState)
        ├── Workers (useState)
        ├── Orders (useState)
        └── ...
```

## Offline Support

```
Drift DB (SQLite)
    │
    ├── SyncQueue table
    │   ├── entity: "order"
    │   ├── entityId: "ord_123"
    │   ├── action: "create"
    │   ├── payload: { ... }
    │   └── status: "pending"
    │
    └── SyncManager
        ├── enqueue(entity, action, payload)
        ├── getPending()
        ├── markSynced(id)
        └── markFailed(id)
```

## Error Handling Strategy

```
1. Network error → RetryInterceptor (3 marta)
2. Auth error (401) → Token refresh → Retry
3. Validation error (400) → Form xatoliklari
4. Server error (500) → Umumiy xatolik sahifasi
5. Timeout → RetryInterceptor
6. Offline → SyncQueue'ga qo'shish
```

## Performance Considerations

| Optimizatsiya | Qo'llanilgan joy |
|---------------|-----------------|
| Cached Network Image | Rasmlar uchun |
| Shimmer loading | Rasmlar yuklanayotganda |
| Pagination | Mahsulotlar ro'yxati |
| Lazy loading | Ekranlar |
| Image compression | Rasm yuklash |
| Debounce | Qidiruv |
