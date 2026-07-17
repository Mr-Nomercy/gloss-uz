import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    String? parentId,
    required String name,
    String? nameRu,
    String? nameEn,
    required String slug,
    String? image,
    String? icon,
    String? description,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    Category? parent,
    List<Category>? children,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}
