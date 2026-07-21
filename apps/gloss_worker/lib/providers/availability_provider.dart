import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class AvailabilityState {
  final Map<int, DayAvailability> schedule;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  const AvailabilityState({
    this.schedule = const {},
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  bool isDayEnabled(int dayIndex) => schedule[dayIndex]?.isEnabled ?? false;
  TimeOfDay? getStartTime(int dayIndex) => schedule[dayIndex]?.startTime;
  TimeOfDay? getEndTime(int dayIndex) => schedule[dayIndex]?.endTime;

  AvailabilityState copyWith({
    Map<int, DayAvailability>? schedule,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return AvailabilityState(
      schedule: schedule ?? this.schedule,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class DayAvailability {
  final bool isEnabled;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  const DayAvailability({
    this.isEnabled = false,
    this.startTime,
    this.endTime,
  });

  DayAvailability copyWith({
    bool? isEnabled,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return DayAvailability(
      isEnabled: isEnabled ?? this.isEnabled,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': isEnabled,
        'startTime': startTime != null
            ? '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}'
            : null,
        'endTime': endTime != null
            ? '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}'
            : null,
      };
}

class AvailabilityNotifier extends StateNotifier<AvailabilityState> {
  final Dio _dio;

  AvailabilityNotifier(this._dio) : super(const AvailabilityState()) {
    loadAvailability();
  }

  Future<void> loadAvailability() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/provider/availability');
      final data = response.data as Map<String, dynamic>;
      final schedule = <int, DayAvailability>{};

      for (int i = 0; i < 7; i++) {
        final dayKey = _dayKey(i);
        if (data[dayKey] != null) {
          final dayData = data[dayKey] as Map<String, dynamic>;
          schedule[i] = DayAvailability(
            isEnabled: dayData['enabled'] as bool? ?? false,
            startTime: _parseTime(dayData['startTime']),
            endTime: _parseTime(dayData['endTime']),
          );
        } else {
          schedule[i] = const DayAvailability();
        }
      }

      state = state.copyWith(schedule: schedule, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> updateDay(int dayIndex, DayAvailability availability) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      await _dio.patch('/provider/availability', data: {
        _dayKey(dayIndex): availability.toJson(),
      });
      final newSchedule = Map<int, DayAvailability>.from(state.schedule);
      newSchedule[dayIndex] = availability;
      state = state.copyWith(schedule: newSchedule, isSaving: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isSaving: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isSaving: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> toggleDay(int dayIndex, bool enabled) async {
    final current = state.schedule[dayIndex] ?? const DayAvailability();
    return updateDay(dayIndex, current.copyWith(isEnabled: enabled));
  }

  Future<bool> setTime(int dayIndex, {TimeOfDay? startTime, TimeOfDay? endTime}) async {
    final current = state.schedule[dayIndex] ?? const DayAvailability();
    return updateDay(dayIndex, current.copyWith(startTime: startTime, endTime: endTime));
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _dayKey(int dayIndex) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    return days[dayIndex];
  }

  TimeOfDay? _parseTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
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

final availabilityProvider = StateNotifierProvider<AvailabilityNotifier, AvailabilityState>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return AvailabilityNotifier(dio);
  },
);