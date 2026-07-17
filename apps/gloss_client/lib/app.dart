import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/verify_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/xizmatlar_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/time_slot_screen.dart';
import 'screens/address_search_screen.dart';
import 'screens/order_screen.dart';
import 'screens/team_info_screen.dart';
import 'screens/cancel_reason_screen.dart';
import 'screens/multi_aspect_rating_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/order_success_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/market_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/saved_addresses_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
      GoRoute(
        path: '/verify',
        builder: (_, state) {
          final phone = state.extra as String? ?? '';
          return VerifyScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/register',
        builder: (_, state) {
          final phone = state.extra as String? ?? '';
          return RegisterScreen(phone: phone);
        },
      ),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/xizmatlar', builder: (_, __) => const XizmatlarScreen()),
      GoRoute(path: '/booking', builder: (_, __) => const BookingScreen()),
      GoRoute(path: '/time-slot', builder: (_, __) => const TimeSlotScreen()),
      GoRoute(path: '/address-search', builder: (_, __) => const AddressSearchScreen()),
      GoRoute(path: '/order', builder: (_, __) => const OrderScreen()),
      GoRoute(path: '/team-info', builder: (_, __) => const TeamInfoScreen()),
      GoRoute(path: '/cancel-reason', builder: (_, __) => const CancelReasonScreen()),
      GoRoute(path: '/multi-aspect-rating', builder: (_, __) => const MultiAspectRatingScreen()),
      GoRoute(path: '/order-history', builder: (_, __) => const OrderHistoryScreen()),
      GoRoute(path: '/order-success', builder: (_, __) => const OrderSuccessScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/market', builder: (_, __) => const MarketScreen()),
      GoRoute(path: '/product-detail', builder: (_, __) => const ProductDetailScreen()),
      GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
      GoRoute(path: '/checkout', builder: (_, __) => const CheckoutScreen(subtotal: 0, discount: 0, delivery: 0, total: 0)),
      GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/saved-addresses', builder: (_, __) => const SavedAddressesScreen()),
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    ],
  );
});
