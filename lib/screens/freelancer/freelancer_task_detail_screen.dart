import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../services/project_service.dart';
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
  final _projectService = ProjectService();
  late AvailableTask task;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    _loadProjectDetail();
  }

  Future<void> _loadProjectDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final detail = await _projectService.getProjectDetail(task.id);
      if (!mounted) return;
      setState(() {
        task = detail.toAvailableTask();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Detail tugas dari server belum bisa dimuat.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_isLoading || _errorMessage != null) ...[
            _TaskDetailStateBanner(
              isLoading: _isLoading,
              message: _isLoading
                  ? 'Memuat detail dari backend Laravel...'
                  : _errorMessage!,
              onRetry: _errorMessage == null ? null : _loadProjectDetail,
            ),
            const SizedBox(height: 16),
          ],
          Container(
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
                    label: 'Reward awal',
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
                    value: '${task.applicantsCount} volunteer',
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
                  color: const Color(0xFF2563EB),
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

class _TaskDetailStateBanner extends StatelessWidget {
  final bool isLoading;
  final String message;
  final VoidCallback? onRetry;

  const _TaskDetailStateBanner({
    required this.isLoading,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            )
          else
            const Icon(Icons.error_outline_rounded, color: Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text('Coba Lagi'),
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
