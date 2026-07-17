import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_image.freezed.dart';
part 'service_image.g.dart';

@freezed
class ServiceImage with _$ServiceImage {
  const factory ServiceImage({
    required String id,
    required String serviceId,
    String? serviceTypeId,
    required String url,
    String? alt,
    @Default(0) int sortOrder,
    @Default(false) bool isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ServiceImage;

  factory ServiceImage.fromJson(Map<String, dynamic> json) => _$ServiceImageFromJson(json);
}
