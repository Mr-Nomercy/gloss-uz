// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PromoCode _$PromoCodeFromJson(Map<String, dynamic> json) {
  return _PromoCode.fromJson(json);
}

/// @nodoc
mixin _$PromoCode {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String? get minOrderAmount => throw _privateConstructorUsedError;
  String? get maxDiscount => throw _privateConstructorUsedError;
  int? get usageLimit => throw _privateConstructorUsedError;
  int get usedCount => throw _privateConstructorUsedError;
  String get appliesTo => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get startsAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PromoCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PromoCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PromoCodeCopyWith<PromoCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromoCodeCopyWith<$Res> {
  factory $PromoCodeCopyWith(PromoCode value, $Res Function(PromoCode) then) =
      _$PromoCodeCopyWithImpl<$Res, PromoCode>;
  @useResult
  $Res call(
      {String id,
      String code,
      String type,
      String value,
      String? minOrderAmount,
      String? maxDiscount,
      int? usageLimit,
      int usedCount,
      String appliesTo,
      bool isActive,
      DateTime? startsAt,
      DateTime? expiresAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$PromoCodeCopyWithImpl<$Res, $Val extends PromoCode>
    implements $PromoCodeCopyWith<$Res> {
  _$PromoCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PromoCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? type = null,
    Object? value = null,
    Object? minOrderAmount = freezed,
    Object? maxDiscount = freezed,
    Object? usageLimit = freezed,
    Object? usedCount = null,
    Object? appliesTo = null,
    Object? isActive = null,
    Object? startsAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      minOrderAmount: freezed == minOrderAmount
          ? _value.minOrderAmount
          : minOrderAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      maxDiscount: freezed == maxDiscount
          ? _value.maxDiscount
          : maxDiscount // ignore: cast_nullable_to_non_nullable
              as String?,
      usageLimit: freezed == usageLimit
          ? _value.usageLimit
          : usageLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: null == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int,
      appliesTo: null == appliesTo
          ? _value.appliesTo
          : appliesTo // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      startsAt: freezed == startsAt
          ? _value.startsAt
          : startsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PromoCodeImplCopyWith<$Res>
    implements $PromoCodeCopyWith<$Res> {
  factory _$$PromoCodeImplCopyWith(
          _$PromoCodeImpl value, $Res Function(_$PromoCodeImpl) then) =
      __$$PromoCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String type,
      String value,
      String? minOrderAmount,
      String? maxDiscount,
      int? usageLimit,
      int usedCount,
      String appliesTo,
      bool isActive,
      DateTime? startsAt,
      DateTime? expiresAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$PromoCodeImplCopyWithImpl<$Res>
    extends _$PromoCodeCopyWithImpl<$Res, _$PromoCodeImpl>
    implements _$$PromoCodeImplCopyWith<$Res> {
  __$$PromoCodeImplCopyWithImpl(
      _$PromoCodeImpl _value, $Res Function(_$PromoCodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of PromoCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? type = null,
    Object? value = null,
    Object? minOrderAmount = freezed,
    Object? maxDiscount = freezed,
    Object? usageLimit = freezed,
    Object? usedCount = null,
    Object? appliesTo = null,
    Object? isActive = null,
    Object? startsAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PromoCodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      minOrderAmount: freezed == minOrderAmount
          ? _value.minOrderAmount
          : minOrderAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      maxDiscount: freezed == maxDiscount
          ? _value.maxDiscount
          : maxDiscount // ignore: cast_nullable_to_non_nullable
              as String?,
      usageLimit: freezed == usageLimit
          ? _value.usageLimit
          : usageLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: null == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int,
      appliesTo: null == appliesTo
          ? _value.appliesTo
          : appliesTo // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      startsAt: freezed == startsAt
          ? _value.startsAt
          : startsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
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
class _$PromoCodeImpl implements _PromoCode {
  const _$PromoCodeImpl(
      {required this.id,
      required this.code,
      required this.type,
      required this.value,
      this.minOrderAmount,
      this.maxDiscount,
      this.usageLimit,
      this.usedCount = 0,
      this.appliesTo = 'all',
      this.isActive = true,
      this.startsAt,
      this.expiresAt,
      this.createdAt,
      this.updatedAt});

  factory _$PromoCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromoCodeImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String type;
  @override
  final String value;
  @override
  final String? minOrderAmount;
  @override
  final String? maxDiscount;
  @override
  final int? usageLimit;
  @override
  @JsonKey()
  final int usedCount;
  @override
  @JsonKey()
  final String appliesTo;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? startsAt;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PromoCode(id: $id, code: $code, type: $type, value: $value, minOrderAmount: $minOrderAmount, maxDiscount: $maxDiscount, usageLimit: $usageLimit, usedCount: $usedCount, appliesTo: $appliesTo, isActive: $isActive, startsAt: $startsAt, expiresAt: $expiresAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromoCodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.minOrderAmount, minOrderAmount) ||
                other.minOrderAmount == minOrderAmount) &&
            (identical(other.maxDiscount, maxDiscount) ||
                other.maxDiscount == maxDiscount) &&
            (identical(other.usageLimit, usageLimit) ||
                other.usageLimit == usageLimit) &&
            (identical(other.usedCount, usedCount) ||
                other.usedCount == usedCount) &&
            (identical(other.appliesTo, appliesTo) ||
                other.appliesTo == appliesTo) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
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
      code,
      type,
      value,
      minOrderAmount,
      maxDiscount,
      usageLimit,
      usedCount,
      appliesTo,
      isActive,
      startsAt,
      expiresAt,
      createdAt,
      updatedAt);

  /// Create a copy of PromoCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PromoCodeImplCopyWith<_$PromoCodeImpl> get copyWith =>
      __$$PromoCodeImplCopyWithImpl<_$PromoCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromoCodeImplToJson(
      this,
    );
  }
}

abstract class _PromoCode implements PromoCode {
  const factory _PromoCode(
      {required final String id,
      required final String code,
      required final String type,
      required final String value,
      final String? minOrderAmount,
      final String? maxDiscount,
      final int? usageLimit,
      final int usedCount,
      final String appliesTo,
      final bool isActive,
      final DateTime? startsAt,
      final DateTime? expiresAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$PromoCodeImpl;

  factory _PromoCode.fromJson(Map<String, dynamic> json) =
      _$PromoCodeImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get type;
  @override
  String get value;
  @override
  String? get minOrderAmount;
  @override
  String? get maxDiscount;
  @override
  int? get usageLimit;
  @override
  int get usedCount;
  @override
  String get appliesTo;
  @override
  bool get isActive;
  @override
  DateTime? get startsAt;
  @override
  DateTime? get expiresAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of PromoCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PromoCodeImplCopyWith<_$PromoCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
