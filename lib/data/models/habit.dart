class Habit {
  final String id;
  final String title;
  final int streak;
  final List<DateTime> completedDates;

  const Habit({
    required this.id,
    required this.title,
    required this.streak,
    this.completedDates = const [],
  });

  Habit copyWith({
    String? id,
    String? title,
    int? streak,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      streak: streak ?? this.streak,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}
