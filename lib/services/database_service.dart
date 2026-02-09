import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf_viewer_app/models/user.dart';
import 'package:pdf_viewer_app/models/pdf_file.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<void> saveUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!);
    }
    return null;
  }

  // PDF File operations
  Future<void> saveFile(PDFFile file) async {
    await _firestore.collection('files').doc(file.id).set(file.toMap());
  }

  Future<void> updateFile(PDFFile file) async {
    await _firestore.collection('files').doc(file.id).update(file.toMap());
  }

  Future<void> deleteFile(String fileId) async {
    await _firestore.collection('files').doc(fileId).delete();
  }

  Future<List<PDFFile>> getFiles() async {
    final snapshot = await _firestore.collection('files').get();
    return snapshot.docs.map((doc) => PDFFile.fromMap(doc.data())).toList();
  }

  Future<List<PDFFile>> getFilesByUserId(String userId) async {
    final snapshot = await _firestore
        .collection('files')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => PDFFile.fromMap(doc.data())).toList();
  }

  Future<List<PDFFile>> getFavoriteFiles(String userId) async {
    final snapshot = await _firestore
        .collection('files')
        .where('userId', isEqualTo: userId)
        .where('isFavorite', isEqualTo: true)
        .get();
    return snapshot.docs.map((doc) => PDFFile.fromMap(doc.data())).toList();
  }

  // Data service is locale-agnostic.
}
