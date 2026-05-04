import 'package:hive_flutter/hive_flutter.dart';
import 'package:rethink_app/data/adapters/topic_adapter.dart';
import 'package:rethink_app/data/adapters/habit_adapter.dart';
import 'package:rethink_app/data/adapters/file_item_adapter.dart';
import 'package:rethink_app/data/adapters/user_stats_adapter.dart';
import 'package:rethink_app/data/models/topic.dart';
import 'package:rethink_app/data/models/habit.dart';
import 'package:rethink_app/data/models/file_item.dart';
import 'package:rethink_app/data/models/user_stats.dart';

class HiveSetup {
  static const String topicsBox = 'topicsBox';
  static const String habitsBox = 'habitsBox';
  static const String vaultBox = 'vaultBox';
  static const String statsBox = 'statsBox';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(TopicAdapter());
    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(FileItemAdapter());
    Hive.registerAdapter(UserStatsAdapter());

    // Open Boxes
    await Future.wait([
      Hive.openBox<Topic>(topicsBox),
      Hive.openBox<Habit>(habitsBox),
      Hive.openBox<FileItem>(vaultBox),
      Hive.openBox<UserStats>(statsBox),
    ]);
  }
}
