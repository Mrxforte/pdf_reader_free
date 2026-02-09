import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf_viewer_app/models/pdf_file.dart';
import 'package:pdf_viewer_app/services/storage_service.dart';
import 'package:pdf_viewer_app/services/database_service.dart';

class PDFProvider with ChangeNotifier {
  List<PDFFile> _files = [];
  List<PDFFile> _favorites = [];
  List<PDFFile> _recent = [];
  bool _isLoading = false;
  String? _error;

  List<PDFFile> get files => _files;
  List<PDFFile> get favorites => _favorites;
  List<PDFFile> get recent => _recent;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final StorageService _storageService = StorageService();
  final DatabaseService _databaseService = DatabaseService();

  PDFProvider() {
    loadFiles();
  }

  Future<void> loadFiles() async {
    try {
      _isLoading = true;
      notifyListeners();

      _files = await _databaseService.getFiles();
      _updateFilteredLists();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateFilteredLists() {
    _favorites = _files.where((file) => file.isFavorite).toList();
    _recent = _files.where((file) => file.lastOpened != null).toList()
      ..sort((a, b) => b.lastOpened!.compareTo(a.lastOpened!));
  }

  Future<void> pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final file = result.files.first;
        final pdfFile = PDFFile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: file.name,
          path: file.path!,
          size: file.size,
          dateAdded: DateTime.now(),
        );

        await _databaseService.saveFile(pdfFile);
        _files.add(pdfFile);
        _updateFilteredLists();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String fileId) async {
    final index = _files.indexWhere((file) => file.id == fileId);
    if (index != -1) {
      final updatedFile = _files[index].copyWith(
        isFavorite: !_files[index].isFavorite,
      );

      await _databaseService.updateFile(updatedFile);
      _files[index] = updatedFile;
      _updateFilteredLists();
      notifyListeners();
    }
  }

  Future<void> updateLastOpened(String fileId) async {
    final index = _files.indexWhere((file) => file.id == fileId);
    if (index != -1) {
      final updatedFile = _files[index].copyWith(
        lastOpened: DateTime.now(),
      );

      await _databaseService.updateFile(updatedFile);
      _files[index] = updatedFile;
      _updateFilteredLists();
      notifyListeners();
    }
  }

  Future<void> deleteFile(String fileId) async {
    try {
      final index = _files.indexWhere((file) => file.id == fileId);
      if (index != -1) {
        final file = _files[index];
        await _databaseService.deleteFile(fileId);

        // Delete local file if it exists
        try {
          final fileToDelete = File(file.path);
          if (await fileToDelete.exists()) {
            await fileToDelete.delete();
          }
        } catch (e) {
          debugPrint('Error deleting local file: $e');
        }

        _files.removeAt(index);
        _updateFilteredLists();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> shareFile(String fileId) async {
    try {
      final file = _files.firstWhere((f) => f.id == fileId);
      final filePath = File(file.path);

      if (await filePath.exists()) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(filePath.path)],
            text: 'Check out this PDF',
          ),
        );
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> uploadToCloud(String fileId) async {
    try {
      final file = _files.firstWhere((f) => f.id == fileId);
      final filePath = File(file.path);

      if (await filePath.exists()) {
        final url = await _storageService.uploadFile(
          filePath,
          'pdfs/${DateTime.now().millisecondsSinceEpoch}_${file.name}',
        );

        // Update file with cloud URL
        final updatedFile = file.copyWith(
          thumbnailUrl: url,
        );

        await _databaseService.updateFile(updatedFile);
        final index = _files.indexWhere((f) => f.id == fileId);
        _files[index] = updatedFile;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
