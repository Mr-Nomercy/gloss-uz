import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'auth_provider.dart';

class ProductState {
  final List<Product> products;
  final List<Category> categories;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const ProductState({
    this.products = const [],
    this.categories = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  ProductState copyWith({
    List<Product>? products,
    List<Category>? categories,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return ProductState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
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
        _dio.get('/products', queryParameters: {'sellerId': 'me', 'page': 1, 'limit': 20}),
        _dio.get('/categories', queryParameters: {'flat': 'true'}),
      ]);

      final products = (futures[0].data['data'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
      final categories = (futures[1].data as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        products: products,
        categories: categories,
        currentPage: 1,
        hasMore: products.length >= 20,
        isLoading: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<void> loadProducts({bool loadMore = false}) async {
    if (loadMore) {
      if (!state.hasMore || state.isLoadingMore) return;
      state = state.copyWith(isLoadingMore: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final page = loadMore ? state.currentPage + 1 : 1;
      final response = await _dio.get('/products', queryParameters: {
        'sellerId': 'me',
        'page': page,
        'limit': 20,
      });

      final newProducts = (response.data['data'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();

      if (loadMore) {
        state = state.copyWith(
          products: [...state.products, ...newProducts],
          currentPage: page,
          hasMore: newProducts.length >= 20,
          isLoadingMore: false,
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
      if (loadMore) {
        state = state.copyWith(isLoadingMore: false, error: _handleError(e));
      } else {
        state = state.copyWith(isLoading: false, error: _handleError(e));
      }
    } catch (_) {
      if (loadMore) {
        state = state.copyWith(isLoadingMore: false, error: 'Xatolik yuz berdi');
      } else {
        state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      }
    }
  }

  Future<bool> createProduct(Map<String, dynamic> data) async {
    state = state.copyWith(isCreating: true, error: null);
    try {
      final response = await _dio.post('/products', data: data);
      final product = Product.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(
        products: [product, ...state.products],
        isCreating: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isCreating: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isCreating: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> updateProduct(String id, Map<String, dynamic> data) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      final response = await _dio.patch('/products/$id', data: data);
      final product = Product.fromJson(response.data as Map<String, dynamic>);
      final newProducts = state.products.map((p) => p.id == id ? product : p).toList();
      state = state.copyWith(products: newProducts, isUpdating: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isUpdating: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isUpdating: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    state = state.copyWith(isDeleting: true, error: null);
    try {
      await _dio.delete('/products/$id');
      state = state.copyWith(
        products: state.products.where((p) => p.id != id).toList(),
        isDeleting: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isDeleting: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isDeleting: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Internetga ulanishda xatolik';
    }
    if (e.response?.statusCode == 401) {
      return 'Sessiya tugadi, qayta kiring';
    }
    if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
    }
    return 'Xatolik yuz berdi';
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductNotifier(dio);
});