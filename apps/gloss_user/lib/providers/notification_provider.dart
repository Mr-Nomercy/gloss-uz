import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final String? orderId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.orderId,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        type: json['type'] as String,
        orderId: json['orderId'] as String?,
        isRead: json['isRead'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class NotificationState {
  final List<NotificationItem> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationItem>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final Dio _dio;

  NotificationNotifier(this._dio) : super(const NotificationState()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/notifications');
      final notifications = (response.data as List)
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList();
      final unread = notifications.where((n) => !n.isRead).length;
      state = state.copyWith(
        notifications: notifications,
        unreadCount: unread,
        isLoading: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _dio.patch('/notifications/$id/read');
      final updated = state.notifications.map((n) {
        if (n.id == id) {
          return NotificationItem(
            id: n.id,
            title: n.title,
            message: n.message,
            type: n.type,
            orderId: n.orderId,
            isRead: true,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();
      state = state.copyWith(
        notifications: updated,
        unreadCount: updated.where((n) => !n.isRead).length,
      );
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await _dio.patch('/notifications/read-all');
      final updated = state.notifications.map((n) => NotificationItem(
            id: n.id,
            title: n.title,
            message: n.message,
            type: n.type,
            orderId: n.orderId,
            isRead: true,
            createdAt: n.createdAt,
          )).toList();
      state = state.copyWith(notifications: updated, unreadCount: 0);
    } catch (_) {}
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

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationNotifier(dio);
});