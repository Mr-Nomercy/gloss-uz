// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kyc_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KycDocument _$KycDocumentFromJson(Map<String, dynamic> json) {
  return _KycDocument.fromJson(json);
}

/// @nodoc
mixin _$KycDocument {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get sellerId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get reviewedBy => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this KycDocument to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KycDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KycDocumentCopyWith<KycDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KycDocumentCopyWith<$Res> {
  factory $KycDocumentCopyWith(
          KycDocument value, $Res Function(KycDocument) then) =
      _$KycDocumentCopyWithImpl<$Res, KycDocument>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? sellerId,
      String type,
      String fileUrl,
      String status,
      String? reviewedBy,
      DateTime? reviewedAt,
      String? rejectionReason,
      DateTime? expiresAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$KycDocumentCopyWithImpl<$Res, $Val extends KycDocument>
    implements $KycDocumentCopyWith<$Res> {
  _$KycDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KycDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? sellerId = freezed,
    Object? type = null,
    Object? fileUrl = null,
    Object? status = null,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? rejectionReason = freezed,
    Object? expiresAt = freezed,
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
      sellerId: freezed == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$KycDocumentImplCopyWith<$Res>
    implements $KycDocumentCopyWith<$Res> {
  factory _$$KycDocumentImplCopyWith(
          _$KycDocumentImpl value, $Res Function(_$KycDocumentImpl) then) =
      __$$KycDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? sellerId,
      String type,
      String fileUrl,
      String status,
      String? reviewedBy,
      DateTime? reviewedAt,
      String? rejectionReason,
      DateTime? expiresAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$KycDocumentImplCopyWithImpl<$Res>
    extends _$KycDocumentCopyWithImpl<$Res, _$KycDocumentImpl>
    implements _$$KycDocumentImplCopyWith<$Res> {
  __$$KycDocumentImplCopyWithImpl(
      _$KycDocumentImpl _value, $Res Function(_$KycDocumentImpl) _then)
      : super(_value, _then);

  /// Create a copy of KycDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? sellerId = freezed,
    Object? type = null,
    Object? fileUrl = null,
    Object? status = null,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? rejectionReason = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$KycDocumentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: freezed == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$KycDocumentImpl implements _KycDocument {
  const _$KycDocumentImpl(
      {required this.id,
      required this.userId,
      this.sellerId,
      required this.type,
      required this.fileUrl,
      this.status = 'pending',
      this.reviewedBy,
      this.reviewedAt,
      this.rejectionReason,
      this.expiresAt,
      this.createdAt,
      this.updatedAt});

  factory _$KycDocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$KycDocumentImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? sellerId;
  @override
  final String type;
  @override
  final String fileUrl;
  @override
  @JsonKey()
  final String status;
  @override
  final String? reviewedBy;
  @override
  final DateTime? reviewedAt;
  @override
  final String? rejectionReason;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'KycDocument(id: $id, userId: $userId, sellerId: $sellerId, type: $type, fileUrl: $fileUrl, status: $status, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, rejectionReason: $rejectionReason, expiresAt: $expiresAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KycDocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
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
      userId,
      sellerId,
      type,
      fileUrl,
      status,
      reviewedBy,
      reviewedAt,
      rejectionReason,
      expiresAt,
      createdAt,
      updatedAt);

  /// Create a copy of KycDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KycDocumentImplCopyWith<_$KycDocumentImpl> get copyWith =>
      __$$KycDocumentImplCopyWithImpl<_$KycDocumentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KycDocumentImplToJson(
      this,
    );
  }
}

abstract class _KycDocument implements KycDocument {
  const factory _KycDocument(
      {required final String id,
      required final String userId,
      final String? sellerId,
      required final String type,
      required final String fileUrl,
      final String status,
      final String? reviewedBy,
      final DateTime? reviewedAt,
      final String? rejectionReason,
      final DateTime? expiresAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$KycDocumentImpl;

  factory _KycDocument.fromJson(Map<String, dynamic> json) =
      _$KycDocumentImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get sellerId;
  @override
  String get type;
  @override
  String get fileUrl;
  @override
  String get status;
  @override
  String? get reviewedBy;
  @override
  DateTime? get reviewedAt;
  @override
  String? get rejectionReason;
  @override
  DateTime? get expiresAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of KycDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KycDocumentImplCopyWith<_$KycDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
