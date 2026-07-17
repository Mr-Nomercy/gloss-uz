import 'package:freezed_annotation/freezed_annotation.dart';

part 'seller_profile.freezed.dart';
part 'seller_profile.g.dart';

@freezed
class SellerProfile with _$SellerProfile {
  const factory SellerProfile({
    required String id,
    required String shopName,
    required String shopSlug,
    String? shopDescription,
    String? logo,
    String? banner,
    @Default(0.0) double rating,
    @Default(0) int totalSales,
    @Default(0) int totalProducts,
    @Default(15.0) double commissionRate,
    @Default(false) bool isVerified,
    @Default(false) bool isActive,
    DateTime? verifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SellerProfile;

  factory SellerProfile.fromJson(Map<String, dynamic> json) => _$SellerProfileFromJson(json);
}
