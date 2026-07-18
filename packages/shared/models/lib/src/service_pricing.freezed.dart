// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_pricing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServicePricing _$ServicePricingFromJson(Map<String, dynamic> json) {
  return _ServicePricing.fromJson(json);
}

/// @nodoc
mixin _$ServicePricing {
  String get id => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  double? get areaFrom => throw _privateConstructorUsedError;
  double? get areaTo => throw _privateConstructorUsedError;
  String? get pricePerSqm => throw _privateConstructorUsedError;
  String? get fixedPrice => throw _privateConstructorUsedError;
  Map<String, dynamic>? get extraOptions => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ServicePricing to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServicePricing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServicePricingCopyWith<ServicePricing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServicePricingCopyWith<$Res> {
  factory $ServicePricingCopyWith(
          ServicePricing value, $Res Function(ServicePricing) then) =
      _$ServicePricingCopyWithImpl<$Res, ServicePricing>;
  @useResult
  $Res call(
      {String id,
      String serviceId,
      double? areaFrom,
      double? areaTo,
      String? pricePerSqm,
      String? fixedPrice,
      Map<String, dynamic>? extraOptions,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ServicePricingCopyWithImpl<$Res, $Val extends ServicePricing>
    implements $ServicePricingCopyWith<$Res> {
  _$ServicePricingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServicePricing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceId = null,
    Object? areaFrom = freezed,
    Object? areaTo = freezed,
    Object? pricePerSqm = freezed,
    Object? fixedPrice = freezed,
    Object? extraOptions = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      areaFrom: freezed == areaFrom
          ? _value.areaFrom
          : areaFrom // ignore: cast_nullable_to_non_nullable
              as double?,
      areaTo: freezed == areaTo
          ? _value.areaTo
          : areaTo // ignore: cast_nullable_to_non_nullable
              as double?,
      pricePerSqm: freezed == pricePerSqm
          ? _value.pricePerSqm
          : pricePerSqm // ignore: cast_nullable_to_non_nullable
              as String?,
      fixedPrice: freezed == fixedPrice
          ? _value.fixedPrice
          : fixedPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      extraOptions: freezed == extraOptions
          ? _value.extraOptions
          : extraOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
abstract class _$$ServicePricingImplCopyWith<$Res>
    implements $ServicePricingCopyWith<$Res> {
  factory _$$ServicePricingImplCopyWith(_$ServicePricingImpl value,
          $Res Function(_$ServicePricingImpl) then) =
      __$$ServicePricingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String serviceId,
      double? areaFrom,
      double? areaTo,
      String? pricePerSqm,
      String? fixedPrice,
      Map<String, dynamic>? extraOptions,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ServicePricingImplCopyWithImpl<$Res>
    extends _$ServicePricingCopyWithImpl<$Res, _$ServicePricingImpl>
    implements _$$ServicePricingImplCopyWith<$Res> {
  __$$ServicePricingImplCopyWithImpl(
      _$ServicePricingImpl _value, $Res Function(_$ServicePricingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServicePricing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceId = null,
    Object? areaFrom = freezed,
    Object? areaTo = freezed,
    Object? pricePerSqm = freezed,
    Object? fixedPrice = freezed,
    Object? extraOptions = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ServicePricingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      areaFrom: freezed == areaFrom
          ? _value.areaFrom
          : areaFrom // ignore: cast_nullable_to_non_nullable
              as double?,
      areaTo: freezed == areaTo
          ? _value.areaTo
          : areaTo // ignore: cast_nullable_to_non_nullable
              as double?,
      pricePerSqm: freezed == pricePerSqm
          ? _value.pricePerSqm
          : pricePerSqm // ignore: cast_nullable_to_non_nullable
              as String?,
      fixedPrice: freezed == fixedPrice
          ? _value.fixedPrice
          : fixedPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      extraOptions: freezed == extraOptions
          ? _value._extraOptions
          : extraOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
class _$ServicePricingImpl implements _ServicePricing {
  const _$ServicePricingImpl(
      {required this.id,
      required this.serviceId,
      this.areaFrom,
      this.areaTo,
      this.pricePerSqm,
      this.fixedPrice,
      final Map<String, dynamic>? extraOptions,
      this.createdAt,
      this.updatedAt})
      : _extraOptions = extraOptions;

  factory _$ServicePricingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServicePricingImplFromJson(json);

  @override
  final String id;
  @override
  final String serviceId;
  @override
  final double? areaFrom;
  @override
  final double? areaTo;
  @override
  final String? pricePerSqm;
  @override
  final String? fixedPrice;
  final Map<String, dynamic>? _extraOptions;
  @override
  Map<String, dynamic>? get extraOptions {
    final value = _extraOptions;
    if (value == null) return null;
    if (_extraOptions is EqualUnmodifiableMapView) return _extraOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ServicePricing(id: $id, serviceId: $serviceId, areaFrom: $areaFrom, areaTo: $areaTo, pricePerSqm: $pricePerSqm, fixedPrice: $fixedPrice, extraOptions: $extraOptions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServicePricingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.areaFrom, areaFrom) ||
                other.areaFrom == areaFrom) &&
            (identical(other.areaTo, areaTo) || other.areaTo == areaTo) &&
            (identical(other.pricePerSqm, pricePerSqm) ||
                other.pricePerSqm == pricePerSqm) &&
            (identical(other.fixedPrice, fixedPrice) ||
                other.fixedPrice == fixedPrice) &&
            const DeepCollectionEquality()
                .equals(other._extraOptions, _extraOptions) &&
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
      serviceId,
      areaFrom,
      areaTo,
      pricePerSqm,
      fixedPrice,
      const DeepCollectionEquality().hash(_extraOptions),
      createdAt,
      updatedAt);

  /// Create a copy of ServicePricing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServicePricingImplCopyWith<_$ServicePricingImpl> get copyWith =>
      __$$ServicePricingImplCopyWithImpl<_$ServicePricingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServicePricingImplToJson(
      this,
    );
  }
}

abstract class _ServicePricing implements ServicePricing {
  const factory _ServicePricing(
      {required final String id,
      required final String serviceId,
      final double? areaFrom,
      final double? areaTo,
      final String? pricePerSqm,
      final String? fixedPrice,
      final Map<String, dynamic>? extraOptions,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ServicePricingImpl;

  factory _ServicePricing.fromJson(Map<String, dynamic> json) =
      _$ServicePricingImpl.fromJson;

  @override
  String get id;
  @override
  String get serviceId;
  @override
  double? get areaFrom;
  @override
  double? get areaTo;
  @override
  String? get pricePerSqm;
  @override
  String? get fixedPrice;
  @override
  Map<String, dynamic>? get extraOptions;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ServicePricing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServicePricingImplCopyWith<_$ServicePricingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
