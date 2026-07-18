import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'auth_provider.dart';

class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
      };
}

class CartState {
  final List<CartItem> items;
  final String? promoCode;
  final double? discountPercent;
  final bool isLoading;
  final String? error;

  const CartState({
    this.items = const [],
    this.promoCode,
    this.discountPercent,
    this.isLoading = false,
    this.error,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get discount => discountPercent != null ? subtotal * discountPercent! / 100 : 0;
  double get delivery => subtotal > 100000 ? 0 : 15000;
  double get total => subtotal - discount + delivery;
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    String? promoCode,
    double? discountPercent,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      promoCode: promoCode ?? this.promoCode,
      discountPercent: discountPercent ?? this.discountPercent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final Dio _dio;

  CartNotifier(this._dio) : super(const CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    // Local storage'dan savatni yuklash
  }

  Future<void> _saveCart() async {
    // Local storage'ga saqlash
  }

  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = state.items.indexWhere((item) => item.productId == product.id);
    if (existingIndex >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      final item = CartItem(
        id: product.id,
        productId: product.id,
        name: product.name,
        price: double.tryParse(product.salePrice ?? product.basePrice) ?? 0,
        quantity: quantity,
        imageUrl: product.images?.firstOrNull?.url,
      );
      state = state.copyWith(items: [...state.items, item]);
    }
    _saveCart();
  }

  void removeItem(String productId) {
    state = state.copyWith(items: state.items.where((item) => item.productId != productId).toList());
    _saveCart();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    final index = state.items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[index] = updatedItems[index].copyWith(quantity: quantity);
      state = state.copyWith(items: updatedItems);
      _saveCart();
    }
  }

  void increment(String productId) {
    final index = state.items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      updateQuantity(productId, state.items[index].quantity + 1);
    }
  }

  void decrement(String productId) {
    final index = state.items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      updateQuantity(productId, state.items[index].quantity - 1);
    }
  }

  Future<bool> validatePromoCode(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.post('/promo-codes/validate', data: {
        'code': code,
        'orderAmount': state.subtotal,
      });
      final data = response.data as Map<String, dynamic>;
      if (data['isValid'] == true) {
        final discount = (data['discount'] as num).toDouble();
        state = state.copyWith(
          promoCode: code,
          discountPercent: discount,
          isLoading: false,
        );
        return true;
      }
      state = state.copyWith(isLoading: false, error: "Promo kod noto'g'ri yoki muddati tugagan");
      return false;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  void removePromo() {
    state = state.copyWith(promoCode: null, discountPercent: null);
  }

  Future<bool> checkout({
    required String addressId,
    required String paymentMethod,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.post('/orders', data: {
        'type': 'product',
        'addressId': addressId,
        'paymentMethod': paymentMethod,
        'subtotal': state.subtotal,
        'discount': state.discount,
        'deliveryFee': state.delivery,
        'total': state.total,
        if (state.promoCode != null) 'promoCode': state.promoCode,
        'items': state.items.map((e) => e.toJson()).toList(),
      });

      final data = response.data as Map<String, dynamic>;
      final _ = data['id'] as String;
      clearCart();
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  void clearCart() {
    state = const CartState();
    _saveCart();
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

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final dio = ref.watch(dioProvider);
  return CartNotifier(dio);
});