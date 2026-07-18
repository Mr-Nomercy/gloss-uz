// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceImageImpl _$$ServiceImageImplFromJson(Map<String, dynamic> json) =>
    _$ServiceImageImpl(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      serviceTypeId: json['service_type_id'] as String?,
      url: json['url'] as String,
      alt: json['alt'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isPrimary: json['is_primary'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ServiceImageImplToJson(_$ServiceImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'service_type_id': instance.serviceTypeId,
      'url': instance.url,
      'alt': instance.alt,
      'sort_order': instance.sortOrder,
      'is_primary': instance.isPrimary,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
