// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceImpl _$$ServiceImplFromJson(Map<String, dynamic> json) =>
    _$ServiceImpl(
      id: json['id'] as String,
      serviceTypeId: json['service_type_id'] as String,
      name: json['name'] as String,
      nameRu: json['name_ru'] as String?,
      nameEn: json['name_en'] as String?,
      description: json['description'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 60,
      minArea: (json['min_area'] as num?)?.toDouble(),
      maxArea: (json['max_area'] as num?)?.toDouble(),
      basePrice: json['base_price'] as String,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      serviceType: json['service_type'] == null
          ? null
          : ServiceType.fromJson(json['service_type'] as Map<String, dynamic>),
      pricings: (json['pricings'] as List<dynamic>?)
          ?.map((e) => ServicePricing.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ServiceImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ServiceImplToJson(_$ServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_type_id': instance.serviceTypeId,
      'name': instance.name,
      'name_ru': instance.nameRu,
      'name_en': instance.nameEn,
      'description': instance.description,
      'duration_minutes': instance.durationMinutes,
      'min_area': instance.minArea,
      'max_area': instance.maxArea,
      'base_price': instance.basePrice,
      'is_active': instance.isActive,
      'sort_order': instance.sortOrder,
      'service_type': instance.serviceType?.toJson(),
      'pricings': instance.pricings?.map((e) => e.toJson()).toList(),
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
