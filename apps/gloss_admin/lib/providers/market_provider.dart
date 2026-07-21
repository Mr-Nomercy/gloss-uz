import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class MarketProduct {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? salePrice;
  final int stockQty;
  final String? categoryId;
  final String? categoryName;
  final String? sellerId;
  final String? sellerName;
  final List<String> imageUrls;
  final double rating;
  final bool isActive;
  final DateTime? createdAt;

  const MarketProduct({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.salePrice,
    this.stockQty = 0,
    this.categoryId,
    this.categoryName,
    this.sellerId,
    this.sellerName,
    this.imageUrls = const [],
    this.rating = 0,
    this.isActive = true,
    this.createdAt,
  });

  factory MarketProduct.fromJson(Map<String, dynamic> json) => MarketProduct(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        price: (json['price'] as num).toDouble(),
        salePrice: (json['salePrice'] as num?)?.toDouble(),
        stockQty: (json['stockQty'] as num?)?.toInt() ?? 0,
        categoryId: json['categoryId'] as String?,
        categoryName: json['categoryName'] as String?,
        sellerId: json['sellerId'] as String?,
        sellerName: json['sellerName'] as String?,
        imageUrls: (json['imageUrls'] as List?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        isActive: json['isActive'] as bool? ?? true,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
      );
}

class MarketCategory {
  final String id;
  final String name;
  final String? parentId;

  const MarketCategory({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory MarketCategory.fromJson(Map<String, dynamic> json) =>
      MarketCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        parentId: json['parentId'] as String?,
      );
}

class MarketState {
  final List<MarketProduct> products;
  final List<MarketCategory> categories;
  final bool isLoading;
  final bool isUpdating;
  final String? error;
  final String searchQuery;
  final String? categoryFilter;

  const MarketState({
    this.products = const [],
    this.categories = const [],
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
    this.searchQuery = '',
    this.categoryFilter,
  });

  List<MarketProduct> get filteredProducts {
    var result = products;
    if (categoryFilter != null) {
      result = result
          .where((p) => p.categoryId == categoryFilter)
          .toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result
          .where((p) => p.name.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  MarketState copyWith({
    List<MarketProduct>? products,
    List<MarketCategory>? categories,
    bool? isLoading,
    bool? isUpdating,
    String? error,
    String? searchQuery,
    String? categoryFilter,
  }) {
    return MarketState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryFilter: categoryFilter ?? this.categoryFilter,
    );
  }
}

class MarketNotifier extends StateNotifier<MarketState> {
  final Dio _dio;

  MarketNotifier(this._dio) : super(const MarketState()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _dio.get('/admin/market/products'),
        _dio.get('/admin/market/categories'),
      ]);
      final products = (results[0].data as List)
          .map((e) =>
              MarketProduct.fromJson(e as Map<String, dynamic>))
          .toList();
      final categories = (results[1].data as List)
          .map((e) =>
              MarketCategory.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(
        products: products,
        categories: categories,
        isLoading: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> deleteProduct(String productId) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      await _dio.delete('/admin/market/products/$productId');
      final updated =
          state.products.where((p) => p.id != productId).toList();
      state = state.copyWith(products: updated, isUpdating: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
          isUpdating: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(
          isUpdating: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> toggleProduct(String productId, bool isActive) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      await _dio.patch('/admin/market/products/$productId', data: {
        'isActive': isActive,
      });
      final updated = state.products.map((p) {
        if (p.id == productId) {
          return MarketProduct(
            id: p.id,
            name: p.name,
            description: p.description,
            price: p.price,
            salePrice: p.salePrice,
            stockQty: p.stockQty,
            categoryId: p.categoryId,
            categoryName: p.categoryName,
            sellerId: p.sellerId,
            sellerName: p.sellerName,
            imageUrls: p.imageUrls,
            rating: p.rating,
            isActive: isActive,
            createdAt: p.createdAt,
          );
        }
        return p;
      }).toList();
      state = state.copyWith(products: updated, isUpdating: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
          isUpdating: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(
          isUpdating: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  void setSearch(String query) => state = state.copyWith(searchQuery: query);
  void setCategoryFilter(String? categoryId) =>
      state = state.copyWith(categoryFilter: categoryId);
  void clearError() => state = state.copyWith(error: null);

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Internetga ulanishda xatolik';
    }
    return 'Xatolik yuz berdi';
  }
}

final marketProvider =
    StateNotifierProvider<MarketNotifier, MarketState>((ref) {
  final dio = ref.watch(dioProvider);
  return MarketNotifier(dio);
});
