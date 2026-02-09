class PDFFile {
  final String id;
  final String name;
  final String path;
  final int size;
  final DateTime dateAdded;
  final DateTime? lastOpened;
  final bool isFavorite;
  final String? thumbnailUrl;
  final int pageCount;

  PDFFile({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.dateAdded,
    this.lastOpened,
    this.isFavorite = false,
    this.thumbnailUrl,
    this.pageCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'size': size,
      'dateAdded': dateAdded.toIso8601String(),
      'lastOpened': lastOpened?.toIso8601String(),
      'isFavorite': isFavorite,
      'thumbnailUrl': thumbnailUrl,
      'pageCount': pageCount,
    };
  }

  factory PDFFile.fromMap(Map<String, dynamic> map) {
    return PDFFile(
      id: map['id'],
      name: map['name'],
      path: map['path'],
      size: map['size'],
      dateAdded: DateTime.parse(map['dateAdded']),
      lastOpened: map['lastOpened'] != null ? DateTime.parse(map['lastOpened']) : null,
      isFavorite: map['isFavorite'] ?? false,
      thumbnailUrl: map['thumbnailUrl'],
      pageCount: map['pageCount'] ?? 0,
    );
  }

  PDFFile copyWith({
    String? id,
    String? name,
    String? path,
    int? size,
    DateTime? dateAdded,
    DateTime? lastOpened,
    bool? isFavorite,
    String? thumbnailUrl,
    int? pageCount,
  }) {
    return PDFFile(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      dateAdded: dateAdded ?? this.dateAdded,
      lastOpened: lastOpened ?? this.lastOpened,
      isFavorite: isFavorite ?? this.isFavorite,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      pageCount: pageCount ?? this.pageCount,
    );
  }
}
