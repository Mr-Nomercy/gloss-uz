import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class WalletState {
  final double balance;
  final List<WalletTransaction> transactions;
  final bool isLoading;
  final bool isLoadingTransactions;
  final bool isWithdrawing;
  final String? error;

  const WalletState({
    this.balance = 0,
    this.transactions = const [],
    this.isLoading = false,
    this.isLoadingTransactions = false,
    this.isWithdrawing = false,
    this.error,
  });

  WalletState copyWith({
    double? balance,
    List<WalletTransaction>? transactions,
    bool? isLoading,
    bool? isLoadingTransactions,
    bool? isWithdrawing,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      isLoadingTransactions: isLoadingTransactions ?? this.isLoadingTransactions,
      isWithdrawing: isWithdrawing ?? this.isWithdrawing,
      error: error,
    );
  }
}

class WalletTransaction {
  final String id;
  final String type; // earning, withdrawal, commission, bonus
  final double amount;
  final String description;
  final DateTime createdAt;
  final String? orderId;
  final String? status;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.orderId,
    this.status,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) => WalletTransaction(
        id: json['id'] as String,
        type: json['type'] as String,
        amount: (json['amount'] as num).toDouble(),
        description: json['description'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        orderId: json['orderId'] as String?,
        status: json['status'] as String?,
      );
}

class WalletNotifier extends StateNotifier<WalletState> {
  final Dio _dio;

  WalletNotifier(this._dio) : super(const WalletState()) {
    loadWallet();
  }

  Future<void> loadWallet() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final futures = await Future.wait([
        _dio.get('/courier/wallet'),
        _dio.get('/courier/wallet/transactions'),
      ]);

      final balance = (futures[0].data['balance'] as num).toDouble();
      final transactions = (futures[1].data as List)
          .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        balance: balance,
        transactions: transactions,
        isLoading: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoadingTransactions: true, error: null);
    try {
      final response = await _dio.get('/courier/wallet/transactions');
      final transactions = (response.data as List)
          .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(transactions: transactions, isLoadingTransactions: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoadingTransactions: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoadingTransactions: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> withdraw(double amount, String cardNumber) async {
    if (amount > state.balance) {
      state = state.copyWith(error: "Balans yetarli emas");
      return false;
    }
    state = state.copyWith(isWithdrawing: true, error: null);
    try {
      await _dio.post('/courier/wallet/withdraw', data: {
        'amount': amount,
        'cardNumber': cardNumber,
      });
      state = state.copyWith(
        balance: state.balance - amount,
        isWithdrawing: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isWithdrawing: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isWithdrawing: false, error: 'Xatolik yuz berdi');
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

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final dio = ref.watch(dioProvider);
  return WalletNotifier(dio);
});