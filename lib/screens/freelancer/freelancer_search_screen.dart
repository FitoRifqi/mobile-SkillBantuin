import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../services/mock_task_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';
import 'freelancer_task_detail_screen.dart';

class FreelancerSearchScreen extends StatefulWidget {
  const FreelancerSearchScreen({super.key});

  @override
  State<FreelancerSearchScreen> createState() => _FreelancerSearchScreenState();
}

class _FreelancerSearchScreenState extends State<FreelancerSearchScreen> {
  final _taskService = MockTaskService();
  final _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _taskService.getAvailableTasks();
    final filteredTasks = tasks.where((task) {
      final matchesSearch = _searchController.text.trim().isEmpty ||
          task.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          task.category.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesCategory = _selectedCategory == null || task.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Tugas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari tugas berdasarkan judul atau kategori...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () => _showFilterSheet(context),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: filteredTasks
                  .map(
                    (task) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TaskCard(task: task),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final categories = _taskService.getClientCategories();

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Semua'),
                  selected: _selectedCategory == null,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = null;
                    });
                    Navigator.pop(context);
                  },
                ),
                ...categories.map(
                  (category) => ChoiceChip(
                    label: Text(category.title),
                    selected: _selectedCategory == category.title,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category.title;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final AvailableTask task;

  const _TaskCard({required this.task});

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
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(
                label: task.category,
                color: const Color(0xFF2563EB),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(icon: Icons.wallet_outlined, label: formatRupiah(task.initialBudget)),
              _FilterChip(icon: Icons.schedule_rounded, label: task.deadlineLabel),
              _FilterChip(icon: Icons.person_outline_rounded, label: task.clientName),
              _FilterChip(icon: Icons.location_on_outlined, label: task.location),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${task.applicantsCount} volunteer sudah melamar • ${task.postedLabel}',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FreelancerTaskDetailScreen(task: task),
                    ),
                  );
                },
                child: const Text('Detail'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FilterChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF2563EB)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
