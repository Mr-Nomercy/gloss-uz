// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      parentId: json['parent_id'] as String?,
      name: json['name'] as String,
      nameRu: json['name_ru'] as String?,
      nameEn: json['name_en'] as String?,
      slug: json['slug'] as String,
      image: json['image'] as String?,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      parent: json['parent'] == null
          ? null
          : Category.fromJson(json['parent'] as Map<String, dynamic>),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'name': instance.name,
      'name_ru': instance.nameRu,
      'name_en': instance.nameEn,
      'slug': instance.slug,
      'image': instance.image,
      'icon': instance.icon,
      'description': instance.description,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'parent': instance.parent?.toJson(),
      'children': instance.children?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
