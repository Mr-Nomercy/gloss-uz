# Flutter Architecture — Gloss Ecosystem

## Architecture Pattern

**Feature-first + Clean Architecture layers within each feature.**

```
┌─────────────────────────────────────────────────┐
│                  PRESENTATION                     │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  │
│  │   Pages    │  │  Widgets   │  │  Providers  │  │
│  │ (Screens)  │  │ (Reusable) │  │ (State Mgmt)│  │
│  └──────┬─────┘  └─────┬──────┘  └─────┬──────┘  │
│         │              │               │          │
│         └──────────────┼───────────────┘          │
├────────────────────────┼─────────────────────────┤
│                        ▼                          │
│                  ┌────────────┐                   │
│                  │  DOMAIN    │                   │
│                  │ (UseCases) │                   │
│                  │ (Entities) │                   │
│                  │ (Repositor)│                   │
│                  └──────┬─────┘                   │
├─────────────────────────┼────────────────────────┤
│                         ▼                         │
│                    ┌──────────┐                   │
│                    │   DATA   │                   │
│                    │ ┌──────┐  │  ┌───────────┐   │
│                    │ │ API  │  │  │ Local DB  │   │
│                    │ │(Dio) │  │  │ (Drift)   │   │
│                    │ └──────┘  │  └───────────┘   │
│                    └──────────┘                   │
└─────────────────────────────────────────────────┘
```

## State Management: Riverpod + Freezed

### Key Concepts

| Concept | Library | Purpose |
|---------|---------|---------|
| Providers | `flutter_riverpod` | Dependency injection + state |
| Codegen | `riverpod_annotation` | Auto-generate providers |
| Data classes | `freezed` | Immutable models, JSON serialization |
| Unions | `freezed` | Sealed classes for states |
| Network | `dio + retrofit` | HTTP client, codegen |
| Local DB | `drift` | SQLite offline-first cache |
| Routing | `go_router` | Declarative routing |
| Localization | `flutter_localizations + ARB` | i18n (uz/ru/en) |
| DI | Riverpod | Built-in DI |

### State Types (Freezed Union)

Every feature has a state union:

```dart
@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
  const factory OrderState.loaded(List<Order> orders) = _Loaded;
  const factory OrderState.error(String message) = _Error;
}
```

### Provider Hierarchy

```
┌────────────────────────────────────────────────┐
│                  app_providers                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────────────┐ │
│  │  Auth    │ │  Config  │ │  WebSocket       │ │
│  │ Provider │ │ Provider │ │  Connection      │ │
│  └────┬─────┘ └────┬─────┘ └────────┬─────────┘ │
│       │            │                │           │
└───────┼────────────┼────────────────┼───────────┘
        │            │                │
┌───────▼────────────▼────────────────▼───────────┐
│              feature_providers                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐        │
│  │  Orders  │ │ Products │ │ Tracking │        │
│  │ Provider │ │ Provider │ │ Provider │        │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘        │
│       │            │            │              │
└───────┼────────────┼────────────┼──────────────┘
        │            │            │
┌───────▼────────────▼────────────▼──────────────┐
│              repository_providers               │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │  Orders  │ │ Products │ │  Chat    │       │
│  │  Repo    │ │  Repo    │ │  Repo    │       │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘       │
│       │            │            │              │
└───────┼────────────┼────────────┼──────────────┘
        │            │            │
┌───────▼────────────▼────────────▼──────────────┐
│               data_source_providers             │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │  API     │ │  Drift   │ │  WS      │       │
│  │ Client   │ │  DB      │ │  Client  │       │
│  └──────────┘ └──────────┘ └──────────┘       │
└────────────────────────────────────────────────┘
```

## Directory Structure per Feature

