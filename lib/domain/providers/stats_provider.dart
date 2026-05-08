import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rethink_app/data/models/user_stats.dart';
import 'package:rethink_app/core/storage/hive_setup.dart';

class StatsNotifier extends StateNotifier<UserStats> {
  final Box<UserStats> _box;
  static const String _statsId = 'current_user_stats';

  StatsNotifier(this._box) : super(_box.get(_statsId) ?? UserStats.empty());

  void incrementTopicsStudied() {
    final updated = state.copyWith(totalTopicsStudied: state.totalTopicsStudied + 1);
    _save(updated);
  }

  void incrementHabitsCompleted() {
    final updated = state.copyWith(totalHabitsCompleted: state.totalHabitsCompleted + 1);
    _save(updated);
  }

  void updateStreak(int currentStreak) {
    int longest = state.longestStreak;
    if (currentStreak > longest) {
      longest = currentStreak;
    }
    final updated = state.copyWith(
      currentStreak: currentStreak,
      longestStreak: longest,
    );
    _save(updated);
  }

  void awardMedal(String medal) {
    if (!state.medals.contains(medal)) {
      final updatedMedals = List<String>.from(state.medals)..add(medal);
      final updated = state.copyWith(medals: updatedMedals);
      _save(updated);
    }
  }

  void _save(UserStats stats) {
    _box.put(_statsId, stats);
    state = stats;
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, UserStats>((ref) {
  final box = Hive.box<UserStats>(HiveSetup.statsBox);
  return StatsNotifier(box);
});
