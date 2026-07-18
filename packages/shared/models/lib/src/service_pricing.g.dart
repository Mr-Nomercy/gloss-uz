// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_pricing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServicePricingImpl _$$ServicePricingImplFromJson(Map<String, dynamic> json) =>
    _$ServicePricingImpl(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      areaFrom: (json['area_from'] as num?)?.toDouble(),
      areaTo: (json['area_to'] as num?)?.toDouble(),
      pricePerSqm: json['price_per_sqm'] as String?,
      fixedPrice: json['fixed_price'] as String?,
      extraOptions: json['extra_options'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ServicePricingImplToJson(
        _$ServicePricingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'area_from': instance.areaFrom,
      'area_to': instance.areaTo,
      'price_per_sqm': instance.pricePerSqm,
      'fixed_price': instance.fixedPrice,
      'extra_options': instance.extraOptions,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
