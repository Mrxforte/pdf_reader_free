class PdfFile {
  final String id;
  final String name;
  final String path;
  final bool isFavorite;
  // ...other fields...

  PdfFile({required this.id, required this.name, required this.path, this.isFavorite = false});
}
