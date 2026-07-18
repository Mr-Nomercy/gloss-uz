// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      sellerId: json['seller_id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      nameRu: json['name_ru'] as String?,
      nameEn: json['name_en'] as String?,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      unit: json['unit'] as String? ?? 'pcs',
      basePrice: json['base_price'] as String,
      salePrice: json['sale_price'] as String?,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      stockQty: (json['stock_qty'] as num?)?.toInt() ?? 0,
      minOrderQty: (json['min_order_qty'] as num?)?.toInt() ?? 1,
      weight: (json['weight'] as num?)?.toDouble(),
      volume: (json['volume'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
      totalSold: (json['total_sold'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seller_id': instance.sellerId,
      'category_id': instance.categoryId,
      'name': instance.name,
      'name_ru': instance.nameRu,
      'name_en': instance.nameEn,
      'slug': instance.slug,
      'description': instance.description,
      'brand': instance.brand,
      'unit': instance.unit,
      'base_price': instance.basePrice,
      'sale_price': instance.salePrice,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'stock_qty': instance.stockQty,
      'min_order_qty': instance.minOrderQty,
      'weight': instance.weight,
      'volume': instance.volume,
      'is_active': instance.isActive,
      'is_featured': instance.isFeatured,
      'status': instance.status,
      'rejection_reason': instance.rejectionReason,
      'total_sold': instance.totalSold,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'variants': instance.variants?.map((e) => e.toJson()).toList(),
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'category': instance.category?.toJson(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
