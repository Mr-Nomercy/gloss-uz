# UAT Checklist — Gloss Ecosystem

## Overview
Comprehensive User Acceptance Testing checklist organized by user role. Each stakeholder must complete all applicable scenarios and sign off.

---

## 1. Client App Checklist (Customer Role)

### 1.1 Browse & Discovery
- [ ] **Browse Services**: Browse service categories, filter by category, view service details
- [ ] **Browse Products**: Browse product categories, filter/sort products, view product details
- [ ] **Search**: Search services and products (full-text, filters, sort)
- [ ] **Guest Browsing**: Browse catalog without authentication, sign-in gated at checkout
- [ ] **Promo Banners**: View promotional banners on home screen
- [ ] **Featured/Popular**: View featured services and popular products on home

### 1.2 Booking & Ordering
- [ ] **Service Booking Flow**: Select service → Enter address → Select schedule → Confirm
- [ ] **Product Cart**: Add products to cart, modify quantities, remove items
- [ ] **Mixed Orders**: Combine services and products in single order
- [ ] **Minimum Order Validation**: Service min 30,000 UZS, Product min 20,000 UZS, Mixed min 50,000 UZS
- [ ] **Address Management**: Add/edit/delete addresses, set default, geocoding
- [ ] **Schedule Selection**: ASAP + 30-min windows, booking hours 08:00-22:00 (last slot 21:00)
- [ ] **Promo Code Application**: Apply/remove promo codes, validate discount
- [ ] **Price Calculation**: Verify base price + area + extras + commission + VAT

### 1.3 Payment & Checkout
- [ ] **Click Payment**: Initiate → Redirect → Callback → Order confirmed
- [ ] **Payme Payment**: Initiate → Redirect → Callback → Order confirmed
- [ ] **Cash Payment**: Select cash, order confirmed, marked paid on delivery
- [ ] **Payment Failure Handling**: Failed payment → retry, timeout handling, error messages
- [ ] **Payment Status Display**: Pending/Paid/Failed/Refunded status display

### 1.4 Order Tracking & Management
- [ ] **Orders List**: View all orders with status filters
- [ ] **Order Detail**: View order details, items, pricing breakdown
- [ ] **Status Timeline**: View status history with timestamps
- [ ] **Live Tracking**: Real-time courier location on map, ETA, route polyline
- [ ] **Order Cancellation**: Cancel within 5 min free, tiered fees after assignment
- [ ] **Reorder**: Repeat previous order (products)

### 1.5 Chat & Communication
- [ ] **Chat List**: View active chats for active orders
- [ ] **Chat Page**: Send/receive messages, typing indicator, read receipts
- [ ] **Image Sharing**: Send images in chat
- [ ] **System Messages**: Auto-generated messages on status changes
- [ ] **Push Notifications**: Receive push for new messages, order updates

### 1.6 Reviews & Ratings
- [ ] **Rate Provider**: Rate provider after service completion (1-5 stars + text)
- [ ] **Rate Courier**: Rate courier after delivery (1-5 stars + text)
- [ ] **View Reviews**: View own reviews and responses

### 1.7 Profile & Settings
- [ ] **Profile Management**: Edit profile, avatar upload
- [ ] **Addresses**: Manage saved addresses
- [ ] **Payment Methods**: View saved payment methods
- [ ] **Settings**: Language (uz/ru/en), Notifications toggle, Dark/Light theme, About, Logout
- [ ] **Language Switch**: Instant language switch (uz/ru/en)
- [ ] **Theme Toggle**: Light/Dark mode toggle
- [ ] **Guest Mode**: Browse as guest, sign-in prompt at checkout

---

## 2. Provider App Checklist (Cleaner/Service Provider)

### 2.1 Authentication & Profile
- [ ] **Registration**: Register as provider, select services
- [ ] **KYC Submission**: Upload passport, selfie, INN, bank card
- [ ] **KYC Status**: View KYC status (pending/approved/rejected), rejection reason
- [ ] **Profile**: View/edit profile, service portfolio

### 2.2 Schedule Management
- [ ] **Weekly Schedule**: Set available days/times (weekly recurring)
- [ ] **Schedule Exceptions**: Add/remove specific date exceptions
- [ ] **Shift Validation**: Validate booking hours (08:00-22:00)

### 2.3 Order Management
- [ ] **Available Orders Feed**: View nearby available orders (geo-filtered)
- [ ] **Order Details**: View order details before accepting
- [ ] **Accept/Reject**: Accept order within 30-second timer, reject with reason
- [ ] **Active Order**: View active order details, client info, address
- [ ] **Status Updates**: Update status (en_route → arrived → in_progress → completed)
- [ ] **Timer**: Countdown timer for acceptance, on-site timer
- [ ] **No-Show Handling**: Auto-cancel after 15-min grace period

### 2.4 Earnings & Payouts
- [ ] **Earnings Dashboard**: Daily/weekly/monthly earnings summary
- [ ] **Payout History**: View payout history, status, amounts
- [ ] **Payout Schedule**: Weekly Tuesday, min 100,000 UZS

### 2.5 Chat & Communication
- [ ] **Chat with Client**: Chat for active orders
- [ ] **System Messages**: Auto-messages on status changes
- [ ] **Push Notifications**: Order assigned, status changes, chat messages

### 2.6 Service History
- [ ] **Completed Orders**: View completed order history
- [ ] **Earnings per Order**: View earnings breakdown per order

---

## 3. Courier App Checklist (Delivery Courier)

### 3.1 Authentication & Profile
- [ ] **Registration**: Register as courier, shift selection
- [ ] **KYC Submission**: Passport, selfie, INN, bank card
- [ ] **Shift Selection**: Morning/Afternoon/Night shift selection

### 3.2 Delivery Management
- [ ] **Available Deliveries**: View nearby available deliveries
- [ ] **Delivery Details**: View pickup/delivery addresses, items
- [ ] **Accept/Reject**: Accept delivery within timer, reject with reason
- [ ] **Navigation**: Yandex MapKit navigation to pickup → delivery
- [ ] **Live Map**: Live map with route polyline, current location
- [ ] **Location Sharing**: Share location every 3-5 seconds

### 3.3 Proof of Delivery
- [ ] **Photo Capture**: Capture delivery proof photo
- [ ] **Signature Pad**: Capture recipient signature
- [ ] **Delivery Confirmation**: Mark as delivered with proof

### 3.4 Multi-Order Management
- [ ] **Daily Route Overview**: View all assigned deliveries for the day
- [ ] **Multi-Order Batch**: View batched deliveries, optimized route
- [ ] **Batch Acceptance**: Accept/reject entire batch

### 3.5 Earnings & Payouts
- [ ] **Per-Delivery Earnings**: View earnings per delivery
- [ ] **Daily/Weekly Summary**: Daily and weekly earnings summary
- [ ] **Payout Schedule**: Weekly Wednesday, min 50,000 UZS (daily if >200,000)

### 3.6 Chat & Notifications
- [ ] **Chat with Client**: Chat for active deliveries
- [ ] **Chat with Provider**: Chat for coordination
- [ ] **Push Notifications**: New delivery, chat messages, status updates

---

## 4. Seller App Checklist (Product Seller)

### 4.1 Authentication & KYC
- [ ] **Registration**: Register as seller
- [ ] **KYC Submission**: Business docs, passport, INN, bank details
- [ ] **KYC Status**: Track verification status

### 4.2 Product Management
- [ ] **Product List**: View all products with status (active/draft/archived)
- [ ] **Add Product**: Create product with variants, images, pricing
- [ ] **Edit Product**: Edit product details, variants, images
- [ ] **Inventory Management**: Stock levels, low stock alerts
- [ ] **Product Status**: Activate/deactivate/archive products
- [ ] **Image Management**: Upload multiple images, reorder, delete

### 4.3 Order Management
- [ ] **Orders Dashboard**: Incoming orders, filter by status
- [ ] **Order Details**: View order items, customer info
- [ ] **Mark Ready**: Mark order ready for pickup
- [ ] **Order Status**: Track order through pickup → delivery

### 4.4 Analytics & Payouts
- [ ] **Sales Analytics**: Revenue, orders, top products charts
- [ ] **Payout History**: Weekly Monday payouts, min 50,000 UZS
- [ ] **Commission Display**: Platform commission (15%) breakdown

### 4.5 Reviews & Communication
- [ ] **Customer Reviews**: View product reviews
- [ ] **Respond to Reviews**: Respond to customer reviews
- [ ] **Chat with Client**: Chat for order-related questions
- [ ] **Push Notifications**: New order, chat messages, reviews

---

## 5. Admin Panel Checklist

### 5.1 User Management
- [ ] **User List**: View all users with filters (role, status, date)
- [ ] **User Details**: View user profile, orders, KYC, wallet
- [ ] **User Actions**: Suspend/activate, reset password, view audit log
- [ ] **Role Management**: Assign/revoke roles, custom permissions

### 5.2 KYC Moderation
- [ ] **KYC Queue**: View pending KYC submissions (providers, couriers, sellers)
- [ ] **KYC Review**: View documents, approve/reject with reason
- [ ] **KYC History**: View approval/rejection history
- [ ] **Bulk Actions**: Bulk approve/reject with same reason

### 5.3 Product/Service Moderation
- [ ] **Product Queue**: Pending product approvals
- [ ] **Product Review**: Approve/reject products with reason
- [ ] **Service Review**: Approve/reject service listings

### 5.4 Order Management
- [ ] **Order Overview**: All orders with filters (status, date, role)
- [ ] **Order Details**: Full order details, timeline, payments, chat
- [ ] **Manual Intervention**: Force status change, reassign provider/courier
- [ ] **Cancellation Review**: Review cancellations, penalties

### 5.5 Payments & Payouts
- [ ] **Payment Overview**: All payments, filter by status/provider
- [ ] **Failed Payments**: View failed payments, retry/refund
- [ ] **Payout Batches**: View payout batches, process manually if needed
- [ ] **Dispute Management**: View disputes, review evidence, resolve

### 5.6 Analytics & Monitoring
- [ ] **Business Dashboard**: Orders, revenue, users, conversion funnels
- [ ] **Operational Dashboard**: Active providers/couriers, order completion rate
- [ ] **System Health**: API latency, error rates, WebSocket connections
- [ ] **Revenue Analytics**: Revenue by service/product, commissions, payouts

### 5.7 System Configuration
- [ ] **System Config**: Platform fees, min order amounts, payout schedules
- [ ] **Promo Codes**: Create/manage promo codes
- [ ] **Categories**: Manage category tree
- [ ] **Service Types**: Manage service types and pricing
- [ ] **Audit Logs**: View audit log with filters

### 5.8 User Support
- [ ] **Dispute Management**: View and resolve customer disputes
- [ ] **Refund Processing**: Process refunds for orders/disputes
- [ ] **Support Tickets**: View and respond to support tickets

---

## 6. Cross-Role & System-Wide Tests

### 6.1 Real-Time Features
- [ ] **WebSocket Connections**: All apps maintain WS connection
- [ ] **Auto-Reconnect**: Auto-reconnect on network change/app background
- [ ] **Order Assignment**: Real-time order broadcast to nearby providers/couriers
- [ ] **Live Tracking**: 3-5s location updates, smooth marker movement
- [ ] **Chat Real-time**: Instant message delivery, typing indicators

### 6.2 Push Notifications (FCM)
- [ ] **Foreground**: Notifications handled in foreground
- [ ] **Background**: Notifications received in background
- [ ] **Terminated**: Notifications received when app killed
- [ ] **Deep Linking**: Tap notification → navigate to correct screen
- [ ] **Topics**: Topic subscriptions for role-based notifications

### 6.3 Offline Support
- [ ] **Offline Browsing**: Cached catalog browsing
- [ ] **Offline Orders**: View cached orders offline
- [ ] **Offline Chat**: Queue messages offline, sync on reconnect
- [ ] **Offline Orders**: Create orders offline, sync on reconnect
- [ ] **Conflict Resolution**: Conflict resolution UI for offline conflicts

### 6.4 Payments & Financial
- [ ] **Click Integration**: End-to-end Click payment flow
- [ ] **Payme Integration**: End-to-end Payme payment flow
- [ ] **Webhook Idempotency**: Idempotent webhook handling
- [ ] **Commission Calculation**: 15% split, platform fee, net amount
- [ ] **Auto-Payouts**: Weekly batch processing per role schedule
- [ ] **Refunds**: 14-day return, inspection, refund processing
- [ ] **Disputes**: Customer dispute workflow

### 6.5 KYC & Compliance
- [ ] **Liveness Detection**: Automated liveness check
- [ ] **Face Matching**: Selfie vs passport photo matching
- [ ] **Document Expiry**: Expiry validation + automated reminders
- [ ] **AML/PEP Screening**: Sanctions screening integration
- [ ] **GDPR Export**: Data export endpoint
- [ ] **Account Deletion**: Account deletion flow

### 6.6 Security & Compliance
- [ ] **Certificate Pinning**: Certificate pinning on all apps
- [ ] **Root/Jailbreak Detection**: Detection + warning
- [ ] **Password Hashing**: Argon2id password hashing
- [ ] **OTP Rate Limiting**: OTP brute force protection
- [ ] **CORS/CSRF**: Proper CORS and CSRF configuration
- [ ] **Webhook Security**: HMAC signature verification (Click/Payme)
- [ ] **File Upload Security**: MIME whitelist, ClamAV scan, signed URL expiry

### 6.7 Localization & Accessibility
- [ ] **Languages**: All strings in uz/ru/en
- [ ] **RTL Support**: RTL layout for Arabic (if applicable)
- [ ] **Large Fonts**: Dynamic type support
- [ ] **Semantic Labels**: Screen reader labels
- [ ] **Contrast**: WCAG AA contrast ratios

### 6.8 Performance
- [ ] **Image Caching**: Cached network images
- [ ] **Lazy Loading**: Lazy list loading
- [ ] **Shimmer Loading**: Shimmer placeholders
- [ ] **Image Optimization**: Compressed uploads, WebP
- [ ] **Lazy Routes**: Lazy route loading

---

## 7. Sign-Off Requirements

Each stakeholder must complete their role's checklist and sign off in `uat-signoff.md`.

| Role | Checklist Sections | Sign-Off Required |
|------|-------------------|-------------------|
| Client (End User) | Sections 1.1-1.7, 6.1-6.8 | ✅ Required |
| Provider (Cleaner) | Sections 2.1-2.6, 6.1-6.8 | ✅ Required |
| Courier (Delivery) | Sections 3.1-3.6, 6.1-6.8 | ✅ Required |
| Seller (Merchant) | Sections 4.1-4.5, 6.1-6.8 | ✅ Required |
| Admin (Operations) | Sections 5.1-5.8, 6.1-6.8 | ✅ Required |
| QA Lead | All sections + 6.1-6.8 | ✅ Required |
| Product Owner | All sections | ✅ Required |
| Engineering Lead | Sections 6.1-6.8 | ✅ Required |

---

## 8. Bug Reporting During UAT

All bugs found during UAT must be logged using the **Bug Triage Template** (`bug-triage.md`) with severity classification (P0-P3) and submitted via the feedback form (`uat-feedback-form.md`).

### UAT Exit Criteria
- [ ] All P0 bugs fixed and verified
- [ ] All P1 bugs fixed or have approved workaround with fix scheduled
- [ ] All P2 bugs have fix scheduled for post-launch patch
- [ ] All P3 bugs logged for backlog
- [ ] All stakeholder sign-offs collected in `uat-signoff.md`
- [ ] Go/No-Go decision documented in `uat-signoff.md`