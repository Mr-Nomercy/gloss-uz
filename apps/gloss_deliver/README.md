# Gloss Deliver

Courier/delivery app for the Gloss ecosystem. Couriers receive and fulfill delivery orders.

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
│   Courier Home  │
│ • Online toggle │
│ • Nearby jobs   │
│ • Earnings card │
└────────┬────────┘
         │
         ▼
┌──────────────────┐
│ Available Orders │
│ • Distance        │
│ • Items           │
│ • Pay             │
│ • Timer countdown │
└───────┬──────────┘
        │
        ▼
┌──────────────────┐
│  Delivery Route  │
│ • Map + Nav      │
│ • Location share │
│ • Chat           │
│ • Photo proof    │
│ • Signature      │
│ • Complete       │
└───────┬──────────┘
        │
        ▼
┌──────────────────┐
│   Delivery Done  │
│ • Payment conf   │
│ • Rate client    │
└──────────────────┘
```
