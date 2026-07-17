import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_variant.freezed.dart';
part 'product_variant.g.dart';

@freezed
class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String id,
    required String productId,
    required String name,
    String? sku,
    required String price,
    @Default(0) int stockQty,
    Map<String, dynamic>? attributes,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Map<String, dynamic> json) => _$ProductVariantFromJson(json);
}
