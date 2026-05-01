import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';
import '../../services/mock_task_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';
import 'freelancer_upload_result_screen.dart';

class FreelancerWorkScreen extends StatefulWidget {
  const FreelancerWorkScreen({super.key});

  @override
  State<FreelancerWorkScreen> createState() => _FreelancerWorkScreenState();
}

class _FreelancerWorkScreenState extends State<FreelancerWorkScreen> {
  final _taskService = MockTaskService();
  WorkStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final works = _taskService.getFreelancerWorks();
    final filtered = _selectedStatus == null
        ? works
        : works.where((item) => item.status == _selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan'),
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
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Semua'),
                  selected: _selectedStatus == null,
                  onSelected: (_) {
                    setState(() {
                      _selectedStatus = null;
                    });
                  },
                ),
                ...WorkStatus.values.map(
                  (status) => ChoiceChip(
                    label: Text(workStatusLabel(status)),
                    selected: _selectedStatus == status,
                    onSelected: (_) {
                      setState(() {
                        _selectedStatus = status;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...filtered.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _WorkCard(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkCard extends StatelessWidget {
  final FreelancerWorkItem item;

  const _WorkCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.taskTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Client: ${item.clientName}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(
                label: workStatusLabel(item.status),
                color: workStatusColor(item.status),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.nextStep,
            style: const TextStyle(
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Budget ${formatRupiah(item.agreedBudget)}',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'Deadline ${item.deadlineLabel}',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: item.progress / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E8F0),
              color: workStatusColor(item.status),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push<WorkSubmissionResult>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FreelancerUploadResultScreen(item: item),
                  ),
                );
                if (result != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Hasil dikirim. Status demo lanjut ke ${taskStatusLabel(result.nextTaskStatus)} dan menunggu review client.',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.upload_file_rounded, size: 18),
              label: const Text('Upload Hasil'),
            ),
          ),
        ],
      ),
    );
  }
}
