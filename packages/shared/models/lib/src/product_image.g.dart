// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImageImpl _$$ProductImageImplFromJson(Map<String, dynamic> json) =>
    _$ProductImageImpl(
      id: json['id'] as String,
      productId: json['product_id'] as String,
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

Map<String, dynamic> _$$ProductImageImplToJson(_$ProductImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'url': instance.url,
      'alt': instance.alt,
      'sort_order': instance.sortOrder,
      'is_primary': instance.isPrimary,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