```
features/
└── orders/
    ├── data/
    │   ├── datasources/
    │   │   ├── orders_remote_source.dart     # API calls
    │   │   └── orders_local_source.dart      # Drift cache
    │   ├── repositories/
    │   │   └── orders_repository_impl.dart   # Implements domain repo
    │   └── models/
    │       └── order_dto.dart                # DTO from API
    │
    ├── domain/
    │   ├── entities/
    │   │   └── order.dart                    # Domain entity
    │   ├── repositories/
    │   │   └── i_orders_repository.dart      # Abstract repo
    │   └── usecases/
    │       ├── get_orders.dart
    │       ├── create_order.dart
    │       └── cancel_order.dart
    │
    └── presentation/
        ├── providers/
        │   ├── orders_provider.dart          # StateNotifierProvider
        │   ├── current_order_provider.dart
        │   └── order_form_provider.dart
        ├── pages/
        │   ├── orders_list_page.dart
        │   ├── order_detail_page.dart
        │   └── order_tracking_page.dart
        └── widgets/
            ├── order_card.dart
            ├── order_status_badge.dart
            └── order_timeline.dart
```

## Build Flavors

Three flavors per app: development, staging, production

```
gloss-ecosystem/apps/gloss_client/
├── lib/
│   ├── main_development.dart
│   ├── main_staging.dart
│   └── main_production.dart
├── android/
│   └── app/
│       ├── src/
│       │   ├── development/  # dev app name, icon, MapKit key
│       │   ├── staging/      # staging config
│       │   └── production/   # production keystore, signing
│       └── build.gradle      # flavor dimensions
└── ios/
    ├── Config/
    │   ├── Development.xcconfig
    │   ├── Staging.xcconfig
    │   └── Production.xcconfig
    └── Runner.xcodeproj     # scheme per flavor
```

- Use `--dart-define-from-file=flavor_config.json` for API URLs, MapKit keys, FCM project IDs
- Use `flutter_flavor` or `envied` package for compile-time environment variables
- Each flavor has separate Firebase project (dev/staging/prod)
- Code signing: development = debug keystore, staging = ad-hoc, production = App Store/distribution certificate
- CI/CD: `--flavor production --dart-define-from-file=env/production.json`

## Networking Layer

### Dio Configuration

```dart
// shared/api-client/lib/api_client.dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.apiUrl,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 30),
  ));

  dio.interceptors.addAll([
    AuthInterceptor(ref),       // JWT access + refresh
    LoggingInterceptor(),       // Debug logging
    RetryInterceptor(),         // Retry on 5xx
    CacheInterceptor(),         // GET response cache
  ]);

  return dio;
});
```

### Auth Interceptor

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = ref.read(authStorageProvider).getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await ref.read(authProvider).refreshToken();
      if (refreshed) {
        // Retry with new token
        return handler.resolve(await _retry(err.requestOptions));
      }
      // Force logout
      ref.read(authProvider).logout();
    }
    handler.next(err);
  }
}
```

### Retrofit API Definition

```dart
@RestApi(baseUrl: '')
abstract class OrderApi {
  factory OrderApi(Dio dio) = _OrderApi;

