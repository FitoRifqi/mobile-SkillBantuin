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
    final categories = taskService.getClientCategories();
    final freelancers = taskService.getRecommendedFreelancers();
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
                label: 'Aktivitas',
                icon: Icons.list_alt_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ClientProjectsScreen(),
                    ),
                  );
                },
              ),
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
          TextField(
            readOnly: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClientSearchScreen(),
                ),
              );
            },
            decoration: InputDecoration(
              hintText: 'Cari kategori bantuan atau buat tugas baru...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ClientSearchScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ),
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
                label: 'Belum Bayar',
                value: tasks
                    .where((task) =>
                        task.paymentStatus == PaymentStatus.unpaid ||
                        task.paymentStatus == PaymentStatus.pending)
                    .length
                    .toString()
                    .padLeft(2, '0'),
                helperText: 'Cek pembayaran',
                icon: Icons.payments_outlined,
                color: const Color(0xFFF59E0B),
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
          const DashboardSectionHeader(
            title: 'Kategori Skill',
            subtitle: 'Pilih kategori yang kamu butuhkan.',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categories
                .map(
                  (category) => _CategoryChip(data: category),
                )
                .toList(),
          ),
          const SizedBox(height: 28),
          DashboardSectionHeader(
            title: 'Bantuan Aktif',
            subtitle: 'Tugas yang perlu kamu cek.',
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
          ...activeTasks.take(3).map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ActiveTaskCard(task: task),
                ),
              ),
          const SizedBox(height: 16),
          const DashboardSectionHeader(
            title: 'Deadline Terdekat',
            subtitle: 'Prioritas hari ini.',
          ),
          const SizedBox(height: 14),
          DashboardPanel(
            child: Column(
              children: activeTasks.take(3).map(
                (task) {
                  final isLast = task == activeTasks.take(3).last;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                    child: _DeadlineTile(task: task),
                  );
                },
              ).toList(),
            ),
          ),
          const SizedBox(height: 16),
          const DashboardSectionHeader(
            title: 'Freelancer Rekomendasi',
            subtitle: 'Freelancer dengan respons baik.',
          ),
          const SizedBox(height: 14),
          ...freelancers.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RecommendedFreelancerCard(data: item),
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

class _CategoryChip extends StatelessWidget {
  final HelperCategory data;

  const _CategoryChip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ],
      ),
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

class _DeadlineTile extends StatelessWidget {
  final ClientTask task;

  const _DeadlineTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: taskStatusColor(task.status).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.event_note_rounded,
            color: taskStatusColor(task.status),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AuthFlowPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${task.deadlineLabel} • ${task.assignedFreelancer ?? 'Belum ada freelancer'}',
                style: const TextStyle(
                  color: AuthFlowPalette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        StatusBadge(
          label: paymentStatusLabel(task.paymentStatus),
          color: paymentStatusColor(task.paymentStatus),
        ),
      ],
    );
  }
}

class _RecommendedFreelancerCard extends StatelessWidget {
  final RecommendedFreelancer data;

  const _RecommendedFreelancerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AuthFlowPalette.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AuthFlowPalette.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AuthFlowPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.skill,
                  style: const TextStyle(
                    color: AuthFlowPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rating ${data.rating} • Respon ${data.responseTime}',
                  style: const TextStyle(
                    color: AuthFlowPalette.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formatRupiah(data.baseRate),
            style: const TextStyle(
              color: AuthFlowPalette.primary,
              fontWeight: FontWeight.w800,
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
