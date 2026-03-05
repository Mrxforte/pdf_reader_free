import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'package:pdf_viewer_app/models/pdf_file.dart';
import 'package:pdf_viewer_app/providers/pdf_provider.dart';
import 'package:pdf_viewer_app/services/voice_reader_service.dart';

/// Universal Document Viewer that supports multiple formats
/// PDF, DOC, DOCX, TXT, and other common document formats
class DocumentViewerScreen extends StatefulWidget {
  final PDFFile file;

  const DocumentViewerScreen({super.key, required this.file});

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  bool _isFullScreen = false;
  bool _showControls = true;
  String? _textContent;
  bool _isLoading = true;
  String? _error;
  late VoiceReaderService _voiceReaderService;

  @override
  void initState() {
    super.initState();
    _voiceReaderService = VoiceReaderService();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      final extension = widget.file.name.split('.').last.toLowerCase();

      // For text-based files, load content
      if (['txt', 'md', 'json', 'xml', 'html', 'csv'].contains(extension)) {
        final file = File(widget.file.path);
        final content = await file.readAsString();
        setState(() {
          _textContent = content;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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

  void _shareFile() async {
    try {
      await Share.shareXFiles(
        [XFile(widget.file.path)],
        subject: widget.file.name,
        text: 'Check out this document: ${widget.file.name}',
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

    final extension = widget.file.name.split('.').last.toLowerCase();

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
            setState(() {
              _showControls = !_showControls;
            });
          }
        },
        child: _buildDocumentView(extension),
      ),
    );
  }

  Widget _buildDocumentView(String extension) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading document: $_error'),
          ],
        ),
      );
    }

    // PDF files
    if (extension == 'pdf') {
      return SfPdfViewer.file(
        File(widget.file.path),
        canShowScrollHead: true,
        canShowScrollStatus: true,
      );
    }

    // Text-based files
    if (_textContent != null) {
      return Column(
        children: [
          // Voice reader controls
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    tooltip: 'Play',
                    onPressed: () async {
                      await _voiceReaderService.speak(_textContent!);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause),
                    tooltip: 'Pause',
                    onPressed: () async {
                      await _voiceReaderService.pause();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    tooltip: 'Stop',
                    onPressed: () async {
                      await _voiceReaderService.stop();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_voice),
                    tooltip: 'Voice Settings',
                    onPressed: _showVoiceSettings,
                  ),
                ],
              ),
            ),
          ),
          // Text content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                _textContent!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Unsupported format
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getFileIcon(extension),
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            widget.file.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Preview not available for .${extension.toUpperCase()} files',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open with external app'),
            onPressed: () {
              // TODO: Implement external app opening
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('External app support coming soon'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
      case 'md':
        return Icons.text_snippet;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
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
    super.dispose();
  }
}
