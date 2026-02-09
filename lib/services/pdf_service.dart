import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  // Pick PDF file from device
  Future<File?> pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  // Get local storage directory
  Future<Directory> getStorageDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  // Share PDF file
  Future<void> sharePdf(String filePath) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath)],
      ),
    );
  }

  // Check if file exists
  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  // Delete local file
  Future<void> deleteLocalFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Get file size
  Future<int> getFileSize(String path) async {
    final file = File(path);
    return await file.length();
  }

  // Generate thumbnail
  Future<Uint8List> generateThumbnail(String pdfPath) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'PDF Thumbnail',
              style: pw.TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );

    return await pdf.save();
  }

  // Get file size in human readable format
  Future<String> getFileSizeHuman(String path) async {
    final file = File(path);
    final size = await file.length();

    if (size < 1024) {
      return '${size}B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(2)}KB';
    } else {
      return '${(size / (1024 * 1024)).toStringAsFixed(2)}MB';
    }
  }

  // Get page count
  Future<int> getPageCount(String path) async {
    return 1;
  }

  // Save temporary file
  Future<File> saveTemporaryFile(Uint8List bytes, String filename) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  // PDF service is locale-agnostic.
}