  @GET('/orders')
  Future<ApiResponse<List<OrderDto>>> getOrders({
    @Query('status') String? status,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @POST('/orders')
  Future<ApiResponse<OrderDto>> createOrder(@Body() CreateOrderDto body);

  @GET('/orders/{id}')
  Future<ApiResponse<OrderDto>> getOrder(@Path('id') String id);

  @POST('/orders/{id}/cancel')
  Future<ApiResponse<OrderDto>> cancelOrder(
    @Path('id') String id,
    @Body() CancelOrderDto body,
  );
}
```

## WebSocket Integration

```dart
// core/network/web_socket_provider.dart
final webSocketProvider = Provider<SocketClient>((ref) {
  final dio = ref.read(dioProvider);
  final token = ref.read(authStorageProvider).getAccessToken();

  return SocketClient(
    '${AppConstants.wsUrl}/ws',
    options: SocketOptions(
      auth: {'token': token},
      autoConnect: true,
      reconnectAttempts: 10,
      reconnectDelay: Duration(seconds: 2),
    ),
  );
});
```

### Heartbeat & Reconnection
- Heartbeat: Socket.io built-in pingInterval=25000ms, pingTimeout=60000ms
- On reconnect: re-subscribe to all active rooms
- Offline message queue: pendingMessages List<Map> — replay on reconnect
- Connectivity state: Riverpod provider `wsConnectionProvider` emits ConnectionState

## Image & Camera Integration

### Packages
- `image_picker` for gallery selection
- `camera` for custom camera overlay (KYC liveness check, delivery proof)
- `flutter_image_compress` for JPEG compression (max 2MB per image)
- `exif` or `flutter_exif_rotation` for EXIF data stripping on upload

### Use Cases
1. **KYC Documents**: passport, selfie, bank card, INN, license, certificate
   - Max 5 images per KYC submission
   - Auto-crop guide overlay for document boundaries
   - Face detection for selfie quality check
2. **Delivery Proof**: photo captured at delivery location
   - Geo-tagged with delivery coordinates
   - Timestamp overlay for non-repudiation
3. **Product Images**: up to 10 images per product
   - Aspect ratio 1:1, minimum 800×800px
   - Auto-thumbnail generation via server
4. **Chat Images**: in-message image sharing
   - Max 5MB per image
   - Optional blur/redaction tool for privacy

### Offline Queue
- Images captured offline stored in Drift blob cache
- Uploaded when connection restored (priority queue: KYC > delivery proof > product > chat)
- Conflict: if same image uploaded from two devices, keep first upload

## Offline-First Strategy (Drift)

### Drift DB Schema

```dart
// core/storage/local_db.dart
@DriftDatabase(tables: [
  Auth,
  Addresses,
  Orders,
  OrderItems,
  TrackingPoints,
  Messages,
  Chats,
  CachedProducts,
  CachedServices,
  Categories,
  Notifications,
  PendingSyncQueue,
])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  // Sync queue for offline mutations:
  // createOrder, updateAddress, cancelOrder, locationPoint,
  // createProduct, updateProduct, updateAvailability, chatMessage, sendReview
  Future<void> addToSyncQueue(SyncAction action) async {
    await into(syncQueue).insert(action);
  }

  Future<void> processSyncQueue() async {
    final actions = await select(syncQueue).get();
    for (final action in actions) {
      try {
        await _executeSync(action);
        await delete(syncQueue).delete(action);
      } catch (e) {
        // Mark as failed, retry later
        await update(syncQueue).write(SyncQueueCompanion(
          retryCount: Value(action.retryCount + 1),
          lastError: Value(e.toString()),
        ));
      }
    }
  }
}
```

### Repository Pattern with Offline Support

```dart
class OrdersRepositoryImpl implements IOrdersRepository {
  final OrderApi _api;
  final LocalDatabase _db;

  @override
  Future<List<Order>> getOrders(OrderFilter filter) async {
    try {
      // 1. Try remote
      final response = await _api.getOrders(
        status: filter.status,
        page: filter.page,
        limit: filter.limit,
      );
      // 2. Cache locally
      await _db.orders.insertAll(response.data);
      return response.data.toDomain();
    } on DioException catch (_) {
      // 3. Fallback to local
      final cached = await _db.orders.getAll();
      return cached.toDomain();
    }
  }
}
```

## Secure Storage

```dart
// Use flutter_secure_storage for all token storage
final secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOSOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);

// Never store tokens in shared_preferences
// Tokens: accessToken (15min), refreshToken (7d) — both in secure storage only
```

## Theme & Design System (ui-kit)

```dart
// ui-kit/lib/theme/app_colors.dart
class AppColors {
  static const primary = Color(0xFF6C63FF);
  static const secondary = Color(0xFF00BFA6);
  static const accent = Color(0xFFFF6B6B);

  // Semantic colors
  static const success = Color(0xFF00C853);
  static const warning = Color(0xFFFFD600);
  static const error = Color(0xFFFF1744);

  // Status colors
  static const pending = Color(0xFFFFA000);
  static const inProgress = Color(0xFF2979FF);
  static const completed = Color(0xFF00C853);
  static const cancelled = Color(0xFF9E9E9E);
}

