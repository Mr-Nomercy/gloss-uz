library constants;

// ─── Order Statuses ───
class OrderStatus {
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String assignedProvider = 'assigned_provider';
  static const String assignedCourier = 'assigned_courier';
  static const String readyForPickup = 'ready_for_pickup';
  static const String inProgress = 'in_progress';
  static const String enRouteToPickup = 'en_route_to_pickup';
  static const String pickedUp = 'picked_up';
  static const String enRouteToDelivery = 'en_route_to_delivery';
  static const String delivered = 'delivered';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  static const List<String> all = [
    pending, confirmed, assignedProvider, assignedCourier, readyForPickup,
    inProgress, enRouteToPickup, pickedUp, enRouteToDelivery,
    delivered, completed, cancelled,
  ];
}

// ─── Payment Statuses ───
class PaymentStatus {
  static const String pending = 'pending';
  static const String paid = 'paid';
  static const String failed = 'failed';
  static const String refunded = 'refunded';
}

// ─── Roles ───
class UserRole {
  static const String client = 'client';
  static const String provider = 'provider';
  static const String courier = 'courier';
  static const String seller = 'seller';
  static const String admin = 'admin';
  static const String superAdmin = 'super_admin';
}

// ─── Order Types ───
class OrderType {
  static const String service = 'service';
  static const String product = 'product';
  static const String mixed = 'mixed';
}

// ─── Business Rules ───
class BusinessRules {
  static const double minServiceOrder = 30000;
  static const double minProductOrder = 20000;
  static const double minMixedOrder = 50000;
  static const double platformCommissionService = 0.20;
  static const double platformCommissionProduct = 0.15;
  static const int bookingStartHour = 8;
  static const int bookingEndHour = 22;
  static const int lastSlotHour = 21;
  static const int maxSchedulingDays = 14;
}

// ─── App Configuration ───
class AppConstants {
  static const String appName = 'Gloss';
  static const String baseUrl = 'https://api.gloss.com.uz';
  static const String devBaseUrl = 'http://localhost:3000/api/v1';
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 15000;
  static const int otpResendSeconds = 30;
  static const int offerTimeoutSeconds = 15;
  static const int maxRetryAttempts = 3;
  static const int teamLocationInterval = 10;
  static const String apiVersion = 'v1';
  static const int defaultPageSize = 20;
}

// ─── Cleaning Service Order Status (dispatch flow) ───
class CleaningOrderStatus {
  static const String searching = 'searching';
  static const String assigned = 'assigned';
  static const String enRoute = 'en_route';
  static const String arrived = 'arrived';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
  static const String rated = 'rated';
  static const String cancelled = 'cancelled';

  static const List<String> active = [
    searching, assigned, enRoute, arrived, inProgress,
  ];
  static const List<String> finished = [completed, rated];
}
