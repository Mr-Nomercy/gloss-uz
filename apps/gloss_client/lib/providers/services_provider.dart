import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:constants/constants.dart';

class ServicesState {
  final List<Map<String, dynamic>> serviceTypes;
  final List<Map<String, dynamic>> services;
  final bool isLoading;
  final String? error;

  const ServicesState({
    this.serviceTypes = const [],
    this.services = const [],
    this.isLoading = false,
    this.error,
  });

  ServicesState copyWith({
    List<Map<String, dynamic>>? serviceTypes,
    List<Map<String, dynamic>>? services,
    bool? isLoading,
    String? error,
  }) {
    return ServicesState(
      serviceTypes: serviceTypes ?? this.serviceTypes,
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ServicesNotifier extends StateNotifier<ServicesState> {
  final Dio _dio;

  ServicesNotifier(this._dio) : super(const ServicesState()) {
    loadServices();
  }

  Future<void> loadServices() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final typesRes = await _dio.get('/service-types');
      final servicesRes = await _dio.get('/services');
      state = state.copyWith(
        serviceTypes: List<Map<String, dynamic>>.from(typesRes.data),
        services: List<Map<String, dynamic>>.from(servicesRes.data),
        isLoading: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  List<Map<String, dynamic>> getServicesByType(String serviceTypeId) {
    return state.services.where((s) => s['serviceTypeId'] == serviceTypeId).toList();
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return "Internetga ulanishda xatolik";
    }
    return 'Xatolik yuz berdi';
  }
}

final servicesProvider = StateNotifierProvider<ServicesNotifier, ServicesState>((ref) {
  final dio = ref.watch(dioProvider);
  return ServicesNotifier(dio);
});

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: AppConstants.devBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));
});
