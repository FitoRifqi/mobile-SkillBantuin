import 'dart:typed_data';

import 'package:flutter/material.dart';

class FilePreviewScreen extends StatelessWidget {
  final String fileName;
  final List<int> bytes;

  const FilePreviewScreen({
    super.key,
    required this.fileName,
    required this.bytes,
  });

  @override
  Widget build(BuildContext context) {
    final data = Uint8List.fromList(bytes);

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF8FAFC),
        padding: const EdgeInsets.all(16),
        child: _isImage(fileName)
            ? InteractiveViewer(
                minScale: 0.7,
                maxScale: 4,
                child: Center(
                  child: Image.memory(
                    data,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return _UnsupportedPreview(
                        fileName: fileName,
                        sizeInBytes: bytes.length,
                      );
                    },
                  ),
                ),
              )
            : _UnsupportedPreview(
                fileName: fileName,
                sizeInBytes: bytes.length,
              ),
      ),
    );
  }

  bool _isImage(String name) {
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.gif');
  }
}

class _UnsupportedPreview extends StatelessWidget {
  final String fileName;
  final int sizeInBytes;

  const _UnsupportedPreview({
    required this.fileName,
    required this.sizeInBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.insert_drive_file_rounded,
                color: Color(0xFF059669),
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              fileName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'File berhasil dimuat, tetapi preview langsung baru tersedia untuk gambar. Ukuran ${_formatSize(sizeInBytes)}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '$bytes B';
  }
}
