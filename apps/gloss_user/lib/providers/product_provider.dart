import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'auth_provider.dart';

class ProductState {
  final List<Product> products;
  final List<Product> featuredProducts;
  final List<Category> categories;
  final Product? selectedProduct;
  final bool isLoading;
  final bool isLoadingDetail;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final String? searchQuery;
  final String? categoryId;

  const ProductState({
    this.products = const [],
    this.featuredProducts = const [],
    this.categories = const [],
    this.selectedProduct,
    this.isLoading = false,
    this.isLoadingDetail = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.searchQuery,
    this.categoryId,
  });

  ProductState copyWith({
    List<Product>? products,
    List<Product>? featuredProducts,
    List<Category>? categories,
    Product? selectedProduct,
    bool? isLoading,
    bool? isLoadingDetail,
    String? error,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
    String? categoryId,
  }) {
    return ProductState(
      products: products ?? this.products,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      categories: categories ?? this.categories,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final Dio _dio;

  ProductNotifier(this._dio) : super(const ProductState()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final futures = await Future.wait([
        _dio.get('/products', queryParameters: {'page': 1, 'limit': 20}),
        _dio.get('/products', queryParameters: {'featured': 'true', 'limit': 10}),
        _dio.get('/categories', queryParameters: {'flat': 'true'}),
      ]);

      final products = (futures[0].data as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
      final featured = (futures[1].data as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
      final categories = (futures[2].data as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        products: products,
        featuredProducts: featured,
        categories: categories,
        isLoading: false,
        hasMore: products.length >= 20,
      );
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<void> loadProducts({bool loadMore = false}) async {
    if (!loadMore) {
      state = state.copyWith(isLoading: true, error: null, currentPage: 1);
    } else if (!state.hasMore || state.isLoading) {
      return;
    }

    try {
      final page = loadMore ? state.currentPage + 1 : 1;
      final response = await _dio.get('/products', queryParameters: {
        'page': page,
        'limit': 20,
        if (state.searchQuery != null && state.searchQuery!.isNotEmpty) 'search': state.searchQuery,
        if (state.categoryId != null) 'categoryId': state.categoryId,
      });

      final newProducts = (response.data['data'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();

      if (loadMore) {
        state = state.copyWith(
          products: [...state.products, ...newProducts],
          currentPage: page,
          hasMore: newProducts.length >= 20,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          products: newProducts,
          currentPage: page,
          hasMore: newProducts.length >= 20,
          isLoading: false,
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query, products: [], currentPage: 1, hasMore: true);
    loadProducts();
  }

  void filterByCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId, products: [], currentPage: 1, hasMore: true);
    loadProducts();
  }

  Future<void> loadProductDetail(String productId) async {
    state = state.copyWith(isLoadingDetail: true, error: null);
    try {
      final response = await _dio.get('/products/$productId');
      final product = Product.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(selectedProduct: product, isLoadingDetail: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoadingDetail: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoadingDetail: false, error: 'Xatolik yuz berdi');
    }
  }

  void clearSelectedProduct() {
    state = state.copyWith(selectedProduct: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Internetga ulanishda xatolik';
    }
    return 'Xatolik yuz berdi';
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductNotifier(dio);
});