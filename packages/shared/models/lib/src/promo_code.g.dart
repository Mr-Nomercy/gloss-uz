// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromoCodeImpl _$$PromoCodeImplFromJson(Map<String, dynamic> json) =>
    _$PromoCodeImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      type: json['type'] as String,
      value: json['value'] as String,
      minOrderAmount: json['min_order_amount'] as String?,
      maxDiscount: json['max_discount'] as String?,
      usageLimit: (json['usage_limit'] as num?)?.toInt(),
      usedCount: (json['used_count'] as num?)?.toInt() ?? 0,
      appliesTo: json['applies_to'] as String? ?? 'all',
      isActive: json['is_active'] as bool? ?? true,
      startsAt: json['starts_at'] == null
          ? null
          : DateTime.parse(json['starts_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PromoCodeImplToJson(_$PromoCodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'type': instance.type,
      'value': instance.value,
      'min_order_amount': instance.minOrderAmount,
      'max_discount': instance.maxDiscount,
      'usage_limit': instance.usageLimit,
      'used_count': instance.usedCount,
      'applies_to': instance.appliesTo,
      'is_active': instance.isActive,
      'starts_at': instance.startsAt?.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