// ui-kit/lib/theme/app_typography.dart
class AppTypography {
  static const heading1 = TextStyle(fontSize: 24, fontWeight: FontWeight.w700);
  static const heading2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const body1 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const body2 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  static const button = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
}
```

## Theme System
- Light theme defined in ui-kit (AppColors, AppTypography)
- Dark theme designed from the start in AppColors.dark
- `ThemeMode` persisted in shared preferences, default = system
- All GlossCard, GlossTextField, GlossButton etc. support both themes
- High-contrast mode for accessibility
- Theme switch available in Settings screen

## Routing (GoRouter)

```dart
final router = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final isLoggedIn = ref.read(authProvider).isAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');
    final isOnboardingDone = ref.read(onboardingProvider).isDone;

    if (!isOnboardingDone && !isAuthRoute && state.matchedLocation != '/splash') {
      return '/onboarding';
    }
    if (!isLoggedIn && !isAuthRoute && !isOnboardingDone) {
      return '/auth/login';
    }
    if (isLoggedIn && isAuthRoute) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/auth/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
    GoRoute(
      path: '/',
      builder: (_, __) => const MainShell(), // BottomNavigationBar shell
      routes: [
        GoRoute(path: 'home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: 'orders', builder: (_, __) => const OrdersScreen()),
        GoRoute(path: 'profile', builder: (_, __) => const ProfileScreen()),
        GoRoute(path: 'chat', builder: (_, __) => const ChatListScreen()),
      ],
    ),
    GoRoute(path: '/order/create', builder: (_, __) => const CreateOrderScreen()),
    GoRoute(path: '/order/:id', builder: (_, state) => OrderDetailScreen(id: state.pathParameters['id']!)),
    GoRoute(path: '/tracking/:id', builder: (_, state) => TrackingScreen(id: state.pathParameters['id']!)),
    GoRoute(path: '/chat/:id', builder: (_, state) => ChatScreen(id: state.pathParameters['id']!)),
    GoRoute(path: '/products/:id', builder: (_, state) => ProductDetailScreen(id: state.pathParameters['id']!)),
    GoRoute(path: '/services/:id', builder: (_, state) => ServiceDetailScreen(id: state.pathParameters['id']!)),
    GoRoute(path: '/kyc', builder: (_, __) => const KYCScreen()),
    GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
  ],
);
```

### Nested Navigation
Use `ShellRoute` for bottom navigation structure (Home, Orders, Chat, Profile tabs). Each tab maintains its own navigation stack. The shell rebuilds only on tab switch, child pages are preserved via `AutomaticKeepAliveClientMixin`.

## Yandex MapKit Integration

```dart
// tracking/presentation/widgets/courier_map.dart
class CourierMap extends StatelessWidget {
  final LatLng? courierLocation;
  final LatLng? pickupLocation;
  final LatLng? deliveryLocation;
  final List<LatLng>? routePoints;

