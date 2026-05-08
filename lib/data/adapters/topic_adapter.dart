import 'package:hive/hive.dart';
import '../models/topic.dart';

class TopicAdapter extends TypeAdapter<Topic> {
  @override
  final int typeId = 1;

  @override
  Topic read(BinaryReader reader) {
    return Topic(
      id: reader.readString(),
      title: reader.readString(),
      notes: reader.readString(),
      interval: reader.readInt(),
      nextReview: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      history: reader.readList().cast<int>(),
      attachments: reader.readList().cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Topic obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.notes);
    writer.writeInt(obj.interval);
    writer.writeInt(obj.nextReview.millisecondsSinceEpoch);
    writer.writeList(obj.history);
    writer.writeList(obj.attachments);
  }
}
