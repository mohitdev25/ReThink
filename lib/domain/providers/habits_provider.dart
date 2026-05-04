import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rethink_app/data/models/habit.dart';
import 'package:rethink_app/core/storage/hive_setup.dart';
import 'package:rethink_app/core/utils/dates.dart';

class HabitsNotifier extends StateNotifier<List<Habit>> {
  final Box<Habit> _box;

  HabitsNotifier(this._box) : super(_box.values.toList()) {
    _recalculateStreaks();
  }

  void _recalculateStreaks() {
    final today = DateUtils.normalizedToday;
    final yesterday = today.subtract(const Duration(days: 1));

    bool changed = false;
    final updatedList = state.map((habit) {
      if (habit.completedDates.isEmpty) return habit;

      final lastCompleted = DateUtils.normalize(habit.completedDates.last);
      // If the habit wasn't completed today or yesterday, streak breaks
      if (!DateUtils.isSameDay(lastCompleted, today) && !DateUtils.isSameDay(lastCompleted, yesterday)) {
        if (habit.streak != 0) {
          changed = true;
          return habit.copyWith(streak: 0);
        }
      }
      return habit;
    }).toList();

    if (changed) {
      for (var h in updatedList) {
        _box.put(h.id, h);
      }
      state = updatedList;
    }
  }

  void addHabit(Habit habit) {
    _box.put(habit.id, habit);
    state = _box.values.toList();
  }

  void deleteHabit(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }

  void toggleCompletion(String id) {
    final habit = _box.get(id);
    if (habit == null) return;

    final today = DateUtils.normalizedToday;
    final isCompletedToday = habit.completedDates.any((d) => DateUtils.isSameDay(d, today));

    Habit updatedHabit;
    if (isCompletedToday) {
      // Undo completion
      final updatedDates = habit.completedDates.where((d) => !DateUtils.isSameDay(d, today)).toList();
      final newStreak = (habit.streak > 0) ? habit.streak - 1 : 0;
      updatedHabit = habit.copyWith(streak: newStreak, completedDates: updatedDates);
    } else {
      // Complete
      final updatedDates = List<DateTime>.from(habit.completedDates)..add(today);
      updatedHabit = habit.copyWith(streak: habit.streak + 1, completedDates: updatedDates);
    }

    _box.put(id, updatedHabit);
    state = _box.values.toList();
  }
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>((ref) {
  final box = Hive.box<Habit>(HiveSetup.habitsBox);
  return HabitsNotifier(box);
});
