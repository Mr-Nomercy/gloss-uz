import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_pricing.freezed.dart';
part 'service_pricing.g.dart';

@freezed
class ServicePricing with _$ServicePricing {
  const factory ServicePricing({
    required String id,
    required String serviceId,
    double? areaFrom,
    double? areaTo,
    String? pricePerSqm,
    String? fixedPrice,
    Map<String, dynamic>? extraOptions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ServicePricing;

  factory ServicePricing.fromJson(Map<String, dynamic> json) => _$ServicePricingFromJson(json);
}
