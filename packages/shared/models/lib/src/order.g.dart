// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      clientId: json['client_id'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      platformFee: (json['platform_fee'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num).toDouble(),
      paymentStatus: json['payment_status'] as String,
      paymentMethod: json['payment_method'] as String?,
      scheduledAt: json['scheduled_at'] == null
          ? null
          : DateTime.parse(json['scheduled_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      cancellationReason: json['cancellation_reason'] as String?,
      addressId: json['address_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'client_id': instance.clientId,
      'type': instance.type,
      'status': instance.status,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'delivery_fee': instance.deliveryFee,
      'platform_fee': instance.platformFee,
      'total': instance.total,
      'payment_status': instance.paymentStatus,
      'payment_method': instance.paymentMethod,
      'scheduled_at': instance.scheduledAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'cancellation_reason': instance.cancellationReason,
      'address_id': instance.addressId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String?,
      variantId: json['variant_id'] as String?,
      serviceId: json['service_id'] as String?,
      sellerId: json['seller_id'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'variant_id': instance.variantId,
      'service_id': instance.serviceId,
      'seller_id': instance.sellerId,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
    };
