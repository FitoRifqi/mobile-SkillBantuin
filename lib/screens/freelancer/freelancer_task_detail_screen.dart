import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';
import 'freelancer_offer_form_screen.dart';

class FreelancerTaskDetailScreen extends StatefulWidget {
  final AvailableTask task;

  const FreelancerTaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  State<FreelancerTaskDetailScreen> createState() =>
      _FreelancerTaskDetailScreenState();
}

class _FreelancerTaskDetailScreenState
    extends State<FreelancerTaskDetailScreen> {
  SubmittedOfferViewData? _submittedOffer;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
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
                const Text(
                  'Peluang Baru',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  task.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DetailCard(
            title: 'Informasi Tugas',
            child: Column(
              children: [
                _DetailRow(label: 'Kategori', value: task.category),
                _DetailRow(
                    label: 'Budget awal',
                    value: formatRupiah(task.initialBudget)),
                _DetailRow(label: 'Deadline', value: task.deadlineLabel),
                _DetailRow(
                    label: 'Tipe bantuan',
                    value: assistanceTypeLabel(task.assistanceType)),
                _DetailRow(label: 'Client', value: task.clientName),
                _DetailRow(label: 'Lokasi', value: task.location),
                _DetailRow(label: 'Diposting', value: task.postedLabel),
                _DetailRow(
                    label: 'Peminat',
                    value: '${task.applicantsCount} freelancer',
                    isLast: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DetailCard(
            title: 'Highlight Kecocokan',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusBadge(
                  label: task.category,
                  color: const Color(0xFF059669),
                ),
                StatusBadge(
                  label: task.budgetRangeLabel,
                  color: const Color(0xFF10B981),
                ),
                StatusBadge(
                  label: 'Deadline ${task.deadlineLabel}',
                  color: const Color(0xFFF59E0B),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (_submittedOffer != null)
            _OfferSubmittedPanel(
              taskTitle: task.title,
              offer: _submittedOffer!,
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final submitted =
                      await Navigator.push<SubmittedOfferViewData>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FreelancerOfferFormScreen(task: task),
                    ),
                  );

                  if (!mounted || submitted == null) return;
                  setState(() => _submittedOffer = submitted);
                },
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('Ajukan Penawaran'),
              ),
            ),
        ],
      ),
    );
  }
}

class _OfferSubmittedPanel extends StatelessWidget {
  final String taskTitle;
  final SubmittedOfferViewData offer;

  const _OfferSubmittedPanel({
    required this.taskTitle,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF059669),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Penawaran Terkirim',
                  style: TextStyle(
                    color: Color(0xFF064E3B),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Penawaran untuk "$taskTitle" sudah dikirim. Sekarang menunggu client menerima atau menolak penawaranmu.',
            style: const TextStyle(
              color: Color(0xFF047857),
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          _SubmittedOfferRow(
            label: 'Harga penawaran',
            value: formatRupiah(offer.offeredBudget),
          ),
          _SubmittedOfferRow(
            label: 'Estimasi pengerjaan',
            value: '${offer.deadlineDays} hari',
            isLast: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Kembali ke daftar tugas'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF047857),
                side: const BorderSide(color: Color(0xFFA7F3D0)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmittedOfferRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _SubmittedOfferRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF047857),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF064E3B),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailCard({
    required this.title,
    required this.child,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
