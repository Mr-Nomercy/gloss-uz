import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class Address with _$Address {
  const factory Address({
    required String id,
    required String userId,
    String? label,
    required double lat,
    required double lng,
    required String addressLine,
    String? building,
    String? entrance,
    String? floor,
    String? apartment,
    String? doorCode,
    String? comment,
    @Default(false) bool isDefault,
    String? yandexPlaceId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}
