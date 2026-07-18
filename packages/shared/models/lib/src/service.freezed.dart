// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return _Service.fromJson(json);
}

/// @nodoc
mixin _$Service {
  String get id => throw _privateConstructorUsedError;
  String get serviceTypeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nameRu => throw _privateConstructorUsedError;
  String? get nameEn => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  double? get minArea => throw _privateConstructorUsedError;
  double? get maxArea => throw _privateConstructorUsedError;
  String get basePrice => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  ServiceType? get serviceType => throw _privateConstructorUsedError;
  List<ServicePricing>? get pricings => throw _privateConstructorUsedError;
  List<ServiceImage>? get images => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Service to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Service
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceCopyWith<Service> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceCopyWith<$Res> {
  factory $ServiceCopyWith(Service value, $Res Function(Service) then) =
      _$ServiceCopyWithImpl<$Res, Service>;
  @useResult
  $Res call(
      {String id,
      String serviceTypeId,
      String name,
      String? nameRu,
      String? nameEn,
      String? description,
      int durationMinutes,
      double? minArea,
      double? maxArea,
      String basePrice,
      bool isActive,
      int sortOrder,
      ServiceType? serviceType,
      List<ServicePricing>? pricings,
      List<ServiceImage>? images,
      DateTime? createdAt,
      DateTime? updatedAt});

  $ServiceTypeCopyWith<$Res>? get serviceType;
}

/// @nodoc
class _$ServiceCopyWithImpl<$Res, $Val extends Service>
    implements $ServiceCopyWith<$Res> {
  _$ServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Service
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceTypeId = null,
    Object? name = null,
    Object? nameRu = freezed,
    Object? nameEn = freezed,
    Object? description = freezed,
    Object? durationMinutes = null,
    Object? minArea = freezed,
    Object? maxArea = freezed,
    Object? basePrice = null,
    Object? isActive = null,
    Object? sortOrder = null,
    Object? serviceType = freezed,
    Object? pricings = freezed,
    Object? images = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serviceTypeId: null == serviceTypeId
          ? _value.serviceTypeId
          : serviceTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameRu: freezed == nameRu
          ? _value.nameRu
          : nameRu // ignore: cast_nullable_to_non_nullable
              as String?,
      nameEn: freezed == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      minArea: freezed == minArea
          ? _value.minArea
          : minArea // ignore: cast_nullable_to_non_nullable
              as double?,
      maxArea: freezed == maxArea
          ? _value.maxArea
          : maxArea // ignore: cast_nullable_to_non_nullable
              as double?,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      serviceType: freezed == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as ServiceType?,
      pricings: freezed == pricings
          ? _value.pricings
          : pricings // ignore: cast_nullable_to_non_nullable
              as List<ServicePricing>?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ServiceImage>?,
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

  /// Create a copy of Service
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServiceTypeCopyWith<$Res>? get serviceType {
    if (_value.serviceType == null) {
      return null;
    }

    return $ServiceTypeCopyWith<$Res>(_value.serviceType!, (value) {
      return _then(_value.copyWith(serviceType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ServiceImplCopyWith<$Res> implements $ServiceCopyWith<$Res> {
  factory _$$ServiceImplCopyWith(
          _$ServiceImpl value, $Res Function(_$ServiceImpl) then) =
      __$$ServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String serviceTypeId,
      String name,
      String? nameRu,
      String? nameEn,
      String? description,
      int durationMinutes,
      double? minArea,
      double? maxArea,
      String basePrice,
      bool isActive,
      int sortOrder,
      ServiceType? serviceType,
      List<ServicePricing>? pricings,
      List<ServiceImage>? images,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $ServiceTypeCopyWith<$Res>? get serviceType;
}

/// @nodoc
class __$$ServiceImplCopyWithImpl<$Res>
    extends _$ServiceCopyWithImpl<$Res, _$ServiceImpl>
    implements _$$ServiceImplCopyWith<$Res> {
  __$$ServiceImplCopyWithImpl(
      _$ServiceImpl _value, $Res Function(_$ServiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Service
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceTypeId = null,
    Object? name = null,
    Object? nameRu = freezed,
    Object? nameEn = freezed,
    Object? description = freezed,
    Object? durationMinutes = null,
    Object? minArea = freezed,
    Object? maxArea = freezed,
    Object? basePrice = null,
    Object? isActive = null,
    Object? sortOrder = null,
    Object? serviceType = freezed,
    Object? pricings = freezed,
    Object? images = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ServiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serviceTypeId: null == serviceTypeId
          ? _value.serviceTypeId
          : serviceTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameRu: freezed == nameRu
          ? _value.nameRu
          : nameRu // ignore: cast_nullable_to_non_nullable
              as String?,
      nameEn: freezed == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      minArea: freezed == minArea
          ? _value.minArea
          : minArea // ignore: cast_nullable_to_non_nullable
              as double?,
      maxArea: freezed == maxArea
          ? _value.maxArea
          : maxArea // ignore: cast_nullable_to_non_nullable
              as double?,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      serviceType: freezed == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as ServiceType?,
      pricings: freezed == pricings
          ? _value._pricings
          : pricings // ignore: cast_nullable_to_non_nullable
              as List<ServicePricing>?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ServiceImage>?,
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
class _$ServiceImpl implements _Service {
  const _$ServiceImpl(
      {required this.id,
      required this.serviceTypeId,
      required this.name,
      this.nameRu,
      this.nameEn,
      this.description,
      this.durationMinutes = 60,
      this.minArea,
      this.maxArea,
      required this.basePrice,
      this.isActive = true,
      this.sortOrder = 0,
      this.serviceType,
      final List<ServicePricing>? pricings,
      final List<ServiceImage>? images,
      this.createdAt,
      this.updatedAt})
      : _pricings = pricings,
        _images = images;

  factory _$ServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceImplFromJson(json);

  @override
  final String id;
  @override
  final String serviceTypeId;
  @override
  final String name;
  @override
  final String? nameRu;
  @override
  final String? nameEn;
  @override
  final String? description;
  @override
  @JsonKey()
  final int durationMinutes;
  @override
  final double? minArea;
  @override
  final double? maxArea;
  @override
  final String basePrice;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  final ServiceType? serviceType;
  final List<ServicePricing>? _pricings;
  @override
  List<ServicePricing>? get pricings {
    final value = _pricings;
    if (value == null) return null;
    if (_pricings is EqualUnmodifiableListView) return _pricings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ServiceImage>? _images;
  @override
  List<ServiceImage>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Service(id: $id, serviceTypeId: $serviceTypeId, name: $name, nameRu: $nameRu, nameEn: $nameEn, description: $description, durationMinutes: $durationMinutes, minArea: $minArea, maxArea: $maxArea, basePrice: $basePrice, isActive: $isActive, sortOrder: $sortOrder, serviceType: $serviceType, pricings: $pricings, images: $images, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceTypeId, serviceTypeId) ||
                other.serviceTypeId == serviceTypeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameRu, nameRu) || other.nameRu == nameRu) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.minArea, minArea) || other.minArea == minArea) &&
            (identical(other.maxArea, maxArea) || other.maxArea == maxArea) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            const DeepCollectionEquality().equals(other._pricings, _pricings) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
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
      serviceTypeId,
      name,
      nameRu,
      nameEn,
      description,
      durationMinutes,
      minArea,
      maxArea,
      basePrice,
      isActive,
      sortOrder,
      serviceType,
      const DeepCollectionEquality().hash(_pricings),
      const DeepCollectionEquality().hash(_images),
      createdAt,
      updatedAt);

  /// Create a copy of Service
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceImplCopyWith<_$ServiceImpl> get copyWith =>
      __$$ServiceImplCopyWithImpl<_$ServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceImplToJson(
      this,
    );
  }
}

abstract class _Service implements Service {
  const factory _Service(
      {required final String id,
      required final String serviceTypeId,
      required final String name,
      final String? nameRu,
      final String? nameEn,
      final String? description,
      final int durationMinutes,
      final double? minArea,
      final double? maxArea,
      required final String basePrice,
      final bool isActive,
      final int sortOrder,
      final ServiceType? serviceType,
      final List<ServicePricing>? pricings,
      final List<ServiceImage>? images,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ServiceImpl;

  factory _Service.fromJson(Map<String, dynamic> json) = _$ServiceImpl.fromJson;

  @override
  String get id;
  @override
  String get serviceTypeId;
  @override
  String get name;
  @override
  String? get nameRu;
  @override
  String? get nameEn;
  @override
  String? get description;
  @override
  int get durationMinutes;
  @override
  double? get minArea;
  @override
  double? get maxArea;
  @override
  String get basePrice;
  @override
  bool get isActive;
  @override
  int get sortOrder;
  @override
  ServiceType? get serviceType;
  @override
  List<ServicePricing>? get pricings;
  @override
  List<ServiceImage>? get images;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Service
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceImplCopyWith<_$ServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
