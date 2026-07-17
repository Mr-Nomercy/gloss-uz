import 'package:freezed_annotation/freezed_annotation.dart';
import 'role.dart';
import 'seller_profile.dart';
import 'address.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String phone,
    String? email,
    String? fullName,
    String? avatar,
    String? language,
    required bool isActive,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    List<Role>? roles,
    SellerProfile? sellerProfile,
    List<Address>? addresses,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
