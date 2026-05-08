class UserStats {
  final int totalTopicsStudied;
  final int totalHabitsCompleted;
  final int currentStreak;
  final int longestStreak;
  final List<String> medals;

  const UserStats({
    required this.totalTopicsStudied,
    required this.totalHabitsCompleted,
    required this.currentStreak,
    required this.longestStreak,
    this.medals = const [],
  });

  UserStats copyWith({
    int? totalTopicsStudied,
    int? totalHabitsCompleted,
    int? currentStreak,
    int? longestStreak,
    List<String>? medals,
  }) {
    return UserStats(
      totalTopicsStudied: totalTopicsStudied ?? this.totalTopicsStudied,
      totalHabitsCompleted: totalHabitsCompleted ?? this.totalHabitsCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      medals: medals ?? this.medals,
    );
  }

  // Initial empty state
  factory UserStats.empty() {
    return const UserStats(
      totalTopicsStudied: 0,
      totalHabitsCompleted: 0,
      currentStreak: 0,
      longestStreak: 0,
    );
  }
}
