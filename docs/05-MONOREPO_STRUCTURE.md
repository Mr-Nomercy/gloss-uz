# Monorepo Structure — Gloss Ecosystem

## Melos Managed Monorepo

Uses [Melos](https://melos.invertase.dev) for package management, versioning, and CI.

```
gloss-ecosystem/
│
├── melos.yaml                          # Melos configuration
├── pubspec.yaml                        # Root workspace pubspec
├── .github/
│   └── workflows/
│       ├── ci.yml                      # Lint, test, build all packages
│       ├── deploy-backend.yml          # Docker build & push backend
│       └── deploy-apps.yml             # Flutter build & deploy (future)
│
├── docker-compose.yml                  # Local dev: PG, Redis, MinIO, Backend
├── .env.example                        # Environment variables template
├── .gitignore
├── README.md                           # Project overview, setup instructions
│
├── docs/                               # Architecture documents
│   ├── 01-ARCHITECTURE.md
│   ├── 02-DATABASE_SCHEMA.prisma
│   ├── 03-API_CONTRACTS.openapi.yaml
│   ├── 04-RBAC_MATRIX.md
│   ├── 05-MONOREPO_STRUCTURE.md
│   ├── 06-FLUTTER_ARCHITECTURE.md
│   ├── 07-REALTIME_ARCH.md
│   ├── 08-DEV_GUIDE.md
│   └── 09-IMPLEMENTATION_PLAN.md
│
├── packages/
│   │
│   ├── backend/                        # 🟢 NestJS API Server
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── tsconfig.build.json
│   │   ├── nest-cli.json
│   │   ├── .env
│   │   └── src/
│   │       ├── main.ts
│   │       ├── app.module.ts
│   │       ├── app.controller.ts
│   │       │
│   │       ├── prisma/
│   │       │   ├── prisma.module.ts
│   │       │   ├── prisma.service.ts
│   │       │   └── schema.prisma       # Source of truth DB schema
│   │       │
│   │       ├── common/
│   │       │   ├── decorators/
│   │       │   │   ├── current-user.decorator.ts
│   │       │   │   ├── roles.decorator.ts
│   │       │   │   ├── permissions.decorator.ts
│   │       │   │   └── public.decorator.ts
│   │       │   ├── guards/
│   │       │   │   ├── jwt-auth.guard.ts
│   │       │   │   ├── roles.guard.ts
│   │       │   │   └── permissions.guard.ts
│   │       │   ├── interceptors/
│   │       │   │   ├── transform.interceptor.ts
│   │       │   │   ├── logging.interceptor.ts
│   │       │   │   └── audit-log.interceptor.ts
│   │       │   ├── filters/
│   │       │   │   └── http-exception.filter.ts
│   │       │   ├── pipes/
│   │       │   │   └── validation.pipe.ts
│   │       │   └── utils/
│   │       │       ├── logger.ts
│   │       │       ├── helpers.ts
│   │       │       └── types.ts
│   │       │
│   │       ├── auth/
│   │       │   ├── auth.module.ts
│   │       │   ├── auth.controller.ts
│   │       │   ├── auth.service.ts
│   │       │   ├── strategies/
│   │       │   │   ├── jwt.strategy.ts
│   │       │   │   └── refresh-token.strategy.ts
│   │       │   └── dto/
│   │       │       ├── login.dto.ts
│   │       │       ├── register.dto.ts
│   │       │       ├── refresh.dto.ts
│   │       │       └── verify-phone.dto.ts
│   │       │
│   │       ├── users/
│   │       │   ├── users.module.ts
│   │       │   ├── users.controller.ts
│   │       │   ├── users.service.ts
│   │       │   └── dto/
│   │       │       ├── create-user.dto.ts
│   │       │       ├── update-user.dto.ts
│   │       │       └── user-response.dto.ts
│   │       │
│   │       ├── roles/
│   │       │   ├── roles.module.ts
│   │       │   ├── roles.controller.ts
│   │       │   ├── roles.service.ts
│   │       │   └── dto/
│   │       │       ├── create-role.dto.ts
│   │       │       └── assign-role.dto.ts
│   │       │
│   │       ├── addresses/
│   │       │   ├── addresses.module.ts
│   │       │   ├── addresses.controller.ts
│   │       │   ├── addresses.service.ts
│   │       │   └── dto/
│   │       │       └── address.dto.ts
│   │       │
│   │       ├── services/
│   │       │   ├── services.module.ts
│   │       │   ├── services.controller.ts
│   │       │   ├── services.service.ts
│   │       │   ├── service-types.controller.ts
│   │       │   ├── pricings.service.ts
│   │       │   └── dto/
│   │       │       ├── service-response.dto.ts
│   │       │       └── price-calc.dto.ts
│   │       │
│   │       ├── products/
│   │       │   ├── products.module.ts
│   │       │   ├── products.controller.ts
│   │       │   ├── products.service.ts
│   │       │   ├── categories.controller.ts
│   │       │   └── dto/
│   │       │       ├── create-product.dto.ts
│   │       │       ├── update-product.dto.ts
│   │       │       └── product-response.dto.ts
│   │       │
│   │       ├── orders/
│   │       │   ├── orders.module.ts
│   │       │   ├── orders.controller.ts
│   │       │   ├── orders.service.ts
│   │       │   ├── orders.gateway.ts     # WebSocket
│   │       │   ├── assignment.service.ts # Courier/Provider assignment
│   │       │   └── dto/
│   │       │       ├── create-order.dto.ts
│   │       │       ├── order-response.dto.ts
│   │       │       └── update-status.dto.ts
│   │       │
│   │       ├── tracking/
│   │       │   ├── tracking.module.ts
│   │       │   ├── tracking.controller.ts
│   │       │   ├── tracking.service.ts
│   │       │   ├── tracking.gateway.ts   # WebSocket (Yandex-style)
│   │       │   └── dto/
│   │       │       └── location-update.dto.ts
│   │       │
│   │       ├── chat/
│   │       │   ├── chat.module.ts
│   │       │   ├── chat.controller.ts
│   │       │   ├── chat.service.ts
│   │       │   ├── chat.gateway.ts       # WebSocket
│   │       │   └── dto/
│   │       │       ├── send-message.dto.ts
│   │       │       └── chat-response.dto.ts
│   │       │
│   │       ├── payments/
│   │       │   ├── payments.module.ts
│   │       │   ├── payments.controller.ts
│   │       │   ├── payments.service.ts
│   │       │   ├── click/
│   │       │   │   ├── click.service.ts
│   │       │   │   └── click-webhook.controller.ts
│   │       │   ├── payme/
│   │       │   │   ├── payme.service.ts
│   │       │   │   └── payme-webhook.controller.ts
│   │       │   └── dto/
│   │       │       ├── init-payment.dto.ts
│   │       │       └── payment-response.dto.ts
│   │       │
│   │       ├── kyc/
│   │       │   ├── kyc.module.ts
│   │       │   ├── kyc.controller.ts
│   │       │   ├── kyc.service.ts
│   │       │   └── dto/
│   │       │       ├── submit-kyc.dto.ts
│   │       │       └── review-kyc.dto.ts
│   │       │
│   │       ├── sellers/
│   │       │   ├── sellers.module.ts
│   │       │   ├── sellers.controller.ts
│   │       │   ├── sellers.service.ts
│   │       │   ├── payouts.service.ts
│   │       │   └── dto/
│   │       │       └── seller-profile.dto.ts
│   │       │
│   │       ├── providers/
│   │       │   ├── providers.module.ts
│   │       │   ├── providers.controller.ts
│   │       │   ├── providers.service.ts
│   │       │   └── dto/
│   │       │       └── provider-profile.dto.ts
│   │       │
│   │       ├── couriers/
│   │       │   ├── couriers.module.ts
│   │       │   ├── couriers.controller.ts
│   │       │   ├── couriers.service.ts
│   │       │   └── dto/
│   │       │       └── courier.dto.ts
│   │       │
│   │       ├── reviews/
│   │       │   ├── reviews.module.ts
│   │       │   ├── reviews.controller.ts
│   │       │   ├── reviews.service.ts
│   │       │   └── dto/
│   │       │       └── create-review.dto.ts
│   │       │
│   │       ├── notifications/
│   │       │   ├── notifications.module.ts
│   │       │   ├── notifications.controller.ts
│   │       │   ├── notifications.service.ts
│   │       │   ├── fcm.service.ts
│   │       │   └── dto/
│   │       │       └── notification-response.dto.ts
│   │       │
│   │       ├── files/
│   │       │   ├── files.module.ts
│   │       │   ├── files.controller.ts
│   │       │   ├── files.service.ts
│   │       │   └── minio/
│   │       │       └── minio.service.ts
│   │       │
│   │       ├── analytics/
│   │       │   ├── analytics.module.ts
│   │       │   ├── analytics.controller.ts
│   │       │   └── analytics.service.ts
│   │       │
│   │       ├── admin/
│   │       │   ├── admin.module.ts
│   │       │   ├── admin.controller.ts
│   │       │   └── admin.service.ts
│   │       │
│   │       └── config/
│   │           ├── config.module.ts
│   │           └── config.service.ts
│   │
│   ├── shared/
│   │   ├── models/                     # Dart: Freezed data classes
│   │   │   ├── lib/
│   │   │   │   ├── models/
│   │   │   │   │   ├── user.dart
│   │   │   │   │   ├── role.dart
│   │   │   │   │   ├── address.dart
│   │   │   │   │   ├── service_type.dart
│   │   │   │   │   ├── service.dart
│   │   │   │   │   ├── category.dart
│   │   │   │   │   ├── product.dart
│   │   │   │   │   ├── product_variant.dart
│   │   │   │   │   ├── order.dart
│   │   │   │   │   ├── order_item.dart
│   │   │   │   │   ├── tracking.dart
│   │   │   │   │   ├── location_point.dart
│   │   │   │   │   ├── chat.dart
│   │   │   │   │   ├── message.dart
│   │   │   │   │   ├── payment.dart
│   │   │   │   │   ├── kyc_document.dart
│   │   │   │   │   ├── seller_profile.dart
│   │   │   │   │   ├── review.dart
│   │   │   │   │   └── notification.dart
│   │   │   │   └── models.dart         # Barrel export
│   │   │   ├── pubspec.yaml
│   │   │   └── build.yaml              # Freezed config
│   │   │
│   │   ├── api-client/                 # Dart: Dio + Retrofit generated client
│   │   │   ├── lib/
│   │   │   │   ├── api/
│   │   │   │   │   ├── auth_api.dart
│   │   │   │   │   ├── user_api.dart
│   │   │   │   │   ├── address_api.dart
│   │   │   │   │   ├── service_api.dart
│   │   │   │   │   ├── product_api.dart
│   │   │   │   │   ├── order_api.dart
│   │   │   │   │   ├── tracking_api.dart
│   │   │   │   │   ├── chat_api.dart
│   │   │   │   │   ├── payment_api.dart
│   │   │   │   │   ├── kyc_api.dart
│   │   │   │   │   ├── seller_api.dart
│   │   │   │   │   ├── review_api.dart
│   │   │   │   │   ├── notification_api.dart
│   │   │   │   │   └── file_api.dart
│   │   │   │   └── api_client.dart     # Dio instance, interceptors
│   │   │   ├── pubspec.yaml
│   │   │   └── build.yaml              # Retrofit config
│   │   │
│   │   └── constants/                  # Dart: Shared constants
│   │       ├── lib/
│   │       │   ├── enums/
│   │       │   │   ├── order_status.dart
│   │       │   │   ├── payment_status.dart
│   │       │   │   ├── order_type.dart
│   │       │   │   ├── tracking_status.dart
│   │       │   │   ├── chat_type.dart
│   │       │   │   ├── message_type.dart
│   │       │   │   ├── kyc_status.dart
│   │       │   │   └── notification_type.dart
│   │       │   ├── app_constants.dart  # API_URL, pagination defaults
│   │       │   └── error_codes.dart
│   │       └── pubspec.yaml
│   │
│   └── ui-kit/                         # Dart: Shared Flutter widgets
│       ├── lib/
│       │   ├── theme/
│       │   │   ├── app_theme.dart
│       │   │   ├── app_colors.dart
│       │   │   ├── app_typography.dart
│       │   │   └── app_dimensions.dart
│       │   ├── widgets/
│       │   │   ├── gloss_button.dart
│       │   │   ├── gloss_text_field.dart
│       │   │   ├── gloss_card.dart
│       │   │   ├── gloss_loading.dart
│       │   │   ├── gloss_error.dart
│       │   │   ├── gloss_empty.dart
│       │   │   ├── gloss_app_bar.dart
│       │   │   ├── gloss_bottom_sheet.dart
│       │   │   ├── gloss_badge.dart
│       │   │   ├── gloss_rating.dart
│       │   │   ├── gloss_image.dart
│       │   │   ├── gloss_chip.dart
│       │   │   ├── gloss_slider.dart
│       │   │   ├── gloss_dialog.dart
│       │   │   └── gloss_snackbar.dart
│       │   ├── l10n/                   # i18n
│       │   │   ├── app_localizations.dart
│       │   │   ├── intl_uz.arb
│       │   │   ├── intl_ru.arb
│       │   │   └── intl_en.arb
│       │   └── ui_kit.dart             # Barrel export
│       └── pubspec.yaml
│
├── apps/
│   ├── gloss_client/                   # 📱 Flutter: Client App
│   │   ├── pubspec.yaml
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   ├── app.dart                # MaterialApp, router, theme
│   │   │   │
│   │   │   ├── core/
│   │   │   │   ├── config/
│   │   │   │   │   ├── env_config.dart
│   │   │   │   │   ├── app_routes.dart      # GoRouter
│   │   │   │   │   └── app_theme.dart
│   │   │   │   ├── network/
│   │   │   │   │   ├── api_client_provider.dart
│   │   │   │   │   └── web_socket_provider.dart
│   │   │   │   ├── storage/
│   │   │   │   │   ├── auth_storage.dart
│   │   │   │   │   └── local_db.dart         # Drift DB
│   │   │   │   └── utils/
│   │   │   │
│   │   │   ├── features/
│   │   │   │   ├── auth/
│   │   │   │   │   ├── data/                 # datasources, repos
│   │   │   │   │   ├── domain/               # usecases
│   │   │   │   │   └── presentation/         # providers, pages, widgets
│   │   │   │   │       ├── providers/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   ├── login_page.dart
│   │   │   │   │       │   ├── register_page.dart
│   │   │   │   │       │   └── verify_phone_page.dart
│   │   │   │   │       └── widgets/
│   │   │   │   │
│   │   │   │   ├── home/                    # Home screen
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   └── home_page.dart
│   │   │   │   │       └── widgets/
│   │   │   │   │
│   │   │   │   ├── services/                # Cleaning services
│   │   │   │   │   ├── data/
│   │   │   │   │   ├── domain/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   ├── services_list_page.dart
│   │   │   │   │       │   ├── service_detail_page.dart
│   │   │   │   │       │   └── booking_page.dart
│   │   │   │   │       └── widgets/
│   │   │   │   │
│   │   │   │   ├── products/               # Market products
│   │   │   │   │   ├── data/
│   │   │   │   │   ├── domain/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   ├── products_list_page.dart
│   │   │   │   │       │   ├── product_detail_page.dart
│   │   │   │   │       │   └── category_page.dart
│   │   │   │   │       └── widgets/
│   │   │   │   │
│   │   │   │   ├── cart/                   # Shopping cart
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   └── cart_page.dart
│   │   │   │   │       └── providers/
│   │   │   │   │           └── cart_provider.dart
│   │   │   │   │
│   │   │   │   ├── checkout/
│   │   │   │   │   ├── payment/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   ├── checkout_page.dart
│   │   │   │   │       │   └── payment_page.dart
│   │   │   │   │       └── widgets/
│   │   │   │   │
│   │   │   │   ├── orders/
│   │   │   │   │   ├── data/
│   │   │   │   │   ├── domain/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   ├── orders_list_page.dart
│   │   │   │   │       │   ├── order_detail_page.dart
│   │   │   │   │       │   └── order_tracking_page.dart
│   │   │   │   │       └── providers/
│   │   │   │   │
│   │   │   │   ├── tracking/               # Yandex MapKit tracking
│   │   │   │   │   ├── data/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   └── live_tracking_page.dart
│   │   │   │   │       └── widgets/
│   │   │   │   │           ├── courier_map.dart
│   │   │   │   │           └── eta_widget.dart
│   │   │   │   │
│   │   │   │   ├── chat/
│   │   │   │   │   ├── data/
│   │   │   │   │   ├── domain/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   ├── chats_list_page.dart
│   │   │   │   │       │   └── chat_page.dart
│   │   │   │   │       └── providers/
│   │   │   │   │
│   │   │   │   ├── notifications/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       └── providers/
│   │   │   │   │
│   │   │   │   └── profile/
│   │   │   │       └── presentation/
│   │   │   │           ├── pages/
│   │   │   │           │   ├── profile_page.dart
│   │   │   │           │   ├── edit_profile_page.dart
│   │   │   │           │   └── addresses_page.dart
│   │   │   │           └── widgets/
│   │   │   │
│   │   │   └── l10n/                       # i18n
│   │   │       ├── intl_uz.arb
│   │   │       ├── intl_ru.arb
│   │   │       └── intl_en.arb
│   │   │
│   │   └── test/
│   │       ├── unit/
│   │       ├── widget/
│   │       └── integration/
│   │
│   ├── gloss_provider_deliver/             # 📱 Flutter: Provider + Courier
│   │   ├── pubspec.yaml
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   ├── app.dart
│   │   │   │
│   │   │   ├── core/
│   │   │   │   ├── config/
│   │   │   │   ├── network/
│   │   │   │   ├── storage/
│   │   │   │   └── utils/
│   │   │   │
│   │   │   ├── features/
│   │   │   │   ├── auth/
│   │   │   │   ├── role_switch/            # Role switcher (provider/courier)
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── providers/
│   │   │   │   │       │   └── role_provider.dart
│   │   │   │   │       └── widgets/
│   │   │   │   │           └── role_switch_widget.dart
│   │   │   │   │
│   │   │   │   ├── home/                   # Role-based dashboard
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       └── widgets/
│   │   │   │   │
│   │   │   │   ├── orders/                 # Order feed
│   │   │   │   │   ├── data/
│   │   │   │   │   ├── domain/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   ├── available_orders_page.dart
│   │   │   │   │       │   ├── active_order_page.dart
│   │   │   │   │       │   └── order_history_page.dart
│   │   │   │   │       └── widgets/
│   │   │   │   │           ├── order_card.dart
│   │   │   │   │           └── accept_button.dart
│   │   │   │   │
│   │   │   │   ├── tracking/               # Courier: location sharing
│   │   │   │   │   ├── data/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   └── navigation_page.dart
│   │   │   │   │       └── widgets/
│   │   │   │   │           ├── route_map.dart
│   │   │   │   │           └── proof_delivery_widget.dart
│   │   │   │   │
│   │   │   │   ├── earnings/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── pages/
│   │   │   │   │       │   └── earnings_page.dart
│   │   │   │   │       └── providers/
│   │   │   │   │
│   │   │   │   ├── chat/
│   │   │   │   │   └── ...
│   │   │   │   │
│   │   │   │   ├── profile/
│   │   │   │   │   └── ...
│   │   │   │   │
│   │   │   │   └── kyc/                    # Provider/Courier KYC
│   │   │   │       └── presentation/
│   │   │   │           ├── pages/
│   │   │   │           │   └── kyc_page.dart
│   │   │   │           └── widgets/
│   │   │   │
│   │   │   └── l10n/
│   │   │
│   │   └── test/
│   │
│   └── gloss_seller/                      # 📱 Flutter: Seller App
│       ├── pubspec.yaml
│       ├── lib/
│       │   ├── main.dart
│       │   ├── app.dart
│       │   │
│       │   ├── core/
│       │   │   ├── config/
│       │   │   ├── network/
│       │   │   ├── storage/
│       │   │   └── utils/
│       │   │
│       │   ├── features/
│       │   │   ├── auth/
│       │   │   ├── dashboard/              # Seller dashboard
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       └── providers/
│       │   │   │
│       │   │   ├── products/               # CRUD products
│       │   │   │   ├── data/
│       │   │   │   ├── domain/
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       │   ├── products_list_page.dart
│       │   │   │       │   ├── add_product_page.dart
│       │   │   │       │   └── edit_product_page.dart
│       │   │   │       └── widgets/
│       │   │   │
│       │   │   ├── orders/                 # Seller's orders
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       │   └── seller_orders_page.dart
│       │   │   │       └── widgets/
│       │   │   │
│       │   │   ├── kyc/                    # Seller KYC
│       │   │   │   └── ...
│       │   │   │
│       │   │   ├── earnings/               # Sales, payouts
│       │   │   │   ├── pages/
│       │   │   │   │   ├── earnings_page.dart
│       │   │   │   │   └── payout_history_page.dart
│       │   │   │   └── providers/
│       │   │   │
│       │   │   ├── analytics/
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       │   └── analytics_page.dart
│       │   │   │       └── widgets/
│       │   │   │           ├── sales_chart.dart
│       │   │   │           └── stat_card.dart
│       │   │   │
│       │   │   ├── chat/
│       │   │   │   └── ...
│       │   │   │
│       │   │   └── profile/
│       │   │       └── presentation/
│       │   │           ├── pages/
│       │   │           │   └── seller_profile_page.dart
│       │   │           └── widgets/
│       │   │
│       │   └── l10n/
│       │
│       └── test/
│
└── scripts/
    ├── setup.sh                            # Initial setup script
    ├── generate-client.sh                  # Generate Dart client from OpenAPI
    └── seed.sh                             # Seed database
```

## Melos Configuration (melos.yaml)

```yaml
name: gloss_ecosystem
packages:
  - packages/**
  - apps/**

scripts:
  # Backend
  backend:dev: melos run --scope=backend -- dev
  backend:build: melos run --scope=backend -- build
  backend:lint: melos run --scope=backend -- lint
  backend:test: melos run --scope=backend -- test
  backend:migrate: melos run --scope=backend -- migrate
  backend:seed: melos run --scope=backend -- seed

  # Flutter apps
  client:dev: melos run --scope=gloss_client -- dev
  provider:dev: melos run --scope=gloss_provider_deliver -- dev
  seller:dev: melos run --scope=gloss_seller -- dev

  # Shared
  shared:build: melos run --scope=shared/models -- build
  shared:lint: melos run --scope=shared -- lint
  gen:client: melos run --scope=shared/api-client -- generate

  # All
  lint:all: melos exec -- flutter analyze
  test:all: melos exec -- flutter test
  format: melos exec -- dart format .
  clean: melos clean
  bootstrap: melos bootstrap

  # CI
  ci:check: melos run lint:all && melos run test:all

ide:
  intellij:
    enabled: true
```

## Docker Compose (docker-compose.yml)

```yaml
version: "3.8"

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: gloss
      POSTGRES_PASSWORD: gloss_secret
      POSTGRES_DB: gloss_ecosystem
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  minio:
    image: minio/minio
    command: server /data --console-address ":9001"
    ports:
      - "9000:9000"   # API
      - "9001:9001"   # Console
    environment:
      MINIO_ROOT_USER: gloss
      MINIO_ROOT_PASSWORD: gloss_minio
    volumes:
      - minio_data:/data

  backend:
    build: ./packages/backend
    ports:
      - "3000:3000"
    depends_on:
      - postgres
      - redis
      - minio
    environment:
      DATABASE_URL: postgresql://gloss:gloss_secret@postgres:5432/gloss_ecosystem
      REDIS_URL: redis://redis:6379
      MINIO_ENDPOINT: minio:9000
      JWT_SECRET: dev-secret-change-in-production

volumes:
  pgdata:
  minio_data:
```

## Dependency Graph

```
backend (NestJS + Prisma)
    │
    ├── shared/models (Dart Freezed)
    │       │
    │       ├── shared/api-client (Dio + Retrofit)
    │       │       │
    │       │       ├── gloss_client
    │       │       ├── gloss_provider_deliver
    │       │       └── gloss_seller
    │       │
    │       └── (used by all apps for type-safety)
    │
    └── shared/constants (Enums, app constants)
            │
            └── shared/ui-kit (Theme, Widgets)
                    │
                    └── All Flutter apps
```

## Key Rules

1. **No circular dependencies**: `models` is leaf package
2. **Code generation**:
   - Prisma schema → NestJS types (auto)
   - OpenAPI spec → Dart Retrofit client + Freezed models (build_runner)
3. **Each app is independent**: Can be built, tested, and deployed separately
4. **Shared packages are versioned**: Semantic versioning via Melos
