import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_image.freezed.dart';
part 'product_image.g.dart';

@freezed
class ProductImage with _$ProductImage {
  const factory ProductImage({
    required String id,
    required String productId,
    required String url,
    String? alt,
    @Default(0) int sortOrder,
    @Default(false) bool isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductImage;

  factory ProductImage.fromJson(Map<String, dynamic> json) => _$ProductImageFromJson(json);
}
