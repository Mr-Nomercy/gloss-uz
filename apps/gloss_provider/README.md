# Gloss Provider

Cleaning provider app for the Gloss ecosystem. Workers receive and manage cleaning orders.

## Screen Flow

```
┌─────────────┐
│  Auth Flow   │
│ (Register/   │
│  Login)      │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│   Provider Home │
│ • Availability  │
│ • Today's jobs  │
│ • Earnings card │
└────────┬────────┘
         │
         ▼
┌──────────────────┐
│ Available Orders │
│ (Geo-filtered)   │
│ • Distance       │
│ • Service type   │
│ • Price          │
│ • Timer countdown│
└───────┬──────────┘
        │
        ▼
┌──────────────────┐
│  Active Order    │
│ • Client info    │
│ • Address        │
│ • Status update  │
│ • Chat           │
│ • Start/Complete │
└───────┬──────────┘
        │
        ▼
┌──────────────────┐
│   Order History  │
│ • Completed jobs │
│ • Earnings break │
└──────────────────┘
```
