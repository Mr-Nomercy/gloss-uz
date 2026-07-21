import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class Payout {
  final String id;
  final String providerId;
  final String providerName;
  final double amount;
  final String cardNumber;
  final String status;
  final String? adminNote;
  final DateTime? processedAt;
  final DateTime createdAt;

  const Payout({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.amount,
    required this.cardNumber,
    required this.status,
    this.adminNote,
    this.processedAt,
    required this.createdAt,
  });

  factory Payout.fromJson(Map<String, dynamic> json) => Payout(
        id: json['id'] as String,
        providerId: json['providerId'] as String,
        providerName: json['providerName'] as String,
        amount: (json['amount'] as num).toDouble(),
        cardNumber: json['cardNumber'] as String,
        status: json['status'] as String,
        adminNote: json['adminNote'] as String?,
        processedAt: json['processedAt'] != null
            ? DateTime.parse(json['processedAt'] as String)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class PayoutsState {
  final List<Payout> payouts;
  final bool isLoading;
  final bool isUpdating;
  final String? error;
  final String statusFilter;

  const PayoutsState({
    this.payouts = const [],
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
    this.statusFilter = 'all',
  });

  List<Payout> get filteredPayouts {
    if (statusFilter == 'all') return payouts;
    return payouts.where((p) => p.status == statusFilter).toList();
  }

  PayoutsState copyWith({
    List<Payout>? payouts,
    bool? isLoading,
    bool? isUpdating,
    String? error,
    String? statusFilter,
  }) {
    return PayoutsState(
      payouts: payouts ?? this.payouts,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class PayoutsNotifier extends StateNotifier<PayoutsState> {
  final Dio _dio;

  PayoutsNotifier(this._dio) : super(const PayoutsState()) {
    loadPayouts();
  }

  Future<void> loadPayouts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/admin/payouts');
      final payouts = (response.data as List)
          .map((e) => Payout.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(payouts: payouts, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> approvePayout(String payoutId, {String? note}) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      await _dio.patch('/admin/payouts/$payoutId/approve', data: {
        'adminNote': note,
      });
      final updated = state.payouts.map((p) {
        if (p.id == payoutId) {
          return Payout(
            id: p.id,
            providerId: p.providerId,
            providerName: p.providerName,
            amount: p.amount,
            cardNumber: p.cardNumber,
            status: 'approved',
            adminNote: note,
            processedAt: DateTime.now(),
            createdAt: p.createdAt,
          );
        }
        return p;
      }).toList();
      state = state.copyWith(payouts: updated, isUpdating: false);
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

  Future<bool> rejectPayout(String payoutId, String reason) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      await _dio.patch('/admin/payouts/$payoutId/reject', data: {
        'reason': reason,
      });
      final updated = state.payouts.map((p) {
        if (p.id == payoutId) {
          return Payout(
            id: p.id,
            providerId: p.providerId,
            providerName: p.providerName,
            amount: p.amount,
            cardNumber: p.cardNumber,
            status: 'rejected',
            adminNote: reason,
            processedAt: DateTime.now(),
            createdAt: p.createdAt,
          );
        }
        return p;
      }).toList();
      state = state.copyWith(payouts: updated, isUpdating: false);
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

  void setStatusFilter(String status) {
    state = state.copyWith(statusFilter: status);
  }

  void clearError() => state = state.copyWith(error: null);

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Internetga ulanishda xatolik';
    }
    return 'Xatolik yuz berdi';
  }
}

final payoutsProvider =
    StateNotifierProvider<PayoutsNotifier, PayoutsState>((ref) {
  final dio = ref.watch(dioProvider);
  return PayoutsNotifier(dio);
});
