# Gloss Admin Panel

React asosida yaratilgan veb-admin panel. Platformani boshqarish uchun ikki xil rol mavjud: Platform Admin va Tenant Admin.

## Texnologiyalar

| Texnologiya | Maqsad |
|-------------|--------|
| React 18 + TypeScript | Frontend framework |
| Vite 5 | Build tool |
| Tailwind CSS 3 | Styling |
| Radix UI | UI komponentlari |
| Recharts | Grafikalar |
| React Router 6 | Navigation |

## Rollar tuzilishi

### Platform Admin (`admin@gloss.uz`)
Butun platformani boshqaradi. Quyidagi sahifalarga kiradi:

| Sahifa | Route | Vazifasi |
|--------|-------|----------|
| Dashboard | `/platform` | KPI: umumiy daromad, bugungi buyurtmalar, faol providerlar, komissiya |
| Providerlar | `/platform/tenants` | Tozalash kompaniyalarini boshqarish (qo'shish, tahrirlash) |
| Komissiya | `/platform/commissions` | Xizmat turlari bo'yicha komissiya stavkalarini o'zgartirish |
| Buyurtmalar | `/platform/orders` | Barcha buyurtmalar (qidirish, holat, provider bo'yicha filtrlash) |
| Foydalanuvchilar | `/platform/users` | Foydalanuvchilar ro'yxati (faqat ko'rish) |
| Market | `/platform/market` | Mahsulotlar katalogini boshqarish (qo'shish, tahrirlash) |
| To'lovlar | `/platform/payouts` | Providerlarga to'lovlar (kutilmoqda/to'langan/rad etilgan) |
| Sozlamalar | `/platform/settings` | Platforma nomi, telefon, email, minimal buyurtma |

### Tenant Admin (`firma@gloss.uz`)
O'z tozalash kompaniyasini boshqaradi:

| Sahifa | Route | Vazifasi |
|--------|-------|----------|
| Dashboard | `/tenant` | Balans, buyurtmalar soni, xodimlar soni, reyting |
| Xodimlar | `/tenant/workers` | Xodimlarni boshqarish (qo'shish, tahrirlash) |
| Buyurtmalar | `/tenant/orders` | O'z buyurtmalari (qidirish, holat filtri) |
| Hamyon | `/tenant/wallet` | Balans, tushum/chiqim, tarix |
| Reytinglar | `/tenant/ratings` | Sharhlar va reytinglar |
| Sozlamalar | `/tenant/settings` | Kompaniya nomi, telefon, manzil |

## Autentifikatsiya tizimi

```typescript
interface User {
  id: string;
  email: string;
  name: string;
  role: 'platform-admin' | 'tenant-admin';
  tenantId?: string;        // faqat tenant-admin uchun
  tenantName?: string;      // faqat tenant-admin uchun
}
```

- **Saqlash:** `localStorage` (`gloss_admin_user`)
- **Himoya:** `ProtectedRoute` komponenti — foydalanuvchi yo'q bo'lsa `/login` ga yo'naltiradi
- **Kirish:** Email + parol formasi

## Dashboard metrikalari

### Platform Admin Dashboard
- Jami daromad: 146 500 000 so'm
- Bugungi buyurtmalar: 24
- Faol providerlar: 5
- Yig'ilgan komissiya: 14 650 000 so'm
- Oylik daromad grafigi (yanvar-iyul)

### Tenant Admin Dashboard
- Balans: 8 450 000 so'm
- Buyurtmalar: 234
- Xodimlar: 4
- O'rtacha reyting: 4.8

## Buyurtma holatlari

| Holat | Rang | Ma'no |
|-------|------|-------|
| Yangi | Yashil (och) | Yangi buyurtma |
| Jarayonda | Orange | Bajarilmoqda |
| Yetkazilgan | Yashil | Tugallangan |
| Bekor qilingan | Qizil | Bekor qilingan |

## Komissiya tizimi

Har bir xizmat turi uchun komissiya stavkasi alohida belgilanadi:

| Xizmat turi | Komissiya |
|-------------|-----------|
| Uy tozalash | 10% |
| Gilam yuvish | 12% |
| Avto yuvish | 15% |
| Mebel tozalash | 8% |
| Deraza tozalash | 10% |

## To'lovlar tizimi

Provider holatiga qarab to'lovlar:
- **To'langan** (yashil) — pul o'tkazilgan
- **Kutilmoqda** (orange) — pul o'tkazilishi kerak
- **Rad etilgan** (qizil) — rad etilgan

""To'lash" tugmasi faqat `Kutilmoqda` holatidagi qatorlarda ko'rinadi.

## Backend bilan bog'lanish (hali amalga oshirilmagan)

| API endpoint | Maqsad | Holat |
|-------------|--------|-------|
| `POST /auth/login` | Kirish | ❌ |
| `GET /admin/dashboard` | Dashboard ma'lumotlari | ❌ |
| `GET /admin/tenants` | Providerlar ro'yxati | ❌ |
| `POST /admin/tenants` | Provider qo'shish | ❌ |
| `PATCH /admin/tenants/:id` | Provider tahrirlash | ❌ |
| `GET /admin/orders` | Barcha buyurtmalar | ❌ |
| `GET /admin/commissions` | Komissiya stavkalari | ❌ |
| `PATCH /admin/commissions/:id` | Komissiya o'zgartirish | ❌ |
| `POST /admin/payouts/:id/pay` | To'lov amalga oshirish | ❌ |
| `GET /admin/users` | Foydalanuvchilar | ❌ |
| `GET /admin/products` | Mahsulotlar | ❌ |

## Loyiha tuzilishi

```
gloss_admin/
├── src/
│   ├── main.tsx              # Kirish nuqtasi
│   ├── App.tsx               # Route konfiguratsiyasi
│   ├── lib/
│   │   ├── auth.tsx          # AuthProvider context
│   │   ├── data.ts           # Mock ma'lumotlar
│   │   └── utils.ts          # formatCurrency, formatDate
│   ├── pages/
│   │   ├── login.tsx
│   │   ├── platform/         # Platform admin sahifalari (8 ta)
│   │   └── tenant/           # Tenant admin sahifalari (6 ta)
│   └── components/
│       ├── layout/           # DashboardLayout, Sidebar, Header
│       └── ui/               # Button, Card, Badge, Table, Dialog
```
