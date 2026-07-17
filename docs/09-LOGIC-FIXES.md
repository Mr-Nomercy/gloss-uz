# UI Logika Tuzatish — Qo'llanma

Client app UI ga tegish taqiqlanadi. Faqat logika tuzatilishi kerak.

## Client App — Faqat Logika

### Taqiqlangan o'zgarishlar
- ❌ Yangi ekranlar qo'shish
- ❌ Mavjud ekranlar dizaynini o'zgartirish
- ❌ Ranglar, shriftlar, padding o'zgartirish
- ❌ Navigatsiya tartibini o'zgartirish
- ❌ Widget'lar joylashuvini o'zgartirish

### Ruxsat etilgan o'zgarishlar
- ✅ Riverpod provider'lar yaratish
- ✅ API client'ni bog'lash
- ✅ Autentifikatsiya logikasi
- ✅ State management (setState → Riverpod)
- ✅ Form validation logikasi
- ✅ Navigation guard'lar
- ✅ Token saqlash (flutter_secure_storage)
- ✅ Error handling
- ✅ Loading holatlari
- ✅ Push notification handler'lar

### Client App logikasi — qo'shilishi kerak

#### 1. Auth Provider
```dart
// Yangi fayl: lib/providers/auth_provider.dart
@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() => AuthState.initial();

  Future<void> login(String phone, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ref.read(apiClientProvider).auth.login(
        LoginRequest(phone: phone, password: password),
      );
      await _secureStorage.write(key: 'token', value: response.accessToken);
      state = AuthState.authenticated(response.user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'token');
    state = AuthState.initial();
  }
}
```

#### 2. Service Provider
```dart
// Yangi fayl: lib/providers/service_provider.dart
@riverpod
class ServiceList extends _$ServiceList {
  @override
  AsyncValue<List<Service>> build() => const AsyncValue.loading();

  Future<void> loadServices() async {
    state = const AsyncValue.loading();
    try {
      final services = await ref.read(apiClientProvider).getServices();
      state = AsyncValue.data(services);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
```

#### 3. Order Provider
```dart
// Yangi fayl: lib/providers/order_provider.dart
@riverpod
class OrderList extends _$OrderList {
  @override
  AsyncValue<List<Order>> build() => const AsyncValue.loading();

  Future<void> createOrder(OrderRequest request) async {
    // Buyurtma yaratish logikasi
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    // Bekor qilish logikasi
  }

  Future<void> rateOrder(String orderId, Rating rating) async {
    // Baholash logikasi
  }
}
```

#### 4. Cart Provider
```dart
// Yangi fayl: lib/providers/cart_provider.dart
@riverpod
class Cart extends _$Cart {
  @override
  CartState build() => CartState.empty();

  void addItem(Product product, int quantity) {
    state = state.addItem(product, quantity);
  }

  void removeItem(String productId) {
    state = state.removeItem(productId);
  }

  void applyPromoCode(String code) {
    // Promo-kod tekshirish
  }
}
```

#### 5. Address Provider
```dart
// Yangi fayl: lib/providers/address_provider.dart
@riverpod
class AddressList extends _$AddressList {
  @override
  AsyncValue<List<Address>> build() => const AsyncValue.loading();

  Future<void> loadAddresses() async {}
  Future<void> addAddress(AddressRequest address) async {}
  Future<void> deleteAddress(String id) async {}
}
```

### Navigation guard

```dart
// app.dart'ga qo'shish kerak
redirect: (context, state) {
  final authState = ref.watch(authProvider);
  final isAuthRoute = state.matchedLocation.startsWith('/auth');

  if (!authState.isAuthenticated && !isAuthRoute) {
    return '/auth';
  }
  if (authState.isAuthenticated && isAuthRoute) {
    return '/';
  }
  return null;
},
```

## Admin Panel — Logika

### Ruxsat etilgan o'zgarishlar
- ✅ API call'lar qo'shish
- ✅ Real ma'lumotlar bilan almashtirish
- ✅ Form validation
- ✅ Error handling
- ✅ Loading holatlari
- ✅ Pagination
- ✅ Filtr va qidiruv

### Taqiqlangan o'zgarishlar
- ❌ Dizayn o'zgarishlari (agar backend tayyor bo'lmasa)

## Provider / Seller / Deliver — Logika

### Ruxsat etilgan o'zgarishlar
- ✅ API client'ni bog'lash
- ✅ State management (setState → Riverpod)
- ✅ Navigation guard'lar
- ✅ Token saqlash
- ✅ Error handling
- ✅ Loading holatlari
- ✅ Push notification handler'lar

### Taqiqlangan o'zgarishlar
- ❌ Dizayn o'zgarishlari
- ❌ Yangi ekranlar qo'shish
- ❌ Mavjud ekranlar tartibini o'zgartirish
