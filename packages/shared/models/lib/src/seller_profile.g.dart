// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellerProfileImpl _$$SellerProfileImplFromJson(Map<String, dynamic> json) =>
    _$SellerProfileImpl(
      id: json['id'] as String,
      shopName: json['shop_name'] as String,
      shopSlug: json['shop_slug'] as String,
      shopDescription: json['shop_description'] as String?,
      logo: json['logo'] as String?,
      banner: json['banner'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalSales: (json['total_sales'] as num?)?.toInt() ?? 0,
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      commissionRate: (json['commission_rate'] as num?)?.toDouble() ?? 15.0,
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? false,
      verifiedAt: json['verified_at'] == null
          ? null
          : DateTime.parse(json['verified_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SellerProfileImplToJson(_$SellerProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_name': instance.shopName,
      'shop_slug': instance.shopSlug,
      'shop_description': instance.shopDescription,
      'logo': instance.logo,
      'banner': instance.banner,
      'rating': instance.rating,
      'total_sales': instance.totalSales,
      'total_products': instance.totalProducts,
      'commission_rate': instance.commissionRate,
      'is_verified': instance.isVerified,
      'is_active': instance.isActive,
      'verified_at': instance.verifiedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
