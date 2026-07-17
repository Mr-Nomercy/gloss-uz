import 'package:freezed_annotation/freezed_annotation.dart';
import 'category.dart';
import 'product_variant.dart';
import 'product_image.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String sellerId,
    required String categoryId,
    required String name,
    String? nameRu,
    String? nameEn,
    required String slug,
    String? description,
    String? brand,
    @Default('pcs') String unit,
    required String basePrice,
    String? salePrice,
    String? sku,
    String? barcode,
    @Default(0) int stockQty,
    @Default(1) int minOrderQty,
    double? weight,
    double? volume,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    @Default('pending') String status,
    String? rejectionReason,
    @Default(0) int totalSold,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    List<ProductVariant>? variants,
    List<ProductImage>? images,
    Category? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
