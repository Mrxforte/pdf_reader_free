import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  Future<List<String>> listFiles(String path) async {
    try {
      final result = await _storage.ref(path).listAll();
      final urls = await Future.wait(
        result.items.map((ref) => ref.getDownloadURL()).toList(),
      );
      return urls;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  // Storage service is locale-agnostic.
}
