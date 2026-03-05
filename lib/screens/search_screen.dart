import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_viewer_app/models/pdf_file.dart';
import 'package:pdf_viewer_app/providers/pdf_provider.dart';
import 'package:pdf_viewer_app/screens/pdf_viewer_screen.dart';
import 'package:pdf_viewer_app/widgets/file_list_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PDFFile> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query, List<PDFFile> allFiles) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = allFiles.where((file) {
        final nameLower = file.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PDFProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search files...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          onChanged: (query) => _performSearch(query, pdfProvider.files),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _performSearch('', pdfProvider.files);
              },
            ),
        ],
      ),
      body: _buildSearchBody(pdfProvider),
    );
  }

  Widget _buildSearchBody(PDFProvider pdfProvider) {
    if (!_isSearching && _searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Search for PDF files',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty && _isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No files found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final file = _searchResults[index];
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
    );
  }
}
