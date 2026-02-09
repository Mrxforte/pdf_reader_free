import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_viewer_app/providers/pdf_provider.dart';
import 'package:pdf_viewer_app/screens/pdf_viewer_screen.dart';
import 'package:pdf_viewer_app/widgets/file_list_item.dart';
import 'package:pdf_viewer_app/utils/helpers.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PDFProvider>(context);
    final recent = pdfProvider.recent;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.recentFiles),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirmed = await Helpers.showConfirmationDialog(
                context,
                'Clear Recent',
                'Clear all recent files?',
              );
              if (confirmed) {
                // Implement clear recent functionality
              }
            },
          ),
        ],
      ),
      body: pdfProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : recent.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.l10n.noRecentFiles,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Open files will appear here',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recent.length,
                  itemBuilder: (context, index) {
                    final file = recent[index];
                    return FileListItem(
                      file: file,
                      showDate: true,
                      date: file.lastOpened,
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
    );
  }
}