  @override
  Widget build(BuildContext context) {
    return YandexMap(
      initialCameraPosition: CameraPosition(
        target: courierLocation ?? deliveryLocation ?? const Point(41.3, 69.2),
        zoom: 14,
      ),
      mapObjects: [
        // Courier marker
        PlacemarkMapObject(
          mapId: const MapObjectId('courier'),
          point: courierLocation!,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('assets/courier_marker.png'),
              scale: 0.5,
            ),
          ),
        ),
        // Pickup marker
        PlacemarkMapObject(
          mapId: const MapObjectId('pickup'),
          point: pickupLocation!,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('assets/pickup_marker.png'),
            ),
          ),
        ),
        // Route polyline
        if (routePoints != null)
          PolylineMapObject(
            mapId: const MapObjectId('route'),
            coordinates: routePoints!,
            strokeColor: AppColors.primary,
            strokeWidth: 4,
          ),
      ],
    );
  }
}
```

## Background Location Tracking

Critical for courier/provider role — continuous location sharing every 3-5 seconds.

### Implementation
- **Android**: Foreground service with persistent notification ("Gloss is running in background")
  - `flutter_background_service` package for foreground service management
  - `requestIgnoreBatteryOptimizations` for Android 6+ Doze mode exemption
  - WakeLock mechanism to prevent CPU sleep during location capture
- **iOS**: `background modes` → `location-updates` capability in Xcode
  - `allowsBackgroundLocationUpdates = true` in CLLocationManager
  - `pausesLocationUpdatesAutomatically = false` for consistent tracking
  - Significant-change location service as fallback for battery saving

### Battery Optimization
- Adaptive interval: 3s when app is in foreground, 10s when backgrounded
- Stop tracking when order is completed or after 5 min idle
- Show persistent notification with tracking status and ETA
- Audio navigation cues via `flutter_tts` for turn-by-turn when navigation is active

### Permissions
- Android: ACCESS_FINE_LOCATION + ACCESS_BACKGROUND_LOCATION + FOREGROUND_SERVICE
- iOS: NSLocationWhenInUseUsageDescription + NSLocationAlwaysAndWhenInUseUsageDescription
- Request: first request "when in use", explain need, then request "always"

## Push Notifications (FCM)

### Android Notification Channels
| Channel ID | Name | Importance | Description |
|------------|------|------------|-------------|
| `orders` | Order Updates | High | Order status, assignment, cancellation |
| `chat` | Messages | High | New chat messages |
| `promos` | Promotions | Default | Discounts, offers |
| `system` | System | Low | Account, KYC updates |

### Per-App FCM Setup
Each app has its own Firebase project and Firebase Cloud Messaging sender ID:
- `gloss_client` — project: gloss-client-xxx
- `gloss_provider_deliver` — project: gloss-provider-xxx
- `gloss_seller` — project: gloss-seller-xxx

FCM data payload routing: each notification includes `target_app: "client|provider|seller"` field for backend routing.

## Guest / Unauthenticated Browsing

The client app allows limited browsing without authentication:
- Browse service categories and pricing
- Browse product catalog (view products, read reviews)
- Search for services and products
- View provider/seller profiles

Authentication is required for:
- Creating orders
- Adding items to cart
- Sending chat messages
- Viewing tracking information
- Writing reviews

Guest users see a "Sign in to order" CTA on product/service detail pages.

## Internationalization
- Languages: Uzbek Latin (uz_Latn), Uzbek Cyrillic (uz_Cyrl), Russian (ru), English (en)
- Number formatting: `NumberFormat.currency(locale: 'uz_UZ', symbol: "so'm")`
- Date formatting: `DateFormat('dd.MM.yyyy', 'uz')` for Uzbek locale
- Plural rules: ICU message syntax via `intl` package with locale-specific plural forms
- LTR only (Uzbek, Russian, English all use LTR script)
- RTL support: not currently needed but MaterialApp has `supportRTL: true` configured

## Error Handling Architecture
- `runZonedGuarded` + `FlutterError.onError` for uncaught exceptions → Sentry
- Riverpod `ProviderObserver` that logs provider errors
- Reusable `GlossErrorWidget` + `GlossRetryWidget` with retry callback
- Connectivity listener (`connectivity_plus`) Riverpod provider — `online`/`offline` state
- Offline banner component shown at top of app when disconnected
- All API errors handled through Dio interceptor → RetryInterceptor + ErrorInterceptor

## Analytics & Crash Reporting
- Sentry for error tracking (Flutter + backend source maps)
- Firebase Analytics for user events
- Event taxonomy defined in shared constants: screen_view, order_placed, payment_completed, etc.
- Opt-out: analytics disabled when user toggles "Share analytics" in Settings
- GDPR compliance: analytics only active after consent obtained

## Accessibility
- WCAG AA compliance target
- All interactive widgets have semantic labels via `Semantics` widget
- Minimum touch target: 48×48dp
- Text scale support (System > Large > Extra Large) tested with MediaQuery textScaleFactor
- Focus management for TalkBack/ VoiceOver navigation
- Color contrast: minimum 4.5:1 for normal text, 3:1 for large text

## App Size Optimization
- Android: ProGuard/R8 code shrinking enabled in release builds
- iOS: App Thinning via asset catalog, bitcode enabled
- Images: WebP format for both Android and iOS, auto-conversion via build pipeline
- Fonts: subset only needed character ranges (Uzbek Cyrillic + Latin)
- Deferred loading: non-critical screens loaded lazily
- Distribution: Android App Bundle (AAB) not APK

## Code Generation Pipeline

```
OpenAPI spec (03-API_CONTRACTS.openapi.yaml)
    │
    ├── NestJS Swagger decorators (manual, sync with spec)
    │
    └── openapi-generator-cli → Dart Dio client
            │
            └── build_runner → Freezed models + Retrofit API
                    │
                    └── Used by all Flutter apps
