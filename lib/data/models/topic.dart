import 'package:hive/hive.dart';
import 'revision_history.dart';

class Topic {
  String id;
  String title;
  String subjectId;
  String markdownNotes;
  DateTime nextReviewDate;
  int currentInterval; // Days: 1, 3, 7, or 15
  List<RevisionHistory> history;
  List<String> externalVideoLinks; // Format: vnd.youtube://watch?v=ID&t=TIME

  Topic({
    required this.id,
    required this.title,
    required this.subjectId,
    this.markdownNotes = '',
    required this.nextReviewDate,
    this.currentInterval = 1,
    List<RevisionHistory>? history,
    List<String>? externalVideoLinks,
  })  : history = history ?? [],
        externalVideoLinks = externalVideoLinks ?? [];
}

// MANUAL TYPE ADAPTER (No Code Generation)
class TopicAdapter extends TypeAdapter<Topic> {
  @override
  final int typeId = 0;

  @override
  Topic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    
    return Topic(
      id: fields[0] as String,
      title: fields[1] as String,
      subjectId: fields[2] as String,
      markdownNotes: fields[3] as String? ?? '',
      nextReviewDate: fields[4] as DateTime,
      currentInterval: fields[5] as int? ?? 1,
      history: (fields[6] as List?)?.cast<RevisionHistory>() ?? [],
      externalVideoLinks: (fields[7] as List?)?.cast<String>() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, Topic obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subjectId)
      ..writeByte(3)
      ..write(obj.markdownNotes)
      ..writeByte(4)
      ..write(obj.nextReviewDate)
      ..writeByte(5)
      ..write(obj.currentInterval)
      ..writeByte(6)
      ..write(obj.history)
      ..writeByte(7)
      ..write(obj.externalVideoLinks);
  }
}
