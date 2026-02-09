import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_viewer_app/providers/pdf_provider.dart';
import 'package:pdf_viewer_app/screens/pdf_viewer_screen.dart';
import 'package:pdf_viewer_app/widgets/file_list_item.dart';
import 'package:pdf_viewer_app/utils/helpers.dart';

class AllFilesScreen extends StatefulWidget {
  const AllFilesScreen({super.key});

  @override
  State<AllFilesScreen> createState() => _AllFilesScreenState();
}

class _AllFilesScreenState extends State<AllFilesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PDFProvider>(context);
    final files = pdfProvider.files.where((file) {
      if (_searchQuery.isEmpty) return true;
      return file.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: context.l10n.searchPdfFiles,
            border: InputBorder.none,
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : const Icon(Icons.search),
          ),
        ),
      ),
      body: pdfProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : files.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.l10n.noPdfFilesYet,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        context.l10n.tapPlusToAddFirst,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return FileListItem(
                      file: file,
                      onTap: () {
                        pdfProvider.updateLastOpened(file.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerScreen(file: file),
                          ),
                        );
                      },
                      onFavorite: () {
                        pdfProvider.toggleFavorite(file.id);
                      },
                      onDelete: () async {
                        final confirmed = await Helpers.showConfirmationDialog(
                          context,
                          'Delete File',
                          'Are you sure you want to delete "${file.name}"?',
                        );
                        if (confirmed) {
                          pdfProvider.deleteFile(file.id);
                        }
                      },
                      onShare: () {
                        pdfProvider.shareFile(file.id);
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pdfProvider.pickPDF();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
