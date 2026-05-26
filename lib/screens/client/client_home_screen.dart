import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../services/mock_task_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/dashboard_widgets.dart';
import '../../widgets/status_badge.dart';
import 'client_projects_screen.dart';
import 'client_search_screen.dart';
import 'client_task_detail_screen.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = MockTaskService();
    final tasks = taskService.getClientTasks();
    final activeTasks = tasks
        .where(
          (task) =>
              task.status == TaskStatus.negotiation ||
              task.status == TaskStatus.waitingPayment ||
              task.status == TaskStatus.onProgress ||
              task.status == TaskStatus.submitted,
        )
        .toList();

    return DashboardScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeroCard(
            greeting: 'Dashboard Client',
            title: 'Buat bantuan. Pantau progres.',
            description: 'Kelola tugas, penawaran, chat, dan pembayaran.',
            primaryActionLabel: 'Buat Bantuan',
            primaryActionIcon: Icons.add_task_rounded,
            onPrimaryAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClientSearchScreen(),
                ),
              );
            },
            quickActions: [
              DashboardQuickAction(
                label: 'Cek Chat',
                icon: Icons.chat_bubble_outline_rounded,
                onTap: () => _showMessage(
                  context,
                  'Buka tab Chat untuk melanjutkan percakapan aktif.',
                ),
              ),
            ],
            trailing: _buildClientHeroBadge(),
          ),
          const SizedBox(height: 24),
          DashboardMetricGrid(
            metrics: [
              DashboardMetricData(
                label: 'Bantuan Aktif',
                value: activeTasks.length.toString().padLeft(2, '0'),
                helperText: 'Fokus hari ini',
                icon: Icons.assignment_outlined,
                color: AuthFlowPalette.primary,
              ),
              DashboardMetricData(
                label: 'Menunggu',
                value: tasks
                    .where((task) => task.status == TaskStatus.waitingOffer)
                    .length
                    .toString()
                    .padLeft(2, '0'),
                helperText: 'Butuh offer',
                icon: Icons.pending_actions_rounded,
                color: const Color(0xFF14B8A6),
              ),
              DashboardMetricData(
                label: 'Selesai',
                value: tasks
                    .where((task) => task.status == TaskStatus.completed)
                    .length
                    .toString()
                    .padLeft(2, '0'),
                helperText: 'Siap direview',
                icon: Icons.task_alt_rounded,
                color: const Color(0xFF10B981),
              ),
            ],
          ),
          const SizedBox(height: 28),
          DashboardSectionHeader(
            title: 'Aktivitas Bantuan',
            subtitle: 'Fokus ke tugas yang masih berjalan.',
            actionLabel: 'Lihat Aktivitas',
            onActionTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClientProjectsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          if (activeTasks.isEmpty)
            const DashboardPanel(
              child: Text(
                'Belum ada aktivitas bantuan yang berjalan.',
                style: TextStyle(
                  color: AuthFlowPalette.textSecondary,
                  height: 1.5,
                ),
              ),
            )
          else
            ...activeTasks.take(3).map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ActiveTaskCard(task: task),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildClientHeroBadge() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: const Icon(
        Icons.handshake_rounded,
        size: 44,
        color: Colors.white,
      ),
    );
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ActiveTaskCard extends StatelessWidget {
  final ClientTask task;

  const _ActiveTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AuthFlowPalette.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              StatusBadge(
                label: taskStatusLabel(task.status),
                color: taskStatusColor(task.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            task.nearestAction,
            style: const TextStyle(
              color: AuthFlowPalette.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.sell_outlined,
                label: task.category,
              ),
              _InfoChip(
                icon: Icons.schedule_rounded,
                label: task.deadlineLabel,
              ),
              _InfoChip(
                icon: Icons.wallet_outlined,
                label: formatRupiah(task.agreedBudget ?? task.initialBudget),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClientTaskDetailScreen(task: task),
                  ),
                );
              },
              child: const Text('Lihat Detail'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
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
          Icon(icon, size: 16, color: AuthFlowPalette.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AuthFlowPalette.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
