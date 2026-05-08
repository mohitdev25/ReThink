import 'package:hive/hive.dart';
import '../models/file_item.dart';

class FileItemAdapter extends TypeAdapter<FileItem> {
  @override
  final int typeId = 3;

  @override
  FileItem read(BinaryReader reader) {
    return FileItem(
      id: reader.readString(),
      name: reader.readString(),
      path: reader.readString(),
      type: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, FileItem obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.path);
    writer.writeString(obj.type);
  }
}
