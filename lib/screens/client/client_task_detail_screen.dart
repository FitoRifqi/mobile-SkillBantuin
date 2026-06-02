import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/status_badge.dart';
import 'client_offers_screen.dart';
import 'client_payment_screen.dart';
import 'client_review_screen.dart';

class ClientTaskDetailScreen extends StatelessWidget {
  final ClientTask task;

  const ClientTaskDetailScreen({
    super.key,
    required this.task,
  });

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
          _buildOfferPreview(context),
          const SizedBox(height: 16),
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
    switch (task.status) {
      case TaskStatus.open:
      case TaskStatus.waitingOffer:
      case TaskStatus.negotiation:
        return 0;
      case TaskStatus.waitingPayment:
      case TaskStatus.paymentVerified:
        return 1;
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
            label: taskStatusLabel(task.status),
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
              'Status pembayaran', paymentStatusLabel(task.paymentStatus)),
          _buildRow(
              'Freelancer terpilih', task.assignedFreelancer ?? 'Belum ada'),
          _buildRow('Aksi terdekat', task.nearestAction, isLast: true),
        ],
      ),
    );
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
            _buildRow('File hasil', task.resultFileName!),
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

  Widget _buildActionPanel(BuildContext context) {
    return _SectionCard(
      title: 'Aksi Cepat',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
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
            onPressed: task.status == TaskStatus.waitingPayment
                ? () async {
                    final result =
                        await Navigator.push<PaymentSubmissionResult>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientPaymentScreen(task: task),
                      ),
                    );
                    if (result != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Menunggu pembayaran ${result.paymentMethod}.',
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
            onPressed: task.status == TaskStatus.completed ||
                    task.status == TaskStatus.submitted
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
              task.status == TaskStatus.submitted
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
