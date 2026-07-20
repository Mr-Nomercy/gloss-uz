import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'auth_provider.dart';

class AddressState {
  final List<Address> addresses;
  final bool isLoading;
  final String? error;

  const AddressState({
    this.addresses = const [],
    this.isLoading = false,
    this.error,
  });

  Address? get defaultAddress => addresses.where((a) => a.isDefault).firstOrNull;

  AddressState copyWith({
    List<Address>? addresses,
    bool? isLoading,
    String? error,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AddressNotifier extends StateNotifier<AddressState> {
  final Dio _dio;

  AddressNotifier(this._dio) : super(const AddressState()) {
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/addresses');
      final addresses = (response.data as List)
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(addresses: addresses, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> addAddress({
    required String label,
    required double lat,
    required double lng,
    required String addressLine,
    String? building,
    String? entrance,
    String? floor,
    String? apartment,
    String? doorCode,
    String? comment,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.post('/addresses', data: {
        'label': label,
        'lat': lat,
        'lng': lng,
        'addressLine': addressLine,
        if (building != null) 'building': building,
        if (entrance != null) 'entrance': entrance,
        if (floor != null) 'floor': floor,
        if (apartment != null) 'apartment': apartment,
        if (doorCode != null) 'doorCode': doorCode,
        if (comment != null) 'comment': comment,
      });

      final newAddress = Address.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(
        addresses: [...state.addresses, newAddress],
        isLoading: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> updateAddress(String id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.patch('/addresses/$id', data: data);
      final updated = Address.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(
        addresses: state.addresses.map((a) => a.id == id ? updated : a).toList(),
        isLoading: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> setDefault(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.patch('/addresses/$id/default');
      final updated = Address.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(
        addresses: state.addresses.map((a) => a.id == id ? updated : a).toList(),
        isLoading: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> deleteAddress(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _dio.delete('/addresses/$id');
      state = state.copyWith(
        addresses: state.addresses.where((a) => a.id != id).toList(),
        isLoading: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
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
    return 'Xatolik yuz berdi';
  }
}

final addressProvider = StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  final dio = ref.watch(dioProvider);
  return AddressNotifier(dio);
});