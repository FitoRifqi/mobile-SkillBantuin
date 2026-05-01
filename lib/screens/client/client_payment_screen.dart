import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';
import '../../utils/task_ui_utils.dart';

class ClientPaymentScreen extends StatefulWidget {
  final ClientTask task;
  final VolunteerOffer? selectedOffer;

  const ClientPaymentScreen({
    super.key,
    required this.task,
    this.selectedOffer,
  });

  @override
  State<ClientPaymentScreen> createState() => _ClientPaymentScreenState();
}

class _ClientPaymentScreenState extends State<ClientPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _proofController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedMethod = 'Transfer Bank';

  int get _totalPayment =>
      widget.selectedOffer?.offeredBudget ??
      widget.task.agreedBudget ??
      widget.task.initialBudget;

  @override
  void dispose() {
    _proofController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Dummy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 16),
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
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedMethod,
                    decoration: const InputDecoration(
                      labelText: 'Pilih metode',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Transfer Bank',
                        child: Text('Transfer Bank'),
                      ),
                      DropdownMenuItem(
                        value: 'QRIS Dummy',
                        child: Text('QRIS Dummy'),
                      ),
                      DropdownMenuItem(
                        value: 'E-Wallet Dummy',
                        child: Text('E-Wallet Dummy'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value ?? 'Transfer Bank';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _PaymentInfoCard(method: _selectedMethod),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _proofController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Upload bukti pembayaran',
                      hintText: 'Belum ada file dipilih',
                      suffixIcon: TextButton(
                        onPressed: _pickProof,
                        child: const Text('Upload'),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bukti pembayaran perlu dipilih untuk demo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    minLines: 3,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Catatan pembayaran',
                      hintText: 'Contoh: Bukti transfer dikirim dari rekening pribadi.',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alur Demo Berikutnya',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Setelah pembayaran dikonfirmasi, task akan dianggap masuk ke tahap verifikasi/siap dikerjakan oleh freelancer untuk kebutuhan presentasi.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitPayment,
                      icon: const Icon(Icons.verified_rounded, size: 18),
                      label: const Text('Konfirmasi Pembayaran'),
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

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pembayaran',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.task.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Volunteer', widget.selectedOffer?.freelancerName ?? widget.task.assignedFreelancer ?? '-'),
          _buildSummaryRow('Total pembayaran', formatRupiah(_totalPayment)),
          _buildSummaryRow('Status saat ini', paymentStatusLabel(widget.task.paymentStatus)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.78),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _pickProof() {
    setState(() {
      _proofController.text = 'bukti-pembayaran-client.png';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File dummy berhasil dipilih untuk kebutuhan demo.'),
      ),
    );
  }

  void _submitPayment() {
    if (!_formKey.currentState!.validate()) return;
    _showConfirmDialog();
  }

  Future<void> _showConfirmDialog() async {
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Text(
          'Konfirmasi pembayaran dummy sebesar ${formatRupiah(_totalPayment)} dengan metode $_selectedMethod?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );

    if (shouldContinue != true || !mounted) return;

    final result = PaymentSubmissionResult(
      paymentMethod: _selectedMethod,
      proofFileName: _proofController.text,
      totalAmount: _totalPayment,
      paymentStatus: PaymentStatus.pending,
      nextTaskStatus: TaskStatus.paymentVerified,
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
                  'Pembayaran Berhasil Dicatat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Bukti pembayaran ${result.proofFileName} sudah disimpan untuk demo. Tahap berikutnya: pembayaran diverifikasi lalu task masuk ke proses pengerjaan.',
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

class _PaymentInfoCard extends StatelessWidget {
  final String method;

  const _PaymentInfoCard({required this.method});

  @override
  Widget build(BuildContext context) {
    final info = switch (method) {
      'QRIS Dummy' => ('QRIS-CLIENT-2026', 'Tampilkan kode QR dummy saat presentasi'),
      'E-Wallet Dummy' => ('0899-777-666', 'A/N SkillBantuin Demo'),
      _ => ('BCA 1234567890', 'A/N SkillBantuin Demo'),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info.$1,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            info.$2,
            style: const TextStyle(
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
