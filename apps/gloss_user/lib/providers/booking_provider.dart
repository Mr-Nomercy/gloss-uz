import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:constants/constants.dart';
import 'auth_provider.dart';

class BookingState {
  final String? serviceId;
  final String? serviceName;
  final String? selectedTariffId;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? addressId;
  final String? addressText;
  final double? addressLat;
  final double? addressLng;
  final String? paymentMethod;
  final String? promoCode;
  final double? discountPercent;
  final bool isLoading;
  final String? error;

  const BookingState({
    this.serviceId,
    this.serviceName,
    this.selectedTariffId,
    this.selectedDate,
    this.selectedTime,
    this.addressId,
    this.addressText,
    this.addressLat,
    this.addressLng,
    this.paymentMethod = 'cash',
    this.promoCode,
    this.discountPercent,
    this.isLoading = false,
    this.error,
  });

  bool get isReady =>
      serviceId != null &&
      selectedDate != null &&
      selectedTime != null &&
      addressId != null &&
      paymentMethod != null;

  BookingState copyWith({
    String? serviceId,
    String? serviceName,
    String? selectedTariffId,
    DateTime? selectedDate,
    String? selectedTime,
    String? addressId,
    String? addressText,
    double? addressLat,
    double? addressLng,
    String? paymentMethod,
    String? promoCode,
    double? discountPercent,
    bool? isLoading,
    String? error,
  }) {
    return BookingState(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      selectedTariffId: selectedTariffId ?? this.selectedTariffId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      addressId: addressId ?? this.addressId,
      addressText: addressText ?? this.addressText,
      addressLat: addressLat ?? this.addressLat,
      addressLng: addressLng ?? this.addressLng,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      discountPercent: discountPercent ?? this.discountPercent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  final Dio _dio;

  BookingNotifier(this._dio) : super(const BookingState());

  void setService(String id, String name) {
    state = state.copyWith(serviceId: id, serviceName: name);
  }

  void setTariff(String tariffId) {
    state = state.copyWith(selectedTariffId: tariffId);
  }

  void setDateTime(DateTime date, String time) {
    state = state.copyWith(selectedDate: date, selectedTime: time);
  }

  void setAddress(String id, String text, double lat, double lng) {
    state = state.copyWith(
      addressId: id,
      addressText: text,
      addressLat: lat,
      addressLng: lng,
    );
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  Future<bool> validatePromoCode(String code) async {
    try {
      final response = await _dio.post('/promo-codes/validate', data: {
        'code': code,
        'orderAmount': 0,
      });
      final data = response.data as Map<String, dynamic>;
      if (data['isValid'] == true) {
        final discount = (data['discount'] as num).toDouble();
        state = state.copyWith(
          promoCode: code,
          discountPercent: discount,
        );
        return true;
      }
      return false;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }

  void removePromo() {
    state = state.copyWith(promoCode: null, discountPercent: null);
  }

  int calculateTotal(int basePrice) {
    if (state.discountPercent != null) {
      final discount = basePrice * state.discountPercent! ~/ 100;
      return basePrice - discount;
    }
    return basePrice;
  }

  Future<String?> createOrder() async {
    if (!state.isReady) return null;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final scheduledAt = DateTime(
        state.selectedDate!.year,
        state.selectedDate!.month,
        state.selectedDate!.day,
        int.parse(state.selectedTime!.split(':')[0]),
        int.parse(state.selectedTime!.split(':')[1]),
      ).toUtc().toIso8601String();

      final response = await _dio.post('/orders', data: {
        'type': OrderType.service,
        'serviceId': state.serviceId,
        'tariffId': state.selectedTariffId,
        'addressId': state.addressId,
        'scheduledAt': scheduledAt,
        'paymentMethod': state.paymentMethod,
        if (state.promoCode != null) 'promoCode': state.promoCode,
      });

      final data = response.data as Map<String, dynamic>;
      final orderId = data['id'] as String;
      state = state.copyWith(isLoading: false);
      return orderId;
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data as Map)['message'] as String?
          : null;
      state = state.copyWith(isLoading: false, error: msg ?? 'Xatolik yuz berdi');
      return null;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      return null;
    }
  }

  void reset() {
    state = const BookingState();
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  final dio = ref.watch(dioProvider);
  return BookingNotifier(dio);
});
