import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo_code.freezed.dart';
part 'promo_code.g.dart';

@freezed
class PromoCode with _$PromoCode {
  const factory PromoCode({
    required String id,
    required String code,
    required String type,
    required String value,
    String? minOrderAmount,
    String? maxDiscount,
    int? usageLimit,
    @Default(0) int usedCount,
    @Default('all') String appliesTo,
    @Default(true) bool isActive,
    DateTime? startsAt,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PromoCode;

  factory PromoCode.fromJson(Map<String, dynamic> json) => _$PromoCodeFromJson(json);
}
