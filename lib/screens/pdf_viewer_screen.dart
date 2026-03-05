import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'package:pdf_viewer_app/models/pdf_file.dart';
import 'package:pdf_viewer_app/providers/pdf_provider.dart';
import 'package:pdf_viewer_app/widgets/zoom_controls.dart';
import 'package:pdf_viewer_app/services/voice_reader_service.dart';

class PDFViewerScreen extends StatefulWidget {
  final PDFFile file;

  const PDFViewerScreen({super.key, required this.file});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final VoiceReaderService _voiceReaderService = VoiceReaderService();

  double _zoomLevel = 1.0;
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isFullScreen = false;
  bool _showControls = true;
  bool _isVoiceReading = false;
  PdfPageLayoutMode _layoutMode = PdfPageLayoutMode.continuous;
  PdfScrollDirection _scrollDirection = PdfScrollDirection.vertical;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
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

  void _nextPage() {
    if (_currentPage < _totalPages) {
      _pdfViewerController.jumpToPage(_currentPage + 1);
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _pdfViewerController.jumpToPage(_currentPage - 1);
    }
  }

  void _jumpToPage() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Jump to Page'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Page Number (1-$_totalPages)',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final page = int.tryParse(controller.text);
                if (page != null && page >= 1 && page <= _totalPages) {
                  _pdfViewerController.jumpToPage(page);
                  Navigator.pop(context);
                }
              },
              child: const Text('Go'),
            ),
          ],
        );
      },
    );
  }

  void _shareFile() async {
    try {
      await Share.shareXFiles(
        [XFile(widget.file.path)],
        subject: widget.file.name,
        text:
            'Check out this PDF document: ${widget.file.name}\n\nPage: $_currentPage / $_totalPages',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing file: $e')),
        );
      }
    }
  }

  void _shareFile_Advanced() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share File'),
              subtitle: const Text('Send via email, messaging, etc.'),
              onTap: () {
                Navigator.pop(context);
                _shareFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Share as Link'),
              subtitle: const Text('Generate shareable link'),
              onTap: () {
                Navigator.pop(context);
                _showShareLinkDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy File Path'),
              subtitle: const Text('Copy to clipboard'),
              onTap: () async {
                Navigator.pop(context);
                await Clipboard.setData(
                  ClipboardData(text: widget.file.path),
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Path copied to clipboard')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showShareLinkDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share as Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Generate a shareable link for this file'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'https://share.example.com/${widget.file.id}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: 'https://share.example.com/${widget.file.id}',
                        ),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    final provider = Provider.of<PDFProvider>(context, listen: false);
    provider.toggleFavorite(widget.file.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.file.isFavorite
            ? 'Removed from favorites'
            : 'Added to favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showFileInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name', widget.file.name),
            const SizedBox(height: 8),
            _buildInfoRow('Size', _formatFileSize(widget.file.size)),
            const SizedBox(height: 8),
            _buildInfoRow('Pages', _totalPages.toString()),
            const SizedBox(height: 8),
            _buildInfoRow('Added', _formatDate(widget.file.dateAdded)),
            if (widget.file.lastOpened != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                  'Last Opened', _formatDate(widget.file.lastOpened!)),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  void _deleteFile() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Are you sure you want to delete "${widget.file.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final provider = Provider.of<PDFProvider>(context, listen: false);
      await provider.deleteFile(widget.file.id);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PDFProvider>(context);
    final file = provider.files.firstWhere(
      (f) => f.id == widget.file.id,
      orElse: () => widget.file,
    );

    return Scaffold(
      appBar: _isFullScreen || !_showControls
          ? null
          : AppBar(
              title: Text(
                widget.file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                  icon: Icon(file.isFavorite ? Icons.star : Icons.star_border),
                  onPressed: _toggleFavorite,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: _shareFile_Advanced,
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'fullscreen',
                      child: Row(
                        children: [
                          Icon(Icons.fullscreen),
                          SizedBox(width: 8),
                          Text('Full Screen'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'info',
                      child: Row(
                        children: [
                          Icon(Icons.info),
                          SizedBox(width: 8),
                          Text('File Info'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'jump',
                      child: Row(
                        children: [
                          Icon(Icons.format_list_numbered),
                          SizedBox(width: 8),
                          Text('Jump to Page'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'layout',
                      child: Row(
                        children: [
                          Icon(Icons.view_column),
                          SizedBox(width: 8),
                          Text('Change Layout'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'rotate',
                      child: Row(
                        children: [
                          Icon(Icons.rotate_right),
                          SizedBox(width: 8),
                          Text('Rotate'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'fullscreen':
                        _toggleFullScreen();
                        break;
                      case 'info':
                        _showFileInfo();
                        break;
                      case 'jump':
                        _jumpToPage();
                        break;
                      case 'layout':
                        _showLayoutOptions();
                        break;
                      case 'rotate':
                        // Implement rotation
                        break;
                      case 'delete':
                        _deleteFile();
                        break;
                    }
                  },
                ),
              ],
            ),
      body: GestureDetector(
        onTap: () {
          if (_isFullScreen) {
            _toggleControls();
          }
        },
        child: Stack(
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              SfPdfViewer.file(
                File(widget.file.path),
                key: _pdfViewerKey,
                controller: _pdfViewerController,
                pageLayoutMode: _layoutMode,
                scrollDirection: _scrollDirection,
                canShowScrollHead: true,
                canShowScrollStatus: true,
                interactionMode: PdfInteractionMode.pan,
                onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                  setState(() {
                    _totalPages = details.document.pages.count;
                  });
                },
                onPageChanged: (PdfPageChangedDetails details) {
                  setState(() {
                    _currentPage = details.newPageNumber;
                  });
                },
              ),

            // Controls overlay
            if (_showControls) ...[
              // Zoom controls
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

              // Page indicator and navigation
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Navigation buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: _currentPage > 1 ? _previousPage : null,
                          icon: const Icon(Icons.chevron_left),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.7),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed:
                              _currentPage < _totalPages ? _nextPage : null,
                          icon: const Icon(Icons.chevron_right),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.7),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Voice reader button
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isVoiceReading = !_isVoiceReading;
                            });
                          },
                          icon: Icon(
                            _isVoiceReading
                                ? Icons.volume_up
                                : Icons.volume_mute,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.7),
                            foregroundColor: Colors.white,
                          ),
                          tooltip: 'Voice Reader',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Page counter
                    GestureDetector(
                      onTap: _jumpToPage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_currentPage / $_totalPages',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Voice reader controls
                    if (_isVoiceReading) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.play_arrow),
                              color: Colors.white,
                              iconSize: 20,
                              onPressed: () async {
                                await _voiceReaderService.speak(
                                  'PDF Page $_currentPage of $_totalPages',
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.stop),
                              color: Colors.white,
                              iconSize: 20,
                              onPressed: () async {
                                await _voiceReaderService.stop();
                              },
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.settings_voice),
                              color: Colors.white,
                              iconSize: 20,
                              onPressed: () {
                                // Show voice settings
                                _showVoiceSettings();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Full screen toggle
              if (!_isFullScreen)
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    onPressed: _toggleFullScreen,
                    icon: const Icon(Icons.fullscreen),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.7),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

              // Exit full screen
              if (_isFullScreen)
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    onPressed: _toggleFullScreen,
                    icon: const Icon(Icons.fullscreen_exit),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.7),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLayoutOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Layout Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.view_stream),
              title: const Text('Continuous Vertical'),
              selected: _layoutMode == PdfPageLayoutMode.continuous &&
                  _scrollDirection == PdfScrollDirection.vertical,
              onTap: () {
                setState(() {
                  _layoutMode = PdfPageLayoutMode.continuous;
                  _scrollDirection = PdfScrollDirection.vertical;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_day),
              title: const Text('Single Page'),
              selected: _layoutMode == PdfPageLayoutMode.single,
              onTap: () {
                setState(() {
                  _layoutMode = PdfPageLayoutMode.single;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVoiceSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Voice Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Speech Rate
              Text(
                'Speech Rate: ${(_voiceReaderService.speechRate * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Slider(
                value: _voiceReaderService.speechRate,
                onChanged: (value) async {
                  await _voiceReaderService.setSpeechRate(value);
                  setState(() {});
                },
                min: 0.0,
                max: 2.0,
                divisions: 20,
              ),
              const SizedBox(height: 16),

              // Pitch
              Text(
                'Pitch: ${_voiceReaderService.pitch.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Slider(
                value: _voiceReaderService.pitch,
                onChanged: (value) async {
                  await _voiceReaderService.setPitch(value);
                  setState(() {});
                },
                min: 0.5,
                max: 2.0,
                divisions: 30,
              ),
              const SizedBox(height: 16),

              // Volume
              Text(
                'Volume: ${(_voiceReaderService.volume * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Slider(
                value: _voiceReaderService.volume,
                onChanged: (value) async {
                  await _voiceReaderService.setVolume(value);
                  setState(() {});
                },
                min: 0.0,
                max: 1.0,
                divisions: 10,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    _voiceReaderService.stop();
    _pdfViewerController.dispose();
    super.dispose();
  }
}
