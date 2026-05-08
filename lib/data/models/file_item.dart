class FileItem {
  final String id;
  final String name;
  final String path;
  final String type; // 'pdf', 'image', etc.

  const FileItem({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
  });

  FileItem copyWith({
    String? id,
    String? name,
    String? path,
    String? type,
  }) {
    return FileItem(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
    );
  }
}
