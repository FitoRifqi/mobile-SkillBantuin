import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';

class ClientReviewScreen extends StatefulWidget {
  final ClientTask task;

  const ClientReviewScreen({
    super.key,
    required this.task,
  });

  @override
  State<ClientReviewScreen> createState() => _ClientReviewScreenState();
}

class _ClientReviewScreenState extends State<ClientReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review & Rating'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Volunteer: ${widget.task.assignedFreelancer ?? '-'}',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Beri penilaian untuk hasil pekerjaan',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: const Color(0xFFF59E0B),
                          size: 34,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _commentController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Komentar',
                      hintText: 'Tulis pengalamanmu bekerja dengan volunteer ini...',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Komentar review tidak boleh kosong';
                      }
                      if (value.trim().length < 10) {
                        return 'Komentar minimal 10 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Setelah review dikirim, task akan dianggap selesai penuh untuk kebutuhan demo UAS.',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitReview,
                      icon: const Icon(Icons.rate_review_rounded, size: 18),
                      label: const Text('Kirim Review'),
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

  void _submitReview() {
    if (!_formKey.currentState!.validate()) return;
    _showSuccessSheet();
  }

  Future<void> _showSuccessSheet() async {
    final result = ReviewSubmissionResult(
      rating: _rating,
      comment: _commentController.text.trim(),
      finalTaskStatus: TaskStatus.completed,
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
                  'Review Berhasil Dikirim',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Penilaian ${result.rating} bintang tersimpan untuk demo dan task dianggap selesai.',
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
                    child: const Text('Selesai'),
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
