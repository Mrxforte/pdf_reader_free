import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pdf_viewer_app/models/pdf_file.dart';
import 'package:pdf_viewer_app/utils/helpers.dart';

class FileListItem extends StatelessWidget {
  final PDFFile file;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final bool showDate;
  final DateTime? date;

  const FileListItem({
    super.key,
    required this.file,
    required this.onTap,
    this.onFavorite,
    this.onDelete,
    this.onShare,
    this.showDate = false,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    final extension = file.name.split('.').last.toLowerCase();
    final fileIcon = _getFileIcon(extension);
    final iconColor = _getIconColor(extension);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            if (onFavorite != null)
              SlidableAction(
                onPressed: (_) => onFavorite!(),
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                icon: file.isFavorite ? Icons.star : Icons.star_border,
                label: 'Favorite',
              ),
            if (onShare != null)
              SlidableAction(
                onPressed: (_) => onShare!(),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.share,
                label: 'Share',
              ),
            if (onDelete != null)
              SlidableAction(
                onPressed: (_) => onDelete!(),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
          ],
        ),
        child: Card(
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                fileIcon,
                color: iconColor,
                size: 30,
              ),
            ),
            title: Text(
              file.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(Helpers.formatFileSize(file.size)),
                    const SizedBox(width: 8),
                    Text(
                      '.${extension.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
                if (showDate && date != null)
                  Text(
                    '${context.l10n.openedLabel}: ${Helpers.formatDateShort(date!)}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            trailing: file.isFavorite
                ? const Icon(Icons.star, color: Colors.amber)
                : const Icon(Icons.chevron_right),
            onTap: onTap,
          ),
        ),
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
      case 'rtf':
        return Icons.text_snippet;
      case 'html':
      case 'xml':
        return Icons.code;
      case 'csv':
        return Icons.grid_on;
      case 'epub':
      case 'mobi':
        return Icons.book;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getIconColor(String extension) {
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'txt':
      case 'md':
      case 'rtf':
        return Colors.grey;
      case 'html':
      case 'xml':
      case 'json':
        return Colors.purple;
      case 'csv':
        return Colors.teal;
      case 'epub':
      case 'mobi':
        return Colors.brown;
      default:
        return Colors.blueGrey;
    }
  }
}
