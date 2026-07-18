// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nameRu => throw _privateConstructorUsedError;
  String? get nameEn => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get basePrice => throw _privateConstructorUsedError;
  String? get salePrice => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  int get stockQty => throw _privateConstructorUsedError;
  int get minOrderQty => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  double? get volume => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  int get totalSold => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  List<ProductVariant>? get variants => throw _privateConstructorUsedError;
  List<ProductImage>? get images => throw _privateConstructorUsedError;
  Category? get category => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String id,
      String sellerId,
      String categoryId,
      String name,
      String? nameRu,
      String? nameEn,
      String slug,
      String? description,
      String? brand,
      String unit,
      String basePrice,
      String? salePrice,
      String? sku,
      String? barcode,
      int stockQty,
      int minOrderQty,
      double? weight,
      double? volume,
      bool isActive,
      bool isFeatured,
      String status,
      String? rejectionReason,
      int totalSold,
      double rating,
      int reviewCount,
      List<ProductVariant>? variants,
      List<ProductImage>? images,
      Category? category,
      DateTime? createdAt,
      DateTime? updatedAt});

  $CategoryCopyWith<$Res>? get category;
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? categoryId = null,
    Object? name = null,
    Object? nameRu = freezed,
    Object? nameEn = freezed,
    Object? slug = null,
    Object? description = freezed,
    Object? brand = freezed,
    Object? unit = null,
    Object? basePrice = null,
    Object? salePrice = freezed,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? stockQty = null,
    Object? minOrderQty = null,
    Object? weight = freezed,
    Object? volume = freezed,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? totalSold = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? variants = freezed,
    Object? images = freezed,
    Object? category = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
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
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as String,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      stockQty: null == stockQty
          ? _value.stockQty
          : stockQty // ignore: cast_nullable_to_non_nullable
              as int,
      minOrderQty: null == minOrderQty
          ? _value.minOrderQty
          : minOrderQty // ignore: cast_nullable_to_non_nullable
              as int,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      totalSold: null == totalSold
          ? _value.totalSold
          : totalSold // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      variants: freezed == variants
          ? _value.variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariant>?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImage>?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
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

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sellerId,
      String categoryId,
      String name,
      String? nameRu,
      String? nameEn,
      String slug,
      String? description,
      String? brand,
      String unit,
      String basePrice,
      String? salePrice,
      String? sku,
      String? barcode,
      int stockQty,
      int minOrderQty,
      double? weight,
      double? volume,
      bool isActive,
      bool isFeatured,
      String status,
      String? rejectionReason,
      int totalSold,
      double rating,
      int reviewCount,
      List<ProductVariant>? variants,
      List<ProductImage>? images,
      Category? category,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $CategoryCopyWith<$Res>? get category;
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? categoryId = null,
    Object? name = null,
    Object? nameRu = freezed,
    Object? nameEn = freezed,
    Object? slug = null,
    Object? description = freezed,
    Object? brand = freezed,
    Object? unit = null,
    Object? basePrice = null,
    Object? salePrice = freezed,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? stockQty = null,
    Object? minOrderQty = null,
    Object? weight = freezed,
    Object? volume = freezed,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? totalSold = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? variants = freezed,
    Object? images = freezed,
    Object? category = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
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
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as String,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      stockQty: null == stockQty
          ? _value.stockQty
          : stockQty // ignore: cast_nullable_to_non_nullable
              as int,
      minOrderQty: null == minOrderQty
          ? _value.minOrderQty
          : minOrderQty // ignore: cast_nullable_to_non_nullable
              as int,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      totalSold: null == totalSold
          ? _value.totalSold
          : totalSold // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      variants: freezed == variants
          ? _value._variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariant>?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImage>?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
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
class _$ProductImpl implements _Product {
  const _$ProductImpl(
      {required this.id,
      required this.sellerId,
      required this.categoryId,
      required this.name,
      this.nameRu,
      this.nameEn,
      required this.slug,
      this.description,
      this.brand,
      this.unit = 'pcs',
      required this.basePrice,
      this.salePrice,
      this.sku,
      this.barcode,
      this.stockQty = 0,
      this.minOrderQty = 1,
      this.weight,
      this.volume,
      this.isActive = true,
      this.isFeatured = false,
      this.status = 'pending',
      this.rejectionReason,
      this.totalSold = 0,
      this.rating = 0.0,
      this.reviewCount = 0,
      final List<ProductVariant>? variants,
      final List<ProductImage>? images,
      this.category,
      this.createdAt,
      this.updatedAt})
      : _variants = variants,
        _images = images;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  final String sellerId;
  @override
  final String categoryId;
  @override
  final String name;
  @override
  final String? nameRu;
  @override
  final String? nameEn;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final String? brand;
  @override
  @JsonKey()
  final String unit;
  @override
  final String basePrice;
  @override
  final String? salePrice;
  @override
  final String? sku;
  @override
  final String? barcode;
  @override
  @JsonKey()
  final int stockQty;
  @override
  @JsonKey()
  final int minOrderQty;
  @override
  final double? weight;
  @override
  final double? volume;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final String status;
  @override
  final String? rejectionReason;
  @override
  @JsonKey()
  final int totalSold;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewCount;
  final List<ProductVariant>? _variants;
  @override
  List<ProductVariant>? get variants {
    final value = _variants;
    if (value == null) return null;
    if (_variants is EqualUnmodifiableListView) return _variants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ProductImage>? _images;
  @override
  List<ProductImage>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Category? category;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Product(id: $id, sellerId: $sellerId, categoryId: $categoryId, name: $name, nameRu: $nameRu, nameEn: $nameEn, slug: $slug, description: $description, brand: $brand, unit: $unit, basePrice: $basePrice, salePrice: $salePrice, sku: $sku, barcode: $barcode, stockQty: $stockQty, minOrderQty: $minOrderQty, weight: $weight, volume: $volume, isActive: $isActive, isFeatured: $isFeatured, status: $status, rejectionReason: $rejectionReason, totalSold: $totalSold, rating: $rating, reviewCount: $reviewCount, variants: $variants, images: $images, category: $category, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameRu, nameRu) || other.nameRu == nameRu) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.stockQty, stockQty) ||
                other.stockQty == stockQty) &&
            (identical(other.minOrderQty, minOrderQty) ||
                other.minOrderQty == minOrderQty) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.totalSold, totalSold) ||
                other.totalSold == totalSold) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            const DeepCollectionEquality().equals(other._variants, _variants) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        sellerId,
        categoryId,
        name,
        nameRu,
        nameEn,
        slug,
        description,
        brand,
        unit,
        basePrice,
        salePrice,
        sku,
        barcode,
        stockQty,
        minOrderQty,
        weight,
        volume,
        isActive,
        isFeatured,
        status,
        rejectionReason,
        totalSold,
        rating,
        reviewCount,
        const DeepCollectionEquality().hash(_variants),
        const DeepCollectionEquality().hash(_images),
        category,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  const factory _Product(
      {required final String id,
      required final String sellerId,
      required final String categoryId,
      required final String name,
      final String? nameRu,
      final String? nameEn,
      required final String slug,
      final String? description,
      final String? brand,
      final String unit,
      required final String basePrice,
      final String? salePrice,
      final String? sku,
      final String? barcode,
      final int stockQty,
      final int minOrderQty,
      final double? weight,
      final double? volume,
      final bool isActive,
      final bool isFeatured,
      final String status,
      final String? rejectionReason,
      final int totalSold,
      final double rating,
      final int reviewCount,
      final List<ProductVariant>? variants,
      final List<ProductImage>? images,
      final Category? category,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  String get sellerId;
  @override
  String get categoryId;
  @override
  String get name;
  @override
  String? get nameRu;
  @override
  String? get nameEn;
  @override
  String get slug;
  @override
  String? get description;
  @override
  String? get brand;
  @override
  String get unit;
  @override
  String get basePrice;
  @override
  String? get salePrice;
  @override
  String? get sku;
  @override
  String? get barcode;
  @override
  int get stockQty;
  @override
  int get minOrderQty;
  @override
  double? get weight;
  @override
  double? get volume;
  @override
  bool get isActive;
  @override
  bool get isFeatured;
  @override
  String get status;
  @override
  String? get rejectionReason;
  @override
  int get totalSold;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  List<ProductVariant>? get variants;
  @override
  List<ProductImage>? get images;
  @override
  Category? get category;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
