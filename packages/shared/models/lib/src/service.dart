import 'package:freezed_annotation/freezed_annotation.dart';
import 'service_type.dart';
import 'service_pricing.dart';
import 'service_image.dart';

part 'service.freezed.dart';
part 'service.g.dart';

@freezed
class Service with _$Service {
  const factory Service({
    required String id,
    required String serviceTypeId,
    required String name,
    String? nameRu,
    String? nameEn,
    String? description,
    @Default(60) int durationMinutes,
    double? minArea,
    double? maxArea,
    required String basePrice,
    @Default(true) bool isActive,
    @Default(0) int sortOrder,
    ServiceType? serviceType,
    List<ServicePricing>? pricings,
    List<ServiceImage>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
}
