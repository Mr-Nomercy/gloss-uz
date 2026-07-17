# RBAC Matrix — Gloss Ecosystem

## Role Hierarchy

```
super_admin
   └── admin
         ├── seller (Marketplace)
         ├── provider (Cleaning Service)
         ├── courier (Delivery)
         └── client (End User)
```

Users can have **multiple roles** (e.g., a person can be both `provider` and `courier`).

## Permission Legend

| Symbol | Meaning |
|--------|---------|
| ✓      | Allowed |
| ×      | Denied  |
| ~      | Restricted to own/assigned |
| —      | Not applicable |

---

## Permission Matrix

### Users

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| user:read:self  | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| user:update:self | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| user:read:all   | ✓ | ✓ | × | × | × | × |
| user:manage     | ✓ | × | × | × | × | × |

### Roles

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| role:read       | ✓ | ✓ | × | × | × | × |
| role:assign     | ✓ | × | × | × | × | × |
| role:manage     | ✓ | × | × | × | × | × |

### Addresses

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| address:create  | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| address:read:self| ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| address:update:self| ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| address:delete:self| ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| address:read:all | ✓ | ✓ | × | × | × | × |

### Services

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| service:read    | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| service:create  | ✓ | ✓ | × | × | × | × |
| service:update  | ✓ | ✓ | × | × | × | × |
| service:delete  | ✓ | × | × | × | × | × |
| service:price-calc | ✓ | ✓ | × | ✓ | × | ✓ |

### Categories

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| category:read   | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| category:create | ✓ | ✓ | × | × | × | × |
| category:update | ✓ | ✓ | × | × | × | × |
| category:delete | ✓ | × | × | × | × | × |

### Products

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| product:read    | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| product:create  | ✓ | ✓ | ~ | × | × | × |
| product:update  | ✓ | ✓ | ~ | × | × | × |
| product:delete  | ✓ | ✓ | ~ | × | × | × |
| product:moderate| ✓ | ✓ | × | × | × | × |
| product:purchase | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

### Cart

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| cart:read       | × | × | × | × | × | ✓ |
| cart:write      | × | × | × | × | × | ✓ |

### Orders

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| order:create    | ✓ | ✓ | × | × | × | ✓ |
| order:read:own  | ✓ | ✓ | ~ | ~ | ~ | ~ |
| order:read:all  | ✓ | ✓ | × | × | × | × |
| order:accept    | ✓ | ✓ | × | ~ | ~ | × |
| order:assign    | ✓ | ✓ | × | × | × | × |
| order:update:status | ✓ | ✓ | ~ | ~ | ~ | × |
| order:cancel    | ✓ | ✓ | × | × | × | ~ |
| order:update:payment | ✓ | ✓ | × | × | × | × |
| order:reassign  | ✓ | ✓ | × | × | × | × |

### Disputes

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| dispute:create  | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| dispute:read    | ✓ | ✓ | ~ | ~ | ~ | ~ |

### Tracking

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| tracking:read   | ✓ | ✓ | ~ | ~ | ~ | ~ |
| tracking:start  | ✓ | ✓ | × | × | × | × |
| tracking:update:location | × | × | × | × | ✓ | × |
| tracking:update:status | ✓ | ✓ | × | × | ✓ | × |

### Chat

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| chat:create     | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| chat:send:message | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| chat:read:own   | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| chat:read:all   | ✓ | ✓ | × | × | × | × |
| chat:delete     | ✓ | ✓ | ~ | ~ | ~ | ~ |

> **Note on chat:delete:** `client`, `provider`, `courier`, `seller` can delete their own messages (`~`); `super_admin` and `admin` can delete any message (`all`). Non-admin bulk delete is denied (`×`).

### Payments

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| payment:create  | ✓ | ✓ | × | × | × | ✓ |
| payment:read:own| ✓ | ✓ | ~ | ~ | ~ | ~ |
| payment:read:all| ✓ | ✓ | × | × | × | × |
| payment:refund  | ✓ | ✓ | × | × | × | × |
| payment:manage  | ✓ | × | × | × | × | × |

### KYC

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| kyc:submit:self | ✓ | ✓ | ✓ | ✓ | ✓ | × |
| kyc:read:own    | ✓ | ✓ | ✓ | ✓ | ✓ | × |
| kyc:review:pending | ✓ | ✓ | × | × | × | × |
| kyc:approve     | ✓ | × | × | × | × | × |
| kyc:reject      | ✓ | × | × | × | × | × |

