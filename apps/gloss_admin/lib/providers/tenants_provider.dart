import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class Tenant {
  final String id;
  final String companyName;
  final String phone;
  final String? email;
  final String? logoUrl;
  final double rating;
  final int totalOrders;
  final int totalWorkers;
  final double commissionRate;
  final bool isActive;
  final bool isVerified;
  final DateTime? createdAt;

  const Tenant({
    required this.id,
    required this.companyName,
    required this.phone,
    this.email,
    this.logoUrl,
    this.rating = 0,
    this.totalOrders = 0,
    this.totalWorkers = 0,
    this.commissionRate = 0.15,
    this.isActive = true,
    this.isVerified = false,
    this.createdAt,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
        id: json['id'] as String,
        companyName: json['companyName'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String?,
        logoUrl: json['logoUrl'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
        totalWorkers: (json['totalWorkers'] as num?)?.toInt() ?? 0,
        commissionRate:
            (json['commissionRate'] as num?)?.toDouble() ?? 0.15,
        isActive: json['isActive'] as bool? ?? true,
        isVerified: json['isVerified'] as bool? ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
      );
}

class TenantDetail {
  final Tenant tenant;
  final List<TenantWorker> workers;
  final List<TenantOrder> orders;
  final double balance;
  final double totalEarnings;

  const TenantDetail({
    required this.tenant,
    this.workers = const [],
    this.orders = const [],
    this.balance = 0,
    this.totalEarnings = 0,
  });

  factory TenantDetail.fromJson(Map<String, dynamic> json) => TenantDetail(
        tenant: Tenant.fromJson(json['tenant'] as Map<String, dynamic>),
        workers: (json['workers'] as List?)
                ?.map((e) =>
                    TenantWorker.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        orders: (json['orders'] as List?)
                ?.map((e) =>
                    TenantOrder.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        balance: (json['balance'] as num?)?.toDouble() ?? 0,
        totalEarnings:
            (json['totalEarnings'] as num?)?.toDouble() ?? 0,
      );
}

class TenantWorker {
  final String id;
  final String fullName;
  final String phone;
  final bool isActive;

  const TenantWorker({
    required this.id,
    required this.fullName,
    required this.phone,
    this.isActive = true,
  });

  factory TenantWorker.fromJson(Map<String, dynamic> json) => TenantWorker(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        phone: json['phone'] as String,
        isActive: json['isActive'] as bool? ?? true,
      );
}

class TenantOrder {
  final String id;
  final String orderNumber;
  final String status;
  final double amount;
  final DateTime createdAt;

  const TenantOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.amount,
    required this.createdAt,
  });

  factory TenantOrder.fromJson(Map<String, dynamic> json) => TenantOrder(
        id: json['id'] as String,
        orderNumber: json['orderNumber'] as String,
        status: json['status'] as String,
        amount: (json['amount'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class TenantsState {
  final List<Tenant> tenants;
  final TenantDetail? selectedTenant;
  final bool isLoading;
  final bool isLoadingDetail;
  final bool isUpdating;
  final String? error;
  final String searchQuery;

  const TenantsState({
    this.tenants = const [],
    this.selectedTenant,
    this.isLoading = false,
    this.isLoadingDetail = false,
    this.isUpdating = false,
    this.error,
    this.searchQuery = '',
  });

  List<Tenant> get filteredTenants {
    if (searchQuery.isEmpty) return tenants;
    final q = searchQuery.toLowerCase();
    return tenants.where((t) {
      return t.companyName.toLowerCase().contains(q) ||
          t.phone.contains(q) ||
          (t.email?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  TenantsState copyWith({
    List<Tenant>? tenants,
    TenantDetail? selectedTenant,
    bool? isLoading,
    bool? isLoadingDetail,
    bool? isUpdating,
    String? error,
    String? searchQuery,
  }) {
    return TenantsState(
      tenants: tenants ?? this.tenants,
      selectedTenant: selectedTenant ?? this.selectedTenant,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TenantsNotifier extends StateNotifier<TenantsState> {
  final Dio _dio;

  TenantsNotifier(this._dio) : super(const TenantsState()) {
    loadTenants();
  }

  Future<void> loadTenants() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/admin/tenants');
      final tenants = (response.data as List)
          .map((e) => Tenant.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(tenants: tenants, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<void> loadTenantDetail(String tenantId) async {
    state = state.copyWith(isLoadingDetail: true, error: null);
    try {
      final response = await _dio.get('/admin/tenants/$tenantId');
      final detail =
          TenantDetail.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(
          selectedTenant: detail, isLoadingDetail: false);
    } on DioException catch (e) {
      state = state.copyWith(
          isLoadingDetail: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(
          isLoadingDetail: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> toggleTenant(String tenantId, bool isActive) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      await _dio.patch('/admin/tenants/$tenantId', data: {
        'isActive': isActive,
      });
      final updated = state.tenants.map((t) {
        if (t.id == tenantId) {
          return Tenant(
            id: t.id,
            companyName: t.companyName,
            phone: t.phone,
            email: t.email,
            logoUrl: t.logoUrl,
            rating: t.rating,
            totalOrders: t.totalOrders,
            totalWorkers: t.totalWorkers,
            commissionRate: t.commissionRate,
            isActive: isActive,
            isVerified: t.isVerified,
            createdAt: t.createdAt,
          );
        }
        return t;
      }).toList();
      state = state.copyWith(tenants: updated, isUpdating: false);
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

  Future<bool> updateCommission(
      String tenantId, double commissionRate) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      await _dio.patch('/admin/tenants/$tenantId/commission', data: {
        'commissionRate': commissionRate,
      });
      final updated = state.tenants.map((t) {
        if (t.id == tenantId) {
          return Tenant(
            id: t.id,
            companyName: t.companyName,
            phone: t.phone,
            email: t.email,
            logoUrl: t.logoUrl,
            rating: t.rating,
            totalOrders: t.totalOrders,
            totalWorkers: t.totalWorkers,
            commissionRate: commissionRate,
            isActive: t.isActive,
            isVerified: t.isVerified,
            createdAt: t.createdAt,
          );
        }
        return t;
      }).toList();
      state = state.copyWith(tenants: updated, isUpdating: false);
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

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
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

final tenantsProvider =
    StateNotifierProvider<TenantsNotifier, TenantsState>((ref) {
  final dio = ref.watch(dioProvider);
  return TenantsNotifier(dio);
});
