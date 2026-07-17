import 'package:freezed_annotation/freezed_annotation.dart';
import 'service.dart';
import 'service_image.dart';

part 'service_type.freezed.dart';
part 'service_type.g.dart';

@freezed
class ServiceType with _$ServiceType {
  const factory ServiceType({
    required String id,
    required String code,
    required String name,
    String? nameRu,
    String? nameEn,
    String? description,
    String? icon,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    List<Service>? services,
    List<ServiceImage>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ServiceType;

  factory ServiceType.fromJson(Map<String, dynamic> json) => _$ServiceTypeFromJson(json);
}
