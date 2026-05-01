import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';
import '../../utils/task_ui_utils.dart';
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
          _buildDetailCard(),
          const SizedBox(height: 16),
          _buildOfferPreview(context),
          const SizedBox(height: 16),
          _buildActionPanel(context),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
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
          _buildRow('Reward awal', formatRupiah(task.initialBudget)),
          _buildRow(
            'Reward deal',
            task.agreedBudget != null ? formatRupiah(task.agreedBudget!) : 'Belum ada',
          ),
          _buildRow('Deadline', task.deadlineLabel),
          _buildRow('Tipe bantuan', assistanceTypeLabel(task.assistanceType)),
          if (task.location != null) _buildRow('Lokasi', task.location!),
          if (task.attachmentName != null) _buildRow('Lampiran', task.attachmentName!),
          _buildRow('Status pembayaran', paymentStatusLabel(task.paymentStatus)),
          _buildRow('Volunteer terpilih', task.assignedFreelancer ?? 'Belum ada'),
          _buildRow('Aksi terdekat', task.nearestAction, isLast: true),
        ],
      ),
    );
  }

  Widget _buildOfferPreview(BuildContext context) {
    return _SectionCard(
      title: 'Preview Penawaran Volunteer',
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
                            'Pembayaran ${result.paymentMethod} dicatat. Status demo lanjut ke ${taskStatusLabel(result.nextTaskStatus)}.',
                          ),
                        ),
                      );
                    }
                  }
                : null,
            icon: const Icon(Icons.payments_outlined, size: 18),
            label: const Text('Pembayaran'),
          ),
          OutlinedButton.icon(
            onPressed: task.status == TaskStatus.completed || task.status == TaskStatus.submitted
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
                            'Review ${result.rating} bintang terkirim. Task demo dianggap ${taskStatusLabel(result.finalTaskStatus)}.',
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
