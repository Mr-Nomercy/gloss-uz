// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressImpl _$$AddressImplFromJson(Map<String, dynamic> json) =>
    _$AddressImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      label: json['label'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      addressLine: json['address_line'] as String,
      building: json['building'] as String?,
      entrance: json['entrance'] as String?,
      floor: json['floor'] as String?,
      apartment: json['apartment'] as String?,
      doorCode: json['door_code'] as String?,
      comment: json['comment'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      yandexPlaceId: json['yandex_place_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AddressImplToJson(_$AddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'label': instance.label,
      'lat': instance.lat,
      'lng': instance.lng,
      'address_line': instance.addressLine,
      'building': instance.building,
      'entrance': instance.entrance,
      'floor': instance.floor,
      'apartment': instance.apartment,
      'door_code': instance.doorCode,
      'comment': instance.comment,
      'is_default': instance.isDefault,
      'yandex_place_id': instance.yandexPlaceId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
