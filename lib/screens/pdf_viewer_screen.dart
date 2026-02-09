import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf_viewer_app/models/pdf_file.dart';
import 'package:pdf_viewer_app/widgets/zoom_controls.dart';

class PDFViewerScreen extends StatefulWidget {
  final PDFFile file;

  const PDFViewerScreen({super.key, required this.file});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  double _zoomLevel = 1.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _zoomIn() {
    _pdfViewerController.zoomLevel += 0.2;
    setState(() => _zoomLevel = _pdfViewerController.zoomLevel);
  }

  void _zoomOut() {
    if (_pdfViewerController.zoomLevel > 0.5) {
      _pdfViewerController.zoomLevel -= 0.2;
      setState(() => _zoomLevel = _pdfViewerController.zoomLevel);
    }
  }

  void _resetZoom() {
    _pdfViewerController.zoomLevel = 1.0;
    setState(() => _zoomLevel = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.file.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Implement bookmark functionality
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'info',
                child: Text('File Info'),
              ),
              const PopupMenuItem(
                value: 'rotate',
                child: Text('Rotate'),
              ),
              const PopupMenuItem(
                value: 'print',
                child: Text('Print'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            SfPdfViewer.file(
              File(widget.file.path),
              controller: _pdfViewerController,
              pageLayoutMode: PdfPageLayoutMode.continuous,
              scrollDirection: PdfScrollDirection.vertical,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              interactionMode: PdfInteractionMode.pan,
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ZoomControls(
              zoomLevel: _zoomLevel,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onResetZoom: _resetZoom,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: StreamBuilder<int?>(
                stream: _pdfViewerController.pageChangedStream,
                builder: (context, snapshot) {
                  return Text(
                    'Page ${snapshot.data ?? 1}',
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}
