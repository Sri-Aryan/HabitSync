import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/habit_model.dart';
import '../utils/notification_service.dart';

class HabitNotifier extends StateNotifier<List<Habit>> {
  HabitNotifier() : super([]) {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getStringList('habits') ?? [];
    state = habitsJson
        .map((json) => Habit.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = state
        .map((habit) => jsonEncode(habit.toJson()))
        .toList();
    await prefs.setStringList('habits', habitsJson);
  }

  Future<void> addHabit(Habit habit) async {
    state = [...state, habit];
    await _saveHabits();

    // Schedule notification if reminder time is set
    if (habit.reminderTime != null) {
      // Cancel any existing notification with same ID first
     // await NotificationService.cancelNotification(habit.id.hashCode);

      // Schedule new notification
      await NotificationService.scheduleNotification(
        id: habit.id.hashCode,
        title: '${habit.icon} ${habit.name}',
        body: 'Time to complete your habit!',
        scheduledTime: habit.reminderTime!,
        quote: habit.quote,
      );

      // Verify it was scheduled
      print('✅ Notification scheduled successfully for habit: ${habit.name}');
      await NotificationService.debugPrintPendingNotifications();
    } else {
      print('⚠️ No reminder time set for habit: ${habit.name}');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    state = [
      for (final h in state)
        if (h.id == habit.id) habit else h,
    ];
    await _saveHabits();

    // Cancel old notification and schedule new one
    await NotificationService.cancelNotification(habit.id.hashCode);

    if (habit.reminderTime != null) {
      await NotificationService.scheduleNotification(
        id: habit.id.hashCode,
        title: '${habit.icon} ${habit.name}',
        body: 'Time to complete your habit!',
        scheduledTime: habit.reminderTime!,
        quote: habit.quote,
      );
      print('✅ Notification updated for habit: ${habit.name}');
      await NotificationService.debugPrintPendingNotifications();
    } else {
      print('⚠️ Reminder removed for habit: ${habit.name}');
    }
  }

  Future<void> deleteHabit(String id) async {
    final habit = state.firstWhere((h) => h.id == id);
    await NotificationService.cancelNotification(habit.id.hashCode);
    state = state.where((h) => h.id != id).toList();
    await _saveHabits();
    print('🗑️ Habit deleted: ${habit.name}');
  }

  Future<void> toggleCompletion(String habitId) async {
    final today = DateTime.now();
    final key = '${today.year}-${today.month}-${today.day}';

    state = [
      for (final habit in state)
        if (habit.id == habitId)
          habit.copyWith(
            completions: {
              ...habit.completions,
              key: !(habit.completions[key] ?? false),
            },
          )
        else
          habit,
    ];
    await _saveHabits();
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  return HabitNotifier();
});
