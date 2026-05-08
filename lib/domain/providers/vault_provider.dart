import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rethink_app/data/models/file_item.dart';
import 'package:rethink_app/core/storage/hive_setup.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class VaultNotifier extends StateNotifier<List<FileItem>> {
  final Box<FileItem> _box;
  final Uuid _uuid = const Uuid();

  VaultNotifier(this._box) : super(_box.values.toList());

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      final fileItem = FileItem(
        id: _uuid.v4(),
        name: file.name,
        path: file.path!,
        type: file.extension ?? 'unknown',
      );
      addFile(fileItem);
    }
  }

  void addFile(FileItem file) {
    _box.put(file.id, file);
    state = _box.values.toList();
  }

  void removeFile(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }
}

final vaultProvider = StateNotifierProvider<VaultNotifier, List<FileItem>>((ref) {
  final box = Hive.box<FileItem>(HiveSetup.vaultBox);
  return VaultNotifier(box);
});
