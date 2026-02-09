import 'package:flutter/material.dart';
import '../models/pdf_file.dart';
import '../services/pdf_service.dart';

class PdfProvider extends ChangeNotifier {
  List<PdfFile> files = [];
  List<PdfFile> favorites = [];
  List<PdfFile> recent = [];

  Future<void> loadFiles() async {
    files = await PdfService().getAllFiles();
    notifyListeners();
  }

  void addFavorite(PdfFile file) {
    favorites.add(file);
    notifyListeners();
  }

  void addRecent(PdfFile file) {
    recent.insert(0, file);
    notifyListeners();
  }

  // ...remove favorite, etc...
}
