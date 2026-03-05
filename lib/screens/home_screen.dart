import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_viewer_app/models/pdf_file.dart';
import 'package:pdf_viewer_app/providers/pdf_provider.dart';
import 'package:pdf_viewer_app/screens/pdf_viewer_screen.dart';
import 'package:pdf_viewer_app/screens/search_screen.dart';
import 'package:pdf_viewer_app/screens/all_files_screen.dart';
import 'package:pdf_viewer_app/widgets/drawer_menu.dart';
import 'package:pdf_viewer_app/widgets/file_list_item.dart';
import 'package:pdf_viewer_app/utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isFabOpen = false;

  void _toggleFab() {
    setState(() {
      _isFabOpen = !_isFabOpen;
    });
  }

  Future<void> _pickFile(BuildContext context, bool isMultiFormat) async {
    final pdfProvider = Provider.of<PDFProvider>(context, listen: false);

    if (isMultiFormat) {
      // Pick any document format
      await pdfProvider.pickDocument();
    } else {
      // Pick PDF only
      await pdfProvider.pickPDF();
    }

    if (mounted) {
      setState(() {
        _isFabOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          drawer: DrawerMenu(scaffoldKey: _scaffoldKey),
          appBar: AppBar(
            title: Text(context.l10n.appTitle),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: const HomeContent(),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isFabOpen) ...[
                _buildFabOption(
                  icon: Icons.picture_as_pdf,
                  label: 'PDF File',
                  onTap: () => _pickFile(context, false),
                ),
                const SizedBox(height: 12),
                _buildFabOption(
                  icon: Icons.description,
                  label: 'Any Document',
                  onTap: () => _pickFile(context, true),
                ),
                const SizedBox(height: 12),
                _buildFabOption(
                  icon: Icons.folder_open,
                  label: 'Browse Files',
                  onTap: () {
                    setState(() => _isFabOpen = false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllFilesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
              FloatingActionButton(
                onPressed: _toggleFab,
                child: AnimatedRotation(
                  turns: _isFabOpen ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(_isFabOpen ? Icons.close : Icons.add),
                ),
              ),
            ],
          ),
        ),
        if (_isFabOpen)
          GestureDetector(
            onTap: () => setState(() => _isFabOpen = false),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
      ],
    );
  }

  Widget _buildFabOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          mini: true,
          onPressed: onTap,
          child: Icon(icon),
        ),
      ],
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PDFProvider>(context);

    // Get all files sorted by recent first
    List<PDFFile> allFiles = List.from(pdfProvider.files);
    allFiles.sort((a, b) {
      final aOpened = a.lastOpened;
      final bOpened = b.lastOpened;

      if (aOpened == null && bOpened == null) {
        return b.dateAdded.compareTo(a.dateAdded);
      }
      if (aOpened == null) return 1;
      if (bOpened == null) return -1;
      return bOpened.compareTo(aOpened);
    });

    return RefreshIndicator(
      onRefresh: () => pdfProvider.loadFiles(),
      child: allFiles.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No files yet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to add your first file',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Header with file count
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Documents',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${pdfProvider.files.length} files',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // File list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: allFiles.length,
                    itemBuilder: (context, index) {
                      final file = allFiles[index];
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
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
