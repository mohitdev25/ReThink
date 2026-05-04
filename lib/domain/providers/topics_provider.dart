import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rethink_app/data/models/topic.dart';
import 'package:rethink_app/core/storage/hive_setup.dart';
import 'package:rethink_app/core/utils/dates.dart';

class TopicsNotifier extends StateNotifier<List<Topic>> {
  final Box<Topic> _box;

  TopicsNotifier(this._box) : super(_box.values.toList());

  void addTopic(Topic topic) {
    _box.put(topic.id, topic);
    state = _box.values.toList();
  }

  void updateTopic(Topic topic) {
    _box.put(topic.id, topic);
    state = _box.values.toList();
  }

  void gradeTopic(String topicId, String grade) {
    final topic = _box.get(topicId);
    if (topic == null) return;

    int newInterval = topic.interval;
    switch (grade) {
      case 'AGAIN':
        newInterval = 1;
        break;
      case 'HARD':
        newInterval = (newInterval == 1) ? 3 : newInterval; // minimal progress
        break;
      case 'GOOD':
        newInterval = _getNextInterval(newInterval);
        break;
      case 'EASY':
        newInterval = _getNextInterval(_getNextInterval(newInterval));
        break;
    }

    // Cap interval at 21 days for mastery loop
    if (newInterval > 21) newInterval = 21;

    final nextReview = DateUtils.normalizedToday.add(Duration(days: newInterval));
    final updatedHistory = List<int>.from(topic.history)..add(newInterval);

    final updatedTopic = topic.copyWith(
      interval: newInterval,
      nextReview: nextReview,
      history: updatedHistory,
    );

    updateTopic(updatedTopic);
  }

  int _getNextInterval(int current) {
    if (current < 3) return 3;
    if (current < 7) return 7;
    if (current < 15) return 15;
    return 21;
  }
}

final topicsProvider = StateNotifierProvider<TopicsNotifier, List<Topic>>((ref) {
  final box = Hive.box<Topic>(HiveSetup.topicsBox);
  return TopicsNotifier(box);
});

final todayReviewsProvider = Provider<List<Topic>>((ref) {
  final topics = ref.watch(topicsProvider);
  final today = DateUtils.normalizedToday;

  return topics.where((topic) {
    final reviewDate = DateUtils.normalize(topic.nextReview);
    return reviewDate.isBefore(today) || DateUtils.isSameDay(reviewDate, today);
  }).toList();
});
