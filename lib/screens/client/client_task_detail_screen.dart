import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';
import '../shared/file_preview_screen.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/status_badge.dart';
import 'client_offers_screen.dart';
import 'client_payment_screen.dart';
import 'client_review_screen.dart';

class ClientTaskDetailScreen extends StatefulWidget {
  final ClientTask task;

  const ClientTaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  State<ClientTaskDetailScreen> createState() => _ClientTaskDetailScreenState();
}

class _ClientTaskDetailScreenState extends State<ClientTaskDetailScreen> {
  bool _isOpeningResultFile = false;
  TaskStatus? _statusOverride;
  PaymentStatus? _paymentStatusOverride;

  ClientTask get task => widget.task;
  TaskStatus get _currentStatus => _statusOverride ?? task.status;
  PaymentStatus get _currentPaymentStatus =>
      _paymentStatusOverride ?? task.paymentStatus;
  bool get _isWaitingForFreelancerResult =>
      _currentStatus == TaskStatus.paymentVerified ||
      _currentStatus == TaskStatus.onProgress;
  bool get _shouldShowOffers =>
      _currentStatus == TaskStatus.open ||
      _currentStatus == TaskStatus.waitingOffer ||
      _currentStatus == TaskStatus.negotiation ||
      _currentStatus == TaskStatus.waitingPayment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Permintaan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          _buildStepTracker(),
          const SizedBox(height: 16),
          _buildDetailCard(),
          const SizedBox(height: 16),
          if (_hasSubmittedResult) ...[
            _buildResultCard(),
            const SizedBox(height: 16),
          ],
          if (_shouldShowOffers) ...[
            _buildOfferPreview(context),
            const SizedBox(height: 16),
          ],
          if (_isWaitingForFreelancerResult) ...[
            _buildWaitingResultCard(),
            const SizedBox(height: 16),
          ],
          _buildActionPanel(context),
        ],
      ),
    );
  }

  Widget _buildStepTracker() {
    final steps = [
      _TaskStepData(
        label: 'Penawaran',
        icon: Icons.local_offer_outlined,
        done: _stepIndex >= 0,
        active: _stepIndex == 0,
      ),
      _TaskStepData(
        label: 'Pembayaran',
        icon: Icons.payments_outlined,
        done: _stepIndex >= 1,
        active: _stepIndex == 1,
      ),
      _TaskStepData(
        label: 'Dikerjakan',
        icon: Icons.work_outline_rounded,
        done: _stepIndex >= 2,
        active: _stepIndex == 2,
      ),
      _TaskStepData(
        label: 'Hasil',
        icon: Icons.upload_file_outlined,
        done: _stepIndex >= 3,
        active: _stepIndex == 3,
      ),
      _TaskStepData(
        label: 'Review',
        icon: Icons.star_outline_rounded,
        done: _stepIndex >= 4,
        active: _stepIndex == 4,
      ),
    ];

    return _SectionCard(
      title: 'Progress Tugas',
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            _TaskStepTile(
              data: steps[i],
              isLast: i == steps.length - 1,
            ),
        ],
      ),
    );
  }

  int get _stepIndex {
    switch (_currentStatus) {
      case TaskStatus.open:
      case TaskStatus.waitingOffer:
      case TaskStatus.negotiation:
        return 0;
      case TaskStatus.waitingPayment:
        return 1;
      case TaskStatus.paymentVerified:
      case TaskStatus.onProgress:
        return 2;
      case TaskStatus.submitted:
        return 3;
      case TaskStatus.completed:
        return 4;
      case TaskStatus.cancelled:
      case TaskStatus.overdue:
        return 0;
    }
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF047857)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusBadge(
            label: taskStatusLabel(_currentStatus),
            color: Colors.white,
          ),
          const SizedBox(height: 14),
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            task.description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard() {
    return _SectionCard(
      title: 'Informasi Tugas',
      child: Column(
        children: [
          _buildRow('Kategori', task.category),
          _buildRow('Budget awal', formatRupiah(task.initialBudget)),
          _buildRow(
            'Budget deal',
            task.agreedBudget != null
                ? formatRupiah(task.agreedBudget!)
                : 'Belum ada',
          ),
          _buildRow('Deadline', task.deadlineLabel),
          _buildRow('Tipe bantuan', assistanceTypeLabel(task.assistanceType)),
          if (task.location != null) _buildRow('Lokasi', task.location!),
          if (task.attachmentName != null)
            _buildRow('Lampiran', task.attachmentName!),
          _buildRow(
              'Status pembayaran', paymentStatusLabel(_currentPaymentStatus)),
          _buildRow(
              'Freelancer terpilih', task.assignedFreelancer ?? 'Belum ada'),
          _buildRow('Aksi terdekat', _nearestActionLabel, isLast: true),
        ],
      ),
    );
  }

  String get _nearestActionLabel {
    if (_currentStatus == TaskStatus.onProgress) {
      return 'Menunggu freelancer mengirim hasil pekerjaan';
    }
    if (_currentStatus == TaskStatus.paymentVerified) {
      return 'Pembayaran berhasil. Menunggu freelancer mengirim hasil pekerjaan';
    }
    if (_currentStatus == TaskStatus.submitted) {
      return 'Tinjau hasil pekerjaan dan beri review';
    }
    if (_currentStatus == TaskStatus.completed) {
      return 'Tugas sudah selesai';
    }
    return task.nearestAction;
  }

  bool get _hasSubmittedResult {
    return (task.resultFileName != null && task.resultFileName!.isNotEmpty) ||
        (task.resultLink != null && task.resultLink!.isNotEmpty) ||
        (task.resultNote != null && task.resultNote!.isNotEmpty);
  }

  Widget _buildResultCard() {
    return _SectionCard(
      title: 'Hasil Pekerjaan',
      child: Column(
        children: [
          if (task.resultFileName != null && task.resultFileName!.isNotEmpty)
            _ResultFileRow(
              fileName: task.resultFileName!,
              isLoading: _isOpeningResultFile,
              onOpen: _openResultFile,
            ),
          if (task.resultLink != null && task.resultLink!.isNotEmpty)
            _buildRow('Link hasil', task.resultLink!),
          if (task.resultNote != null && task.resultNote!.isNotEmpty)
            _buildRow('Catatan', task.resultNote!),
          if (task.resultSubmittedAt != null &&
              task.resultSubmittedAt!.isNotEmpty)
            _buildRow('Dikirim pada', task.resultSubmittedAt!, isLast: true),
        ],
      ),
    );
  }

  Widget _buildOfferPreview(BuildContext context) {
    return _SectionCard(
      title: 'Preview Penawaran',
      trailing: task.offers.isEmpty
          ? null
          : TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClientOffersScreen(task: task),
                  ),
                );
              },
              child: const Text('Lihat Semua'),
            ),
      child: Column(
        children: task.offers.isEmpty
            ? const [
                Text(
                  'Belum ada penawaran yang masuk untuk tugas ini.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                  ),
                ),
              ]
            : task.offers.take(2).map((offer) {
                final previewOffers = task.offers.take(2).toList();
                final isLast = offer == previewOffers.last;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer.freelancerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${formatRupiah(offer.offeredBudget)} • ${offer.proposedDeadline}',
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(
                          label: offerStatusLabel(offer.status),
                          color: offerStatusColor(offer.status),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
      ),
    );
  }

  Widget _buildWaitingResultCard() {
    return _SectionCard(
      title: 'Menunggu Hasil Freelancer',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFA7F3D0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.work_history_rounded,
                color: Color(0xFF059669),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Pembayaran sudah berhasil. Freelancer sudah bisa mulai mengerjakan tugas dan mengirim hasil dari menu Pekerjaan.',
                style: TextStyle(
                  color: Color(0xFF047857),
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionPanel(BuildContext context) {
    if (_isWaitingForFreelancerResult) {
      return const _SectionCard(
        title: 'Status Berikutnya',
        child: Text(
          'Menunggu freelancer mengupload hasil pekerjaan. Setelah hasil dikirim, tombol review akan tersedia di halaman ini.',
          style: TextStyle(
            color: Color(0xFF64748B),
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return _SectionCard(
      title: 'Aksi Cepat',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          if (_shouldShowOffers)
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClientOffersScreen(task: task),
                  ),
                );
              },
              icon: const Icon(Icons.groups_rounded, size: 18),
              label: const Text('Daftar Penawaran'),
            ),
          OutlinedButton.icon(
            onPressed: _currentStatus == TaskStatus.waitingPayment
                ? () async {
                    final result =
                        await Navigator.push<PaymentSubmissionResult>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientPaymentScreen(task: task),
                      ),
                    );
                    if (result != null && context.mounted) {
                      if (result.paymentStatus == PaymentStatus.verified) {
                        setState(() {
                          _statusOverride = TaskStatus.onProgress;
                          _paymentStatusOverride = PaymentStatus.verified;
                        });
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result.paymentStatus == PaymentStatus.verified
                                ? 'Pembayaran berhasil. Tugas masuk tahap pengerjaan.'
                                : 'Menunggu pembayaran ${result.paymentMethod}.',
                          ),
                        ),
                      );
                    }
                  }
                : null,
            icon: const Icon(Icons.payments_outlined, size: 18),
            label: const Text('Bayar via Midtrans'),
          ),
          OutlinedButton.icon(
            onPressed: _currentStatus == TaskStatus.completed ||
                    _currentStatus == TaskStatus.submitted
                ? () async {
                    final result = await Navigator.push<ReviewSubmissionResult>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientReviewScreen(task: task),
                      ),
                    );
                    if (result != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Review ${result.rating} bintang terkirim.',
                          ),
                        ),
                      );
                    }
                  }
                : null,
            icon: const Icon(Icons.star_outline_rounded, size: 18),
            label: Text(
              _currentStatus == TaskStatus.submitted
                  ? 'Terima Hasil & Review'
                  : 'Review',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 124,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openResultFile() async {
    if (_isOpeningResultFile) return;

    setState(() => _isOpeningResultFile = true);
    try {
      final session = await SessionService().getSession();
      final token = session?.token;
      if (token == null || token.isEmpty) {
        throw ApiException('Sesi login tidak ditemukan. Silakan login ulang.');
      }

      final bytes = await ApiService().getBytes(
        '/projects/${task.id}/result-file',
        token: token,
      );
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FilePreviewScreen(
            fileName: task.resultFileName!,
            bytes: bytes,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isOpeningResultFile = false);
    }
  }
}

class _ResultFileRow extends StatelessWidget {
  final String fileName;
  final bool isLoading;
  final VoidCallback onOpen;

  const _ResultFileRow({
    required this.fileName,
    required this.isLoading,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 124,
            child: Text(
              'File hasil',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: isLoading ? null : onOpen,
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.visibility_rounded, size: 18),
            label: Text(isLoading ? 'Membuka' : 'Buka'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF059669),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(72, 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _TaskStepData {
  final String label;
  final IconData icon;
  final bool done;
  final bool active;

  const _TaskStepData({
    required this.label,
    required this.icon,
    required this.done,
    required this.active,
  });
}

class _TaskStepTile extends StatelessWidget {
  final _TaskStepData data;
  final bool isLast;

  const _TaskStepTile({
    required this.data,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = data.done ? const Color(0xFF059669) : const Color(0xFFCBD5E1);
    final textColor =
        data.done ? AuthFlowPalette.textPrimary : AuthFlowPalette.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: data.done ? 0.14 : 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                data.done ? Icons.check_rounded : data.icon,
                color: color,
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 22,
                color: color.withValues(alpha: data.done ? 0.45 : 0.24),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 7, bottom: isLast ? 0 : 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    data.label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (data.active)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Aktif',
                      style: TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
