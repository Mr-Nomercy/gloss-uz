// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      avatar: json['avatar'] as String?,
      language: json['language'] as String? ?? 'uz',
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      isBlocked: json['is_blocked'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'email': instance.email,
      'full_name': instance.fullName,
      'avatar': instance.avatar,
      'language': instance.language,
      'roles': instance.roles,
      'is_blocked': instance.isBlocked,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$AuthTokensImpl _$$AuthTokensImplFromJson(Map<String, dynamic> json) =>
    _$AuthTokensImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthTokensImplToJson(_$AuthTokensImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user.toJson(),
    };
