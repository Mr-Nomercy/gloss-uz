import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/models.dart';

part 'products_response.freezed.dart';
part 'products_response.g.dart';

@freezed
class ProductsResponse with _$ProductsResponse {
  const factory ProductsResponse({
    required List<Product> products,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _ProductsResponse;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) => _$ProductsResponseFromJson(json);
}
