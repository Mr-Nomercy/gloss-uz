import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'auth_provider.dart';

class FavoritesState {
  final Set<String> favoriteIds;
  final List<Product> favoriteProducts;
  final bool isLoading;
  final String? error;

  const FavoritesState({
    this.favoriteIds = const {},
    this.favoriteProducts = const [],
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    Set<String>? favoriteIds,
    List<Product>? favoriteProducts,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final Dio _dio;

  FavoritesNotifier(this._dio) : super(const FavoritesState()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/favorites');
      final productIds = (response.data['products'] as List)
          .map((e) => e['id'] as String)
          .toSet();
      final products = (response.data['products'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(
        favoriteIds: productIds,
        favoriteProducts: products,
        isLoading: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> toggleFavorite(Product product) async {
    final isFavorite = state.favoriteIds.contains(product.id);
    final newIds = Set<String>.from(state.favoriteIds);
    final newProducts = List<Product>.from(state.favoriteProducts);

    if (isFavorite) {
      newIds.remove(product.id);
      newProducts.removeWhere((p) => p.id == product.id);
    } else {
      newIds.add(product.id);
      newProducts.add(product);
    }

    state = state.copyWith(favoriteIds: newIds, favoriteProducts: newProducts);

    try {
      if (isFavorite) {
        await _dio.delete('/favorites/${product.id}');
      } else {
        await _dio.post('/favorites', data: {'productId': product.id});
      }
      return true;
    } on DioException {
      // Rollback on error
      loadFavorites();
      return false;
    }
  }

  bool isFavorite(String productId) => state.favoriteIds.contains(productId);

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

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  final dio = ref.watch(dioProvider);
  return FavoritesNotifier(dio);
});