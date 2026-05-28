import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/user_role.dart';
import '../../services/mock_task_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/dashboard_widgets.dart';
import '../shared/notification_screen.dart';
import 'freelancer_search_screen.dart';
import 'freelancer_task_detail_screen.dart';
import 'freelancer_work_screen.dart';

class FreelancerHomeScreen extends StatelessWidget {
  const FreelancerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockTaskService();
    final tasks = service.getAvailableTasks();
    final works = service.getFreelancerWorks();
    final earnings = service.getEarningTransactions();

    return DashboardScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeroCard(
            greeting: 'Cari Tugas Freelancer',
            title: 'Cari tugas. Kirim penawaran.',
            description: 'Pantau lamaran, pekerjaan, dan pendapatan.',
            primaryActionLabel: 'Cari Tugas',
            primaryActionIcon: Icons.travel_explore_rounded,
            onPrimaryAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FreelancerSearchScreen(),
                ),
              );
            },
            quickActions: [
              DashboardQuickAction(
                label: 'Notifikasi',
                icon: Icons.notifications_none_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(
                        userRole: UserRole.freelancer,
                      ),
                    ),
                  );
                },
              ),
              DashboardQuickAction(
                label: 'Pekerjaan',
                icon: Icons.work_history_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FreelancerWorkScreen(),
                    ),
                  );
                },
              ),
            ],
            trailing: _buildFreelancerHeroBadge(),
          ),
          const SizedBox(height: 24),
          DashboardMetricGrid(
            metrics: [
              DashboardMetricData(
                label: 'Tersedia',
                value: tasks.length.toString().padLeft(2, '0'),
                helperText: 'Siap dilamar',
                icon: Icons.travel_explore_rounded,
                color: AuthFlowPalette.primary,
              ),
              DashboardMetricData(
                label: 'Berjalan',
                value: works
                    .where((item) =>
                        item.status == WorkStatus.inProgress ||
                        item.status == WorkStatus.waitingConfirmation)
                    .length
                    .toString()
                    .padLeft(2, '0'),
                helperText: 'Jaga deadline',
                icon: Icons.work_history_rounded,
                color: const Color(0xFF16A34A),
              ),
              DashboardMetricData(
                label: 'Pendapatan',
                value: formatRupiah(
                  earnings.fold<int>(0, (sum, item) => sum + item.amount),
                ),
                helperText: 'Total transaksi',
                icon: Icons.savings_rounded,
                color: const Color(0xFF10B981),
              ),
            ],
          ),
          const SizedBox(height: 28),
          DashboardSectionHeader(
            title: 'Aktivitas Tugas',
            subtitle: 'Tugas paling relevan untuk dilamar.',
            actionLabel: 'Cari Semua',
            onActionTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FreelancerSearchScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          if (tasks.isEmpty)
            const DashboardPanel(
              child: Text(
                'Belum ada tugas yang tersedia saat ini.',
                style: TextStyle(
                  color: AuthFlowPalette.textSecondary,
                  height: 1.5,
                ),
              ),
            )
          else
            ...tasks.take(3).map(
                  (project) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _RecommendedProjectCard(data: project),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFreelancerHeroBadge() {
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
        Icons.rocket_launch_rounded,
        size: 44,
        color: Colors.white,
      ),
    );
  }
}

class _RecommendedProjectCard extends StatelessWidget {
  final AvailableTask data;

  const _RecommendedProjectCard({required this.data});

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AuthFlowPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${data.category} • ${data.clientName}',
                      style: const TextStyle(
                        color: AuthFlowPalette.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  formatRupiah(data.initialBudget),
                  style: const TextStyle(
                    color: Color(0xFFF59E0B),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _LiteChip(
                  icon: Icons.flash_on_rounded, label: data.budgetRangeLabel),
              _LiteChip(
                  icon: Icons.schedule_rounded, label: data.deadlineLabel),
              _LiteChip(
                  icon: Icons.access_time_rounded, label: data.postedLabel),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FreelancerTaskDetailScreen(task: data),
                  ),
                );
              },
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Lihat Detail'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiteChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LiteChip({
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
