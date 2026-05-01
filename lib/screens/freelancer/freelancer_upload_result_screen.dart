import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';

class FreelancerUploadResultScreen extends StatefulWidget {
  final FreelancerWorkItem item;

  const FreelancerUploadResultScreen({
    super.key,
    required this.item,
  });

  @override
  State<FreelancerUploadResultScreen> createState() => _FreelancerUploadResultScreenState();
}

class _FreelancerUploadResultScreenState extends State<FreelancerUploadResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fileController = TextEditingController();
  final _linkController = TextEditingController();
  final _noteController = TextEditingController();

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
                      'Upload hasil akan mensimulasikan status "hasil dikirim", lalu client bisa lanjut ke review dan rating.',
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
                      if (value == null || value.isEmpty) {
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
                      hintText: 'Jelaskan apa yang sudah dikerjakan dan hal penting yang perlu dicek.',
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
                      onPressed: _submitResult,
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                      label: const Text('Kirim Hasil'),
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

  void _pickFile() {
    setState(() {
      _fileController.text = 'hasil-final-freelancer.zip';
    });
  }

  void _submitResult() {
    if (!_formKey.currentState!.validate()) return;
    _showSuccessSheet();
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
                  'File ${result.fileName} dikirim ke client. Tahap berikutnya: client meninjau hasil lalu memberikan rating.',
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
