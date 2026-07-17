import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String orderNumber,
    required String clientId,
    required String type, // service, product, mixed
    required String status,
    required double subtotal,
    @Default(0.0) double discount,
    @Default(0.0) double deliveryFee,
    @Default(0.0) double platformFee,
    required double total,
    required String paymentStatus,
    String? paymentMethod,
    DateTime? scheduledAt,
    DateTime? completedAt,
    String? cancellationReason,
    String? addressId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String orderId,
    String? productId,
    String? variantId,
    String? serviceId,
    String? sellerId,
    @Default(1) int quantity,
    required double unitPrice,
    required double totalPrice,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}
