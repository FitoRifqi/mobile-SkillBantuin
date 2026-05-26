import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';
import '../../services/mock_task_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/status_badge.dart';
import 'freelancer_upload_result_screen.dart';

class FreelancerWorkScreen extends StatefulWidget {
  const FreelancerWorkScreen({super.key});

  @override
  State<FreelancerWorkScreen> createState() => _FreelancerWorkScreenState();
}

class _FreelancerWorkScreenState extends State<FreelancerWorkScreen> {
  final _taskService = MockTaskService();
  final _searchController = TextEditingController();
  WorkStatus? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final works = _taskService.getFreelancerWorks();
    final query = _searchController.text.trim().toLowerCase();
    final filtered = works.where((item) {
      final matchesStatus =
          _selectedStatus == null || item.status == _selectedStatus;
      final matchesSearch = query.isEmpty ||
          item.taskTitle.toLowerCase().contains(query) ||
          item.clientName.toLowerCase().contains(query) ||
          item.nextStep.toLowerCase().contains(query) ||
          item.deadlineLabel.toLowerCase().contains(query) ||
          workStatusLabel(item.status).toLowerCase().contains(query);

      return matchesStatus && matchesSearch;
    }).toList();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari pekerjaan, client, atau status...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
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
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (filtered.isEmpty)
            const AppEmptyState(
              icon: Icons.inbox_outlined,
              title: 'Pekerjaan tidak ditemukan',
              message: 'Coba ubah kata kunci atau filter status.',
            )
          else
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
                    color: Color(0xFF059669),
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
                    const SnackBar(
                      content: Text(
                        'Hasil dikirim. Menunggu review client.',
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
