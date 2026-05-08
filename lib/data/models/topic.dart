class Topic {
  final String id;
  final String title;
  final String notes;
  final int interval;
  final DateTime nextReview;
  final List<int> history;
  final List<String> attachments;

  const Topic({
    required this.id,
    required this.title,
    required this.notes,
    required this.interval,
    required this.nextReview,
    this.history = const [],
    this.attachments = const [],
  });

  Topic copyWith({
    String? id,
    String? title,
    String? notes,
    int? interval,
    DateTime? nextReview,
    List<int>? history,
    List<String>? attachments,
  }) {
    return Topic(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      interval: interval ?? this.interval,
      nextReview: nextReview ?? this.nextReview,
      history: history ?? this.history,
      attachments: attachments ?? this.attachments,
    );
  }
}
