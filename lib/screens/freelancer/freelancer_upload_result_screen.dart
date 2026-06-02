import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';
import '../../services/marketplace_service.dart';

class FreelancerUploadResultScreen extends StatefulWidget {
  final FreelancerWorkItem item;

  const FreelancerUploadResultScreen({
    super.key,
    required this.item,
  });

  @override
  State<FreelancerUploadResultScreen> createState() =>
      _FreelancerUploadResultScreenState();
}

class _FreelancerUploadResultScreenState
    extends State<FreelancerUploadResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fileController = TextEditingController();
  final _linkController = TextEditingController();
  final _noteController = TextEditingController();
  final _marketplaceService = MarketplaceService();
  String? _selectedFilePath;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fileController.dispose();
    _linkController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Hasil Pekerjaan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.taskTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Client: ${widget.item.clientName}',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Upload file hasil asli dari perangkat, lalu client bisa melihat hasil dan lanjut ke review.',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fileController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Upload file hasil',
                      suffixIcon: TextButton(
                        onPressed: _pickFile,
                        child: const Text('Upload'),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          _selectedFilePath == null) {
                        return 'File hasil wajib dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _linkController,
                    decoration: const InputDecoration(
                      labelText: 'Link hasil pekerjaan',
                      hintText: 'Contoh: https://drive.google.com/...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Catatan untuk client',
                      hintText: 'Ringkas hasil dan catatan penting.',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Catatan untuk client wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitResult,
                      icon: const Icon(Icons.check_circle_outline_rounded,
                          size: 18),
                      label:
                          Text(_isSubmitting ? 'Mengirim...' : 'Kirim Hasil'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: false,
    );

    if (!mounted || result == null || result.files.isEmpty) return;

    final file = result.files.single;
    if (file.path == null || file.path!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File ini belum bisa dibaca dari perangkat.'),
        ),
      );
      return;
    }

    setState(() {
      _selectedFilePath = file.path;
      _fileController.text = file.name;
    });
  }

  Future<void> _submitResult() async {
    if (!_formKey.currentState!.validate()) return;
    final filePath = _selectedFilePath;
    if (filePath == null) return;

    setState(() => _isSubmitting = true);
    try {
      await _marketplaceService.submitProjectResult(
        projectId: widget.item.id,
        resultFilePath: filePath,
        resultLink: _linkController.text.trim(),
        resultNote: _noteController.text.trim(),
      );
      if (!mounted) return;
      await _showSuccessSheet();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showSuccessSheet() async {
    final result = WorkSubmissionResult(
      fileName: _fileController.text,
      resultLink: _linkController.text.trim().isEmpty
          ? null
          : _linkController.text.trim(),
      note: _noteController.text.trim(),
      nextWorkStatus: WorkStatus.waitingConfirmation,
      nextTaskStatus: TaskStatus.submitted,
    );

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hasil Berhasil Dikirim',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'File ${result.fileName} dikirim. Menunggu review client.',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Lanjutkan'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    Navigator.pop(context, result);
  }
}
