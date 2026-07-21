import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

/// Mirrors apps/delivery/serializers.py's DeliveryAssignmentSerializer —
/// no shared freezed model exists yet for this (packages/shared/models
/// only has the cleaning-order `Order`), so this is a plain class local
/// to this app, same pattern gloss_admin uses for its ad-hoc market
/// models.
class DeliveryAssignment {
  final String id;
  final String marketOrder;
  final String address;
  final String totalPrice;
  final String? courier;
  final String status;
  final String createdAt;
  final String? assignedAt;
  final String? pickedUpAt;
  final String? deliveredAt;

  const DeliveryAssignment({
    required this.id,
    required this.marketOrder,
    required this.address,
    required this.totalPrice,
    required this.courier,
    required this.status,
    required this.createdAt,
    this.assignedAt,
    this.pickedUpAt,
    this.deliveredAt,
  });

  factory DeliveryAssignment.fromJson(Map<String, dynamic> json) {
    return DeliveryAssignment(
      id: json['id'].toString(),
      marketOrder: json['marketOrder'].toString(),
      address: json['address'] as String? ?? '',
      totalPrice: json['totalPrice']?.toString() ?? '0',
      courier: json['courier']?.toString(),
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      assignedAt: json['assignedAt'] as String?,
      pickedUpAt: json['pickedUpAt'] as String?,
      deliveredAt: json['deliveredAt'] as String?,
    );
  }
}

class OrderState {
  // Unclaimed offers any courier can accept.
  final List<DeliveryAssignment> pendingAssignments;
  // The one assignment this courier is currently working, if any —
  // backend only ever returns at most one (accepted/picked_up) per
  // courier in the same list response.
  final DeliveryAssignment? activeAssignment;
  final bool isLoading;
  final bool isLoadingAction;
  final String? error;

  const OrderState({
    this.pendingAssignments = const [],
    this.activeAssignment,
    this.isLoading = false,
    this.isLoadingAction = false,
    this.error,
  });

  OrderState copyWith({
    List<DeliveryAssignment>? pendingAssignments,
    DeliveryAssignment? activeAssignment,
    bool clearActiveAssignment = false,
    bool? isLoading,
    bool? isLoadingAction,
    String? error,
  }) {
    return OrderState(
      pendingAssignments: pendingAssignments ?? this.pendingAssignments,
      activeAssignment:
          clearActiveAssignment ? null : (activeAssignment ?? this.activeAssignment),
      isLoading: isLoading ?? this.isLoading,
      isLoadingAction: isLoadingAction ?? this.isLoadingAction,
      error: error,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final Dio _dio;

  OrderNotifier(this._dio) : super(const OrderState()) {
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/delivery/assignments/');
      final results = (response.data['results'] as List? ?? [])
          .map((e) => DeliveryAssignment.fromJson(e as Map<String, dynamic>))
          .toList();

      final pending = results.where((a) => a.status == 'pending').toList();
      final active = results.where((a) => a.status != 'pending').firstOrNull;

      state = state.copyWith(
        pendingAssignments: pending,
        activeAssignment: active,
        clearActiveAssignment: active == null,
        isLoading: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> acceptAssignment(String assignmentId) async {
    state = state.copyWith(isLoadingAction: true, error: null);
    try {
      await _dio.post('/delivery/assignments/$assignmentId/accept/');
      state = state.copyWith(isLoadingAction: false);
      await loadAssignments();
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoadingAction: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoadingAction: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  /// [status] must be the backend's next expected value — 'picked_up'
  /// from 'accepted', 'delivered' from 'picked_up' (see
  /// apps.delivery.views._NEXT_STATUS).
  Future<bool> updateAssignmentStatus(String assignmentId, String status) async {
    state = state.copyWith(isLoadingAction: true, error: null);
    try {
      await _dio.patch('/delivery/assignments/$assignmentId/status/', data: {'status': status});
      state = state.copyWith(isLoadingAction: false);
      await loadAssignments();
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoadingAction: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoadingAction: false, error: 'Xatolik yuz berdi');
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
    if (e.response?.statusCode == 403) {
      return 'Siz kuryer emassiz';
    }
    if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
    }
    if (e.response?.statusCode == 409) {
      return 'Bu buyurtma allaqachon qabul qilingan';
    }
    return 'Xatolik yuz berdi';
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderNotifier(dio);
});
