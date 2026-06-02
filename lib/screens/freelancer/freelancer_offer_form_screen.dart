import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../services/marketplace_service.dart';
import '../../utils/task_ui_utils.dart';

class FreelancerOfferFormScreen extends StatefulWidget {
  final AvailableTask task;

  const FreelancerOfferFormScreen({
    super.key,
    required this.task,
  });

  @override
  State<FreelancerOfferFormScreen> createState() =>
      _FreelancerOfferFormScreenState();
}

class _FreelancerOfferFormScreenState extends State<FreelancerOfferFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();
  final _deadlineController = TextEditingController(text: '2 hari');
  final _messageController = TextEditingController();
  final _marketplaceService = MarketplaceService();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _budgetController.text = widget.task.initialBudget.toString();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _deadlineController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Penawaran'),
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
                  widget.task.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.task.clientName} • ${formatRupiah(widget.task.initialBudget)}',
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
                  const Text(
                    'Form Penawaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga penawaran',
                      prefixText: 'Rp ',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Harga penawaran wajib diisi';
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return 'Harga penawaran harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _deadlineController,
                    decoration: const InputDecoration(
                      labelText: 'Deadline penawaran',
                      hintText: 'Contoh: 2 hari',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Deadline penawaran wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Pesan penawaran',
                      hintText:
                          'Tulis penjelasan singkat tentang keunggulanmu dan rencana pengerjaan...',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Pesan penawaran wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitOffer,
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: Text(
                          _isSubmitting ? 'Mengirim...' : 'Kirim Penawaran'),
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

  Future<void> _submitOffer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await _marketplaceService.applyToProject(
        projectId: widget.task.id,
        offeredBudget: int.parse(_budgetController.text.trim()),
        message: _messageController.text.trim(),
        proposedDeadlineDays: _parseDeadlineDays(_deadlineController.text),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Penawaran berhasil dikirim ke Laravel.'),
        ),
      );
      Navigator.pop(
        context,
        SubmittedOfferViewData(
          offeredBudget: int.parse(_budgetController.text.trim()),
          deadlineDays: _parseDeadlineDays(_deadlineController.text),
          message: _messageController.text.trim(),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  int _parseDeadlineDays(String raw) {
    final match = RegExp(r'\d+').firstMatch(raw);
    return int.tryParse(match?.group(0) ?? '') ?? 1;
  }
}

class SubmittedOfferViewData {
  final int offeredBudget;
  final int deadlineDays;
  final String message;

  const SubmittedOfferViewData({
    required this.offeredBudget,
    required this.deadlineDays,
    required this.message,
  });
}
