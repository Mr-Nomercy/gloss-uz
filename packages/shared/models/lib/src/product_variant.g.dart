// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductVariantImpl _$$ProductVariantImplFromJson(Map<String, dynamic> json) =>
    _$ProductVariantImpl(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String?,
      price: json['price'] as String,
      stockQty: (json['stock_qty'] as num?)?.toInt() ?? 0,
      attributes: json['attributes'] as Map<String, dynamic>?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ProductVariantImplToJson(
        _$ProductVariantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'name': instance.name,
      'sku': instance.sku,
      'price': instance.price,
      'stock_qty': instance.stockQty,
      'attributes': instance.attributes,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