```

### build.yaml configuration

```yaml
# shared/models/build.yaml
targets:
  $default:
    builders:
      freezed:
        options:
          fromJson: true
          toJson: true
          genericFactory: true

# shared/api-client/build.yaml
targets:
  $default:
    builders:
      retrofit_generator:
        options:
          named_parameters: true
```

## Testing Strategy

| Test Type | Tool | Scope |
|-----------|------|-------|
| Unit | `flutter_test` | ViewModels, UseCases, Repositories |
| Widget | `flutter_test` | Widgets, Pages (with mock providers) |
| Golden | `alchemist` | Visual regression |
| Integration | `integration_test` | Full flows |
| E2E | Patrol | Critical user journeys |

## Performance Guidelines

1. **Lazy loading**: Paginated lists with `ScrollController` + `loadMore()`
2. **Image caching**: `cached_network_image` for product/service images
3. **Debounced search**: 300ms debounce on product/service search
4. **WebSocket batching**: Location updates batched every 3s (not per frame)
5. **Drift indexing**: Indexes on `order_id`, `user_id`, `timestamp`
6. **Provider dispose**: Auto-dispose providers when not watched
7. **Keep-alive**: Active order/tracking providers kept alive

---

## App Flow: Splash → Onboarding → Main

```
App Launch
    │
    ▼
┌────────────┐
│   Splash    │ (2s max: check token, config, refresh if needed)
└──────┬─────┘
       │
       ▼
┌─────────────────────┐
│ First Launch Check  │
├─────────┬───────────┤
│   Yes   │    No     │
│   ▼     │    │      │
│ Onboard │    │      │
│ • Lang  │    │      │
│ (uz/ru) │    │      │
│ • Intro │    │      │
│   (3pp) │    │      │
│ • Perms │    │      │
│ (Loc)   │    │      │
└────┬────┘    │      │
     └─────────┘      │
          │           │
          ▼           ▼
    ┌─────────────────────┐
    │   Auth Check         │
    ├─────────┬───────────┤
    │   Yes   │    No     │
    │   ▼     │    │      │
    │  Home   │    ▼      │
    │         │  Login    │
    └─────────┘  Page     │
               └──────────┘
```

## Deep Linking Strategy

| Scheme | Route | App | Action |
|--------|-------|-----|--------|
| `gloss://orders/{id}` | `/orders/:id` | All | Open order detail |
| `gloss://chat/{id}` | `/chat/:id` | All | Open chat |
| `gloss://products/{slug}` | `/products/:slug` | Client | Open product |
| `gloss://services/{id}` | `/services/:id` | Client | Open service |
| `gloss://profile` | `/profile` | All | Open profile |

Push notification → deep link:
```
FCM data: { deepLink: "gloss://orders/abc123" }
    → GoRouter redirects to /orders/abc123
```

Deep link setup uses the unified GoRouter configuration in the Routing section above.

## Offline Conflict Resolution Strategy

When the app comes back online, Drift sync queue processes pending mutations:

