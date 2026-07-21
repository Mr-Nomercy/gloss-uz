import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class AppUser {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final List<String> roles;
  final bool isBlocked;
  final int totalOrders;
  final double totalSpent;
  final DateTime? createdAt;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.roles = const ['client'],
    this.isBlocked = false,
    this.totalOrders = 0,
    this.totalSpent = 0,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        roles: (json['roles'] as List?)?.map((e) => e as String).toList() ??
            ['client'],
        isBlocked: json['isBlocked'] as bool? ?? false,
        totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
        totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
      );

  String get roleLabel {
    if (roles.contains('super_admin')) return 'Super Admin';
    if (roles.contains('admin')) return 'Admin';
    if (roles.contains('provider')) return 'Provayder';
    if (roles.contains('courier')) return 'Kuryer';
    return 'Mijoz';
  }
}

class UserDetail {
  final AppUser user;
  final List<Map<String, dynamic>> recentOrders;
  final List<Map<String, dynamic>> addresses;

  const UserDetail({
    required this.user,
    this.recentOrders = const [],
    this.addresses = const [],
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
        recentOrders: (json['recentOrders'] as List?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [],
        addresses: (json['addresses'] as List?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [],
      );
}

class UsersState {
  final List<AppUser> users;
  final UserDetail? selectedUser;
  final bool isLoading;
  final bool isLoadingDetail;
  final bool isUpdating;
  final String? error;
  final String searchQuery;
  final String roleFilter;

  const UsersState({
    this.users = const [],
    this.selectedUser,
    this.isLoading = false,
    this.isLoadingDetail = false,
    this.isUpdating = false,
    this.error,
    this.searchQuery = '',
    this.roleFilter = 'all',
  });

  List<AppUser> get filteredUsers {
    var result = users;
    if (roleFilter != 'all') {
      result =
          result.where((u) => u.roles.contains(roleFilter)).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((u) {
        return u.fullName.toLowerCase().contains(q) ||
            u.phone.contains(q) ||
            (u.email?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    return result;
  }

  UsersState copyWith({
    List<AppUser>? users,
    UserDetail? selectedUser,
    bool? isLoading,
    bool? isLoadingDetail,
    bool? isUpdating,
    String? error,
    String? searchQuery,
    String? roleFilter,
  }) {
    return UsersState(
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      roleFilter: roleFilter ?? this.roleFilter,
    );
  }
}

class UsersNotifier extends StateNotifier<UsersState> {
  final Dio _dio;

  UsersNotifier(this._dio) : super(const UsersState()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/admin/users');
      final users = (response.data as List)
          .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(users: users, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<void> loadUserDetail(String userId) async {
    state = state.copyWith(isLoadingDetail: true, error: null);
    try {
      final response = await _dio.get('/admin/users/$userId');
      final detail =
          UserDetail.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(
          selectedUser: detail, isLoadingDetail: false);
    } on DioException catch (e) {
      state = state.copyWith(
          isLoadingDetail: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(
          isLoadingDetail: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> toggleBlock(String userId, bool isBlocked) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      await _dio.patch('/admin/users/$userId', data: {
        'isBlocked': isBlocked,
      });
      final updated = state.users.map((u) {
        if (u.id == userId) {
          return AppUser(
            id: u.id,
            fullName: u.fullName,
            phone: u.phone,
            email: u.email,
            avatarUrl: u.avatarUrl,
            roles: u.roles,
            isBlocked: isBlocked,
            totalOrders: u.totalOrders,
            totalSpent: u.totalSpent,
            createdAt: u.createdAt,
          );
        }
        return u;
      }).toList();
      state = state.copyWith(users: updated, isUpdating: false);
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

  void setSearch(String query) => state = state.copyWith(searchQuery: query);
  void setRoleFilter(String role) => state = state.copyWith(roleFilter: role);
  void clearError() => state = state.copyWith(error: null);

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Internetga ulanishda xatolik';
    }
    return 'Xatolik yuz berdi';
  }
}

final usersProvider =
    StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  final dio = ref.watch(dioProvider);
  return UsersNotifier(dio);
});
