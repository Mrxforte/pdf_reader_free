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
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
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
                Text(Helpers.formatFileSize(file.size)),
                if (showDate && date != null)
                  Text(
                    '${context.l10n.openedLabel}: ${Helpers.formatDateShort(date!)}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            trailing: file.isFavorite
                ? const Icon(Icons.star, color: Colors.amber)
                : null,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