```
Offline Actions Queue (Drift table: sync_queue)
┌──────────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│ Create   │ Update   │ Cancel   │ Location │ Create   │ Update   │ Chat     │
│ Order    │ Address  │ Order    │ Points   │ Product  │ Avail.   │ Message  │
└──────────┴──────────┴──────────┴──────────┴──────────┴──────────┴──────────┘
         │
         ▼
   ┌──────────────┐
   │ Reconnect    │
   │ (WS + HTTP)  │
   └──────┬───────┘
          ▼
   ┌──────────────────────────┐
   │ Process Queue (FIFO)     │
   ├──────────────────────────┤
   │ 1. Read queued actions   │
   │ 2. Execute in order      │
   │ 3. Handle conflicts:     │
   │    • 409 Conflict →      │
   │      show user dialog    │
   │    • 410 Gone →          │
   │      remove from queue   │
   │    • 5xx Server →        │
   │      retry with backoff  │
   │ 4. Update local cache    │
   └──────────────────────────┘
```

### Conflict Types & Resolution

| Action | Conflict | Resolution |
|--------|----------|------------|
| Create order (offline) | Order created on another device | Discard duplicate, show existing |
| Cancel order | Order already completed server-side | Show error: "Order already completed" |
| Update address | Address deleted by another session | Re-create address with update, last-write-wins by updatedAt |
| Location point | Stale data (3+ min old) | Discard, use latest WS stream |
| Product stock | Stock depleted during offline checkout | Show "item unavailable" on sync |
| Availability | Concurrent availability toggle | Last-write-wins |
| Chat message | Duplicate message | Each message unique by localId, no conflict |
| Order status | Server has different status | Server state always wins (client cannot override server order status) |

### State Sync on Reconnect

```dart
class SyncService {
  Future<void> syncAfterReconnect() async {
    // 1. Get all pending actions
    final pending = await db.syncQueue.getAll();

    for (final action in pending) {
      try {
        await _execute(action);
        await db.syncQueue.delete(action.id);
      } on DioException catch (e) {
        if (e.response?.statusCode == 409) {
          // Conflict → notify user
          _handleConflict(action, e.response!.data);
        } else if (e.response?.statusCode == 410) {
          // Entity deleted → remove
          await db.syncQueue.delete(action.id);
        } else {
          // Transient error → retry later
          await db.syncQueue.incrementRetry(action.id);
          if (action.retryCount > 5) {
            _notifyUser('Sync failed: ${action.type}');
          }
        }
      }
    }

    // 2. Re-fetch latest state from server
    await _refreshAllCaches();
  }
}
```

## Yandex MapKit Setup

```yaml
# pubspec.yaml
dependencies:
  yandex_mapkit: ^4.0.0
  permission_handler: ^11.0.0

# Android: AndroidManifest.xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />

# iOS: Info.plist
<key>NSLocationWhenInUseUsageDescription</key>
<string>Courier needs location to track delivery</string>
<key>YandexMapKitApiKey</key>
<string>${YANDEX_MAPS_API_KEY}</string>
```

```dart
// main.dart — Yandex MapKit initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Yandex MapKit before runApp
  await YandexMapKit.initialize(apiKey: dotenv.env['YANDEX_MAPS_API_KEY']!);
  await Permission.locationWhenInUse.request();

  runApp(ProviderScope(child: GlossApp()));
}
```

## Splash Screen Logic

```dart
class SplashProvider extends StateNotifier<SplashState> {
  Future<void> initialize() async {
    // 1. Check stored auth token
    final token = await authStorage.getAccessToken();

    if (token == null) {
      // No token → go to onboarding or login
      state = SplashState.unauthenticated();
      return;
    }

    // 2. Validate token server-side
    try {
      await authService.refreshToken();
      state = SplashState.authenticated();
    } on DioException {
      // Token expired → clear and go to login
      await authStorage.clear();
      state = SplashState.unauthenticated();
    }

    // 3. Check first launch
    final isFirstLaunch = await storage.getBool('first_launch') ?? true;
    if (isFirstLaunch) {
      state = SplashState.firstLaunch();
    }
  }
}
```
