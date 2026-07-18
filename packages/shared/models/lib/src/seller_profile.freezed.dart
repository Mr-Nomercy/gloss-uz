// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seller_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SellerProfile _$SellerProfileFromJson(Map<String, dynamic> json) {
  return _SellerProfile.fromJson(json);
}

/// @nodoc
mixin _$SellerProfile {
  String get id => throw _privateConstructorUsedError;
  String get shopName => throw _privateConstructorUsedError;
  String get shopSlug => throw _privateConstructorUsedError;
  String? get shopDescription => throw _privateConstructorUsedError;
  String? get logo => throw _privateConstructorUsedError;
  String? get banner => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get totalSales => throw _privateConstructorUsedError;
  int get totalProducts => throw _privateConstructorUsedError;
  double get commissionRate => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SellerProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerProfileCopyWith<SellerProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerProfileCopyWith<$Res> {
  factory $SellerProfileCopyWith(
          SellerProfile value, $Res Function(SellerProfile) then) =
      _$SellerProfileCopyWithImpl<$Res, SellerProfile>;
  @useResult
  $Res call(
      {String id,
      String shopName,
      String shopSlug,
      String? shopDescription,
      String? logo,
      String? banner,
      double rating,
      int totalSales,
      int totalProducts,
      double commissionRate,
      bool isVerified,
      bool isActive,
      DateTime? verifiedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$SellerProfileCopyWithImpl<$Res, $Val extends SellerProfile>
    implements $SellerProfileCopyWith<$Res> {
  _$SellerProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopName = null,
    Object? shopSlug = null,
    Object? shopDescription = freezed,
    Object? logo = freezed,
    Object? banner = freezed,
    Object? rating = null,
    Object? totalSales = null,
    Object? totalProducts = null,
    Object? commissionRate = null,
    Object? isVerified = null,
    Object? isActive = null,
    Object? verifiedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      shopSlug: null == shopSlug
          ? _value.shopSlug
          : shopSlug // ignore: cast_nullable_to_non_nullable
              as String,
      shopDescription: freezed == shopDescription
          ? _value.shopDescription
          : shopDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      commissionRate: null == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as double,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SellerProfileImplCopyWith<$Res>
    implements $SellerProfileCopyWith<$Res> {
  factory _$$SellerProfileImplCopyWith(
          _$SellerProfileImpl value, $Res Function(_$SellerProfileImpl) then) =
      __$$SellerProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String shopName,
      String shopSlug,
      String? shopDescription,
      String? logo,
      String? banner,
      double rating,
      int totalSales,
      int totalProducts,
      double commissionRate,
      bool isVerified,
      bool isActive,
      DateTime? verifiedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$SellerProfileImplCopyWithImpl<$Res>
    extends _$SellerProfileCopyWithImpl<$Res, _$SellerProfileImpl>
    implements _$$SellerProfileImplCopyWith<$Res> {
  __$$SellerProfileImplCopyWithImpl(
      _$SellerProfileImpl _value, $Res Function(_$SellerProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of SellerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopName = null,
    Object? shopSlug = null,
    Object? shopDescription = freezed,
    Object? logo = freezed,
    Object? banner = freezed,
    Object? rating = null,
    Object? totalSales = null,
    Object? totalProducts = null,
    Object? commissionRate = null,
    Object? isVerified = null,
    Object? isActive = null,
    Object? verifiedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SellerProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      shopSlug: null == shopSlug
          ? _value.shopSlug
          : shopSlug // ignore: cast_nullable_to_non_nullable
              as String,
      shopDescription: freezed == shopDescription
          ? _value.shopDescription
          : shopDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      commissionRate: null == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as double,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerProfileImpl implements _SellerProfile {
  const _$SellerProfileImpl(
      {required this.id,
      required this.shopName,
      required this.shopSlug,
      this.shopDescription,
      this.logo,
      this.banner,
      this.rating = 0.0,
      this.totalSales = 0,
      this.totalProducts = 0,
      this.commissionRate = 15.0,
      this.isVerified = false,
      this.isActive = false,
      this.verifiedAt,
      this.createdAt,
      this.updatedAt});

  factory _$SellerProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String shopName;
  @override
  final String shopSlug;
  @override
  final String? shopDescription;
  @override
  final String? logo;
  @override
  final String? banner;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int totalSales;
  @override
  @JsonKey()
  final int totalProducts;
  @override
  @JsonKey()
  final double commissionRate;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? verifiedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SellerProfile(id: $id, shopName: $shopName, shopSlug: $shopSlug, shopDescription: $shopDescription, logo: $logo, banner: $banner, rating: $rating, totalSales: $totalSales, totalProducts: $totalProducts, commissionRate: $commissionRate, isVerified: $isVerified, isActive: $isActive, verifiedAt: $verifiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopName, shopName) ||
                other.shopName == shopName) &&
            (identical(other.shopSlug, shopSlug) ||
                other.shopSlug == shopSlug) &&
            (identical(other.shopDescription, shopDescription) ||
                other.shopDescription == shopDescription) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.commissionRate, commissionRate) ||
                other.commissionRate == commissionRate) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shopName,
      shopSlug,
      shopDescription,
      logo,
      banner,
      rating,
      totalSales,
      totalProducts,
      commissionRate,
      isVerified,
      isActive,
      verifiedAt,
      createdAt,
      updatedAt);

  /// Create a copy of SellerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerProfileImplCopyWith<_$SellerProfileImpl> get copyWith =>
      __$$SellerProfileImplCopyWithImpl<_$SellerProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerProfileImplToJson(
      this,
    );
  }
}

abstract class _SellerProfile implements SellerProfile {
  const factory _SellerProfile(
      {required final String id,
      required final String shopName,
      required final String shopSlug,
      final String? shopDescription,
      final String? logo,
      final String? banner,
      final double rating,
      final int totalSales,
      final int totalProducts,
      final double commissionRate,
      final bool isVerified,
      final bool isActive,
      final DateTime? verifiedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$SellerProfileImpl;

  factory _SellerProfile.fromJson(Map<String, dynamic> json) =
      _$SellerProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get shopName;
  @override
  String get shopSlug;
  @override
  String? get shopDescription;
  @override
  String? get logo;
  @override
  String? get banner;
  @override
  double get rating;
  @override
  int get totalSales;
  @override
  int get totalProducts;
  @override
  double get commissionRate;
  @override
  bool get isVerified;
  @override
  bool get isActive;
  @override
  DateTime? get verifiedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of SellerProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerProfileImplCopyWith<_$SellerProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
