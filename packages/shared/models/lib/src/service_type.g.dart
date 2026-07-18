// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceTypeImpl _$$ServiceTypeImplFromJson(Map<String, dynamic> json) =>
    _$ServiceTypeImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      nameRu: json['name_ru'] as String?,
      nameEn: json['name_en'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$$ServiceTypeImplToJson(_$ServiceTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'name_ru': instance.nameRu,
      'name_en': instance.nameEn,
      'description': instance.description,
      'icon': instance.icon,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'services': instance.services?.map((e) => e.toJson()).toList(),
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
