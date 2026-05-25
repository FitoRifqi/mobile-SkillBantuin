import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';
import '../../services/mock_task_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/status_badge.dart';
import 'client_payment_screen.dart';
import 'client_review_screen.dart';
import 'client_task_detail_screen.dart';

class ClientProjectsScreen extends StatelessWidget {
  const ClientProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ClientActivityView();
  }
}

class _ClientActivityView extends StatefulWidget {
  const _ClientActivityView();

  @override
  State<_ClientActivityView> createState() => _ClientActivityViewState();
}

class _ClientActivityViewState extends State<_ClientActivityView> {
  final _taskService = MockTaskService();
  TaskStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final allTasks = _taskService.getClientTasks();
    final filteredTasks = _selectedStatus == null
        ? allTasks
        : allTasks.where((task) => task.status == _selectedStatus).toList();

    return Scaffold(
      backgroundColor: AppUi.pageBackground,
      appBar: AppBar(
        title: const Text('Aktivitas Client'),
      ),
      body: ListView(
        padding: AppUi.pagePadding,
        children: [
          AppCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Tugas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 14),
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
                    ...TaskStatus.values.map(
                      (status) => ChoiceChip(
                        label: Text(taskStatusLabel(status)),
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
          if (filteredTasks.isEmpty)
            const AppEmptyState(
              icon: Icons.inbox_outlined,
              title: 'Belum ada tugas',
              message: 'Ubah filter status untuk melihat aktivitas lainnya.',
            )
          else
            ...filteredTasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ActivityTaskCard(task: task),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActivityTaskCard extends StatelessWidget {
  final ClientTask task;

  const _ActivityTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
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
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AuthFlowPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      task.nearestAction,
                      style: const TextStyle(
                        color: AuthFlowPalette.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(
                label: taskStatusLabel(task.status),
                color: taskStatusColor(task.status),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MiniChip(icon: Icons.sell_outlined, label: task.category),
              _MiniChip(
                  icon: Icons.schedule_rounded, label: task.deadlineLabel),
              _MiniChip(
                icon: Icons.wallet_outlined,
                label: formatRupiah(task.agreedBudget ?? task.initialBudget),
              ),
              _MiniChip(
                icon: Icons.person_outline_rounded,
                label: task.assignedFreelancer ?? 'Belum ada freelancer',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientTaskDetailScreen(task: task),
                      ),
                    );
                  },
                  child: const Text('Detail'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handlePrimaryAction(context),
                  child: Text(_primaryActionLabel()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _primaryActionLabel() {
    if (task.status == TaskStatus.waitingPayment) return 'Bayar';
    if (task.status == TaskStatus.completed ||
        task.status == TaskStatus.submitted) {
      return 'Review';
    }
    return 'Lanjut';
  }

  void _handlePrimaryAction(BuildContext context) async {
    if (task.status == TaskStatus.waitingPayment) {
      final result = await Navigator.push<PaymentSubmissionResult>(
        context,
        MaterialPageRoute(
          builder: (_) => ClientPaymentScreen(task: task),
        ),
      );
      if (result != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Pembayaran dicatat.',
            ),
          ),
        );
      }
      return;
    }

    if (task.status == TaskStatus.completed ||
        task.status == TaskStatus.submitted) {
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
              'Review ${result.rating} bintang tersimpan.',
            ),
          ),
        );
      }
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClientTaskDetailScreen(task: task),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniChip({
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
          Icon(icon, size: 16, color: const Color(0xFF059669)),
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
