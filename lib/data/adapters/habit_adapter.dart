import 'package:hive/hive.dart';
import '../models/habit.dart';

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 2;

  @override
  Habit read(BinaryReader reader) {
    return Habit(
      id: reader.readString(),
      title: reader.readString(),
      streak: reader.readInt(),
      completedDates: reader.readList().map((e) => DateTime.fromMillisecondsSinceEpoch(e as int)).toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeInt(obj.streak);
    writer.writeList(obj.completedDates.map((e) => e.millisecondsSinceEpoch).toList());
  }
}
