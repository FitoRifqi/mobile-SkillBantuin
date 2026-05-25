import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';
import 'freelancer_offer_form_screen.dart';

class FreelancerTaskDetailScreen extends StatelessWidget {
  final AvailableTask task;

  const FreelancerTaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FreelancerOfferFormScreen(task: task),
                  ),
                );
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
