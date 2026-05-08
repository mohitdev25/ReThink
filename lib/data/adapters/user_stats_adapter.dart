import 'package:hive/hive.dart';
import '../models/user_stats.dart';

class UserStatsAdapter extends TypeAdapter<UserStats> {
  @override
  final int typeId = 4;

  @override
  UserStats read(BinaryReader reader) {
    return UserStats(
      totalTopicsStudied: reader.readInt(),
      totalHabitsCompleted: reader.readInt(),
      currentStreak: reader.readInt(),
      longestStreak: reader.readInt(),
      medals: reader.readList().cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserStats obj) {
    writer.writeInt(obj.totalTopicsStudied);
    writer.writeInt(obj.totalHabitsCompleted);
    writer.writeInt(obj.currentStreak);
    writer.writeInt(obj.longestStreak);
    writer.writeList(obj.medals);
  }
}
