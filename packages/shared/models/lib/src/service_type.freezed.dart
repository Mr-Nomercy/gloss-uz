// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceType _$ServiceTypeFromJson(Map<String, dynamic> json) {
  return _ServiceType.fromJson(json);
}

/// @nodoc
mixin _$ServiceType {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nameRu => throw _privateConstructorUsedError;
  String? get nameEn => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  List<Service>? get services => throw _privateConstructorUsedError;
  List<ServiceImage>? get images => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ServiceType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceTypeCopyWith<ServiceType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceTypeCopyWith<$Res> {
  factory $ServiceTypeCopyWith(
          ServiceType value, $Res Function(ServiceType) then) =
      _$ServiceTypeCopyWithImpl<$Res, ServiceType>;
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      String? nameRu,
      String? nameEn,
      String? description,
      String? icon,
      int sortOrder,
      bool isActive,
      List<Service>? services,
      List<ServiceImage>? images,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ServiceTypeCopyWithImpl<$Res, $Val extends ServiceType>
    implements $ServiceTypeCopyWith<$Res> {
  _$ServiceTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? nameRu = freezed,
    Object? nameEn = freezed,
    Object? description = freezed,
    Object? icon = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? services = freezed,
    Object? images = freezed,
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
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      services: freezed == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<Service>?,
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
}

/// @nodoc
abstract class _$$ServiceTypeImplCopyWith<$Res>
    implements $ServiceTypeCopyWith<$Res> {
  factory _$$ServiceTypeImplCopyWith(
          _$ServiceTypeImpl value, $Res Function(_$ServiceTypeImpl) then) =
      __$$ServiceTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      String? nameRu,
      String? nameEn,
      String? description,
      String? icon,
      int sortOrder,
      bool isActive,
      List<Service>? services,
      List<ServiceImage>? images,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ServiceTypeImplCopyWithImpl<$Res>
    extends _$ServiceTypeCopyWithImpl<$Res, _$ServiceTypeImpl>
    implements _$$ServiceTypeImplCopyWith<$Res> {
  __$$ServiceTypeImplCopyWithImpl(
      _$ServiceTypeImpl _value, $Res Function(_$ServiceTypeImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? nameRu = freezed,
    Object? nameEn = freezed,
    Object? description = freezed,
    Object? icon = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? services = freezed,
    Object? images = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ServiceTypeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
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
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      services: freezed == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<Service>?,
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
class _$ServiceTypeImpl implements _ServiceType {
  const _$ServiceTypeImpl(
      {required this.id,
      required this.code,
      required this.name,
      this.nameRu,
      this.nameEn,
      this.description,
      this.icon,
      this.sortOrder = 0,
      this.isActive = true,
      final List<Service>? services,
      final List<ServiceImage>? images,
      this.createdAt,
      this.updatedAt})
      : _services = services,
        _images = images;

  factory _$ServiceTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceTypeImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? nameRu;
  @override
  final String? nameEn;
  @override
  final String? description;
  @override
  final String? icon;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  @JsonKey()
  final bool isActive;
  final List<Service>? _services;
  @override
  List<Service>? get services {
    final value = _services;
    if (value == null) return null;
    if (_services is EqualUnmodifiableListView) return _services;
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
    return 'ServiceType(id: $id, code: $code, name: $name, nameRu: $nameRu, nameEn: $nameEn, description: $description, icon: $icon, sortOrder: $sortOrder, isActive: $isActive, services: $services, images: $images, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameRu, nameRu) || other.nameRu == nameRu) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
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
      code,
      name,
      nameRu,
      nameEn,
      description,
      icon,
      sortOrder,
      isActive,
      const DeepCollectionEquality().hash(_services),
      const DeepCollectionEquality().hash(_images),
      createdAt,
      updatedAt);

  /// Create a copy of ServiceType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceTypeImplCopyWith<_$ServiceTypeImpl> get copyWith =>
      __$$ServiceTypeImplCopyWithImpl<_$ServiceTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceTypeImplToJson(
      this,
    );
  }
}

abstract class _ServiceType implements ServiceType {
  const factory _ServiceType(
      {required final String id,
      required final String code,
      required final String name,
      final String? nameRu,
      final String? nameEn,
      final String? description,
      final String? icon,
      final int sortOrder,
      final bool isActive,
      final List<Service>? services,
      final List<ServiceImage>? images,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ServiceTypeImpl;

  factory _ServiceType.fromJson(Map<String, dynamic> json) =
      _$ServiceTypeImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String? get nameRu;
  @override
  String? get nameEn;
  @override
  String? get description;
  @override
  String? get icon;
  @override
  int get sortOrder;
  @override
  bool get isActive;
  @override
  List<Service>? get services;
  @override
  List<ServiceImage>? get images;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ServiceType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceTypeImplCopyWith<_$ServiceTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
