// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Address _$AddressFromJson(Map<String, dynamic> json) {
  return _Address.fromJson(json);
}

/// @nodoc
mixin _$Address {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  String get addressLine => throw _privateConstructorUsedError;
  String? get building => throw _privateConstructorUsedError;
  String? get entrance => throw _privateConstructorUsedError;
  String? get floor => throw _privateConstructorUsedError;
  String? get apartment => throw _privateConstructorUsedError;
  String? get doorCode => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  String? get yandexPlaceId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Address to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressCopyWith<Address> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressCopyWith<$Res> {
  factory $AddressCopyWith(Address value, $Res Function(Address) then) =
      _$AddressCopyWithImpl<$Res, Address>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? label,
      double lat,
      double lng,
      String addressLine,
      String? building,
      String? entrance,
      String? floor,
      String? apartment,
      String? doorCode,
      String? comment,
      bool isDefault,
      String? yandexPlaceId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AddressCopyWithImpl<$Res, $Val extends Address>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? label = freezed,
    Object? lat = null,
    Object? lng = null,
    Object? addressLine = null,
    Object? building = freezed,
    Object? entrance = freezed,
    Object? floor = freezed,
    Object? apartment = freezed,
    Object? doorCode = freezed,
    Object? comment = freezed,
    Object? isDefault = null,
    Object? yandexPlaceId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      addressLine: null == addressLine
          ? _value.addressLine
          : addressLine // ignore: cast_nullable_to_non_nullable
              as String,
      building: freezed == building
          ? _value.building
          : building // ignore: cast_nullable_to_non_nullable
              as String?,
      entrance: freezed == entrance
          ? _value.entrance
          : entrance // ignore: cast_nullable_to_non_nullable
              as String?,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as String?,
      apartment: freezed == apartment
          ? _value.apartment
          : apartment // ignore: cast_nullable_to_non_nullable
              as String?,
      doorCode: freezed == doorCode
          ? _value.doorCode
          : doorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      yandexPlaceId: freezed == yandexPlaceId
          ? _value.yandexPlaceId
          : yandexPlaceId // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$AddressImplCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$$AddressImplCopyWith(
          _$AddressImpl value, $Res Function(_$AddressImpl) then) =
      __$$AddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? label,
      double lat,
      double lng,
      String addressLine,
      String? building,
      String? entrance,
      String? floor,
      String? apartment,
      String? doorCode,
      String? comment,
      bool isDefault,
      String? yandexPlaceId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$AddressImplCopyWithImpl<$Res>
    extends _$AddressCopyWithImpl<$Res, _$AddressImpl>
    implements _$$AddressImplCopyWith<$Res> {
  __$$AddressImplCopyWithImpl(
      _$AddressImpl _value, $Res Function(_$AddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? label = freezed,
    Object? lat = null,
    Object? lng = null,
    Object? addressLine = null,
    Object? building = freezed,
    Object? entrance = freezed,
    Object? floor = freezed,
    Object? apartment = freezed,
    Object? doorCode = freezed,
    Object? comment = freezed,
    Object? isDefault = null,
    Object? yandexPlaceId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AddressImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      addressLine: null == addressLine
          ? _value.addressLine
          : addressLine // ignore: cast_nullable_to_non_nullable
              as String,
      building: freezed == building
          ? _value.building
          : building // ignore: cast_nullable_to_non_nullable
              as String?,
      entrance: freezed == entrance
          ? _value.entrance
          : entrance // ignore: cast_nullable_to_non_nullable
              as String?,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as String?,
      apartment: freezed == apartment
          ? _value.apartment
          : apartment // ignore: cast_nullable_to_non_nullable
              as String?,
      doorCode: freezed == doorCode
          ? _value.doorCode
          : doorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      yandexPlaceId: freezed == yandexPlaceId
          ? _value.yandexPlaceId
          : yandexPlaceId // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$AddressImpl implements _Address {
  const _$AddressImpl(
      {required this.id,
      required this.userId,
      this.label,
      required this.lat,
      required this.lng,
      required this.addressLine,
      this.building,
      this.entrance,
      this.floor,
      this.apartment,
      this.doorCode,
      this.comment,
      this.isDefault = false,
      this.yandexPlaceId,
      this.createdAt,
      this.updatedAt});

  factory _$AddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? label;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final String addressLine;
  @override
  final String? building;
  @override
  final String? entrance;
  @override
  final String? floor;
  @override
  final String? apartment;
  @override
  final String? doorCode;
  @override
  final String? comment;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final String? yandexPlaceId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Address(id: $id, userId: $userId, label: $label, lat: $lat, lng: $lng, addressLine: $addressLine, building: $building, entrance: $entrance, floor: $floor, apartment: $apartment, doorCode: $doorCode, comment: $comment, isDefault: $isDefault, yandexPlaceId: $yandexPlaceId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.building, building) ||
                other.building == building) &&
            (identical(other.entrance, entrance) ||
                other.entrance == entrance) &&
            (identical(other.floor, floor) || other.floor == floor) &&
            (identical(other.apartment, apartment) ||
                other.apartment == apartment) &&
            (identical(other.doorCode, doorCode) ||
                other.doorCode == doorCode) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.yandexPlaceId, yandexPlaceId) ||
                other.yandexPlaceId == yandexPlaceId) &&
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
      userId,
      label,
      lat,
      lng,
      addressLine,
      building,
      entrance,
      floor,
      apartment,
      doorCode,
      comment,
      isDefault,
      yandexPlaceId,
      createdAt,
      updatedAt);

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      __$$AddressImplCopyWithImpl<_$AddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressImplToJson(
      this,
    );
  }
}

abstract class _Address implements Address {
  const factory _Address(
      {required final String id,
      required final String userId,
      final String? label,
      required final double lat,
      required final double lng,
      required final String addressLine,
      final String? building,
      final String? entrance,
      final String? floor,
      final String? apartment,
      final String? doorCode,
      final String? comment,
      final bool isDefault,
      final String? yandexPlaceId,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$AddressImpl;

  factory _Address.fromJson(Map<String, dynamic> json) = _$AddressImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get label;
  @override
  double get lat;
  @override
  double get lng;
  @override
  String get addressLine;
  @override
  String? get building;
  @override
  String? get entrance;
  @override
  String? get floor;
  @override
  String? get apartment;
  @override
  String? get doorCode;
  @override
  String? get comment;
  @override
  bool get isDefault;
  @override
  String? get yandexPlaceId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