> **Note on KYC approval:** Only `super_admin` can approve or reject KYC submissions. Even `admin` is explicitly denied (`×`).
> ```
> kyc:approve   | × | × | × | × | × | ✓ (super_admin only)
> kyc:reject    | × | × | × | × | × | ✓ (super_admin only)
> ```

### Notifications

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| notification:read:own | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| notification:mark-read | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| notification:send:all | ✓ | × | × | × | × | × |
| notification:send:targeted | ✓ | ✓ | × | × | × | × |

### Reviews

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| review:create   | ✓ | ✓ | × | × | × | ✓ |
| review:read     | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| review:update:own | ✓ | ✓ | × | × | × | ✓ |
| review:delete   | ✓ | ✓ | × | × | × | × |
| review:report   | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

### Wallet

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| wallet:read     | ✓ | ✓ | ~ | ~ | ~ | ~ |
| wallet:withdraw | ✓ | ✓ | × | × | × | × |

### Analytics

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| analytics:read:own | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| analytics:read:all | ✓ | ✓ | × | × | × | × |

### Files

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| file:upload     | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| file:read:own   | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| file:delete:own | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| file:read:all   | ✓ | ✓ | × | × | × | × |
| file:delete:all | ✓ | × | × | × | × | × |

### Support

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| support:contact | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

### GDPR

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| gdpr:export     | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| gdpr:delete     | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

### Seller Dashboard

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| seller:profile:manage | ✓ | ✓ | ✓ | × | × | × |
| seller:orders:read | ✓ | ✓ | ✓ | × | × | × |
| seller:orders:update:status | × | × | ~ | × | × | × |
| seller:payout:read | ✓ | ✓ | ✓ | × | × | × |
| seller:products:crud | ✓ | ✓ | ✓ | × | × | × |

### Admin Dashboard

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| admin:dashboard | ✓ | ✓ | × | × | × | × |
| admin:users:list | ✓ | ✓ | × | × | × | × |
| admin:users:block | ✓ | × | × | × | × | × |
| admin:orders:all | ✓ | ✓ | × | × | × | × |
| admin:config:read | ✓ | ✓ | × | × | × | × |
| admin:config:update | ✓ | × | × | × | × | × |

### System

| Resource:Action | super_admin | admin | seller | provider | courier | client |
|-----------------|:-----------:|:-----:|:------:|:--------:|:-------:|:------:|
| system:health   | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| system:metrics  | ✓ | ✓ | × | × | × | × |
| system:logs     | ✓ | × | × | × | × | × |
| system:config   | ✓ | × | × | × | × | × |

---

## API Module → Roles Mapping

| Module       | Minimum Role  | Notes |
|--------------|---------------|-------|
| /auth/*      | Public        | Rate-limited per IP |
| /users/me/*  | Authenticated | Any valid JWT |
| /addresses/* | authenticated | client, seller |
| /services/*  | Public (read) | JWT optional for read |
| /categories/* | Public (read) | JWT optional for read |
| /cart/*      | client        | Own cart management |
| /products/*  | Public (read) | JWT optional for read |
| /orders/*    | authenticated | Role-filtered internally |
| /tracking/*  | authenticated | Courier writes, others read |
| /wallet/*    | authenticated | Providers, couriers, sellers read-only |
| /chats/*     | authenticated | Participant scoped |
| /payments/*  | authenticated | Client creates, admin manages |
| /payouts/*   | authenticated | provider, courier, seller (own) |
| /kyc/*       | seller, provider, courier | Submitters |
| /seller/*    | seller        | Dashboard |
| /provider/*  | provider      | Provider dashboard |
| /courier/*   | courier       | Courier dashboard |
| /disputes/*  | authenticated | Client (own), admin+ (all) |
| /reviews/*   | authenticated | Clients create |
| /notifications/* | authenticated | Own only |
| /files/*     | authenticated | Own only |
| /analytics/* | authenticated | Role-scoped |
| /admin/*     | admin+        | Full system access |

---

## Frontend Route Guards (Flutter)

Each Flutter app has route-level guards based on roles:

```
gloss_client:        [client]
gloss_provider_deliver: [provider, courier]
gloss_seller:        [seller]
```

Provider-Deliver app has **role switch** — user selects active role at login or switches in settings.

### Multi-role user example:
- User registers with roles `["provider", "courier"]`
- Login returns `roles: ["provider", "courier"]`
- Provider-Deliver app shows role switcher
- API responses filter data based on active role
- Notifications route to appropriate role channel

## Support Agent Role (future)

- Not a separate app role; uses admin with restricted permissions
- Permissions: chat:read, chat:write (support chats only), dispute:read, dispute:resolve
- Cannot access: kyc:approve, payment:refund, analytics
