import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../models/task_models.dart';
import '../../models/user_role.dart';
import '../../providers/project_provider.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/dashboard_widgets.dart';
import '../../widgets/status_badge.dart';
import '../shared/notification_screen.dart';
import 'client_projects_screen.dart';
import 'client_search_screen.dart';
import 'client_task_detail_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchMyProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        final projects = projectProvider.projects;
        final activeProjects = projects.where(_isActiveProject).toList();
        final waitingProjects = projects.where(_isWaitingProject).toList();
        final completedProjects = projects.where(_isCompletedProject).toList();

        return DashboardScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (projectProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (projectProvider.errorMessage != null)
                DashboardPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gagal memuat data: ${projectProvider.errorMessage}',
                        style: const TextStyle(
                          color: AuthFlowPalette.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          projectProvider.fetchMyProjects();
                        },
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
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
                    label: 'Notifikasi',
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(
                              userRole: UserRole.client),
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
              DashboardMetricGrid(
                metrics: [
                  DashboardMetricData(
                    label: 'Bantuan Aktif',
                    value: activeProjects.length.toString().padLeft(2, '0'),
                    helperText: 'Fokus hari ini',
                    icon: Icons.assignment_outlined,
                    color: AuthFlowPalette.primary,
                  ),
                  DashboardMetricData(
                    label: 'Menunggu',
                    value: waitingProjects.length.toString().padLeft(2, '0'),
                    helperText: 'Butuh offer',
                    icon: Icons.pending_actions_rounded,
                    color: const Color(0xFF14B8A6),
                  ),
                  DashboardMetricData(
                    label: 'Selesai',
                    value: completedProjects.length.toString().padLeft(2, '0'),
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
              if (projectProvider.isLoading)
                const SizedBox.shrink()
              else if (projects.isEmpty)
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
                ...activeProjects.take(3).map(
                      (project) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ActiveProjectCard(project: project),
                      ),
                    ),
            ],
          ),
        );
      },
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

  static bool _isActiveProject(ProjectModel project) {
    final status = project.status?.toLowerCase() ?? '';
    return status.contains('progress') ||
        status.contains('open') ||
        status.contains('negotiation');
  }

  static bool _isWaitingProject(ProjectModel project) {
    final status = project.status?.toLowerCase() ?? '';
    return status.contains('open') || status.contains('waiting');
  }

  static bool _isCompletedProject(ProjectModel project) {
    final status = project.status?.toLowerCase() ?? '';
    return status.contains('completed') || status.contains('done');
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ActiveProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _ActiveProjectCard({required this.project});

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
                      project.judul ?? 'Judul tidak tersedia',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AuthFlowPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _projectNearestAction(project.status),
                      style: const TextStyle(
                        color: AuthFlowPalette.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              StatusBadge(
                label: _projectStatusLabel(project.status),
                color: _projectStatusColor(project.status),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.sell_outlined,
                label: project.kategori?.namaKategori ?? 'Kategori lain',
              ),
              _InfoChip(
                icon: Icons.schedule_rounded,
                label: _projectDeadlineLabel(project.deadline),
              ),
              _InfoChip(
                icon: Icons.wallet_outlined,
                label: _projectBudgetLabel(project),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                final task = _projectToClientTask(project);
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

  static String _projectDeadlineLabel(DateTime? deadline) {
    if (deadline == null) return 'TBD';
    return '${deadline.day}/${deadline.month}/${deadline.year}';
  }

  static String _projectBudgetLabel(ProjectModel project) {
    final minBudget = project.anggaranMin ?? 0;
    final maxBudget = project.anggaranMax;
    if (maxBudget != null && maxBudget > minBudget) {
      return '${formatRupiah(minBudget)} - ${formatRupiah(maxBudget)}';
    }
    return formatRupiah(minBudget);
  }

  static String _projectNearestAction(String? status) {
    final normalized = status?.toLowerCase() ?? '';
    if (normalized.contains('open') || normalized.contains('waiting')) {
      return 'Menunggu freelancer mengajukan penawaran';
    }
    if (normalized.contains('negotiation')) {
      return 'Negosiasi penawaran freelancer';
    }
    if (normalized.contains('payment')) {
      return 'Selesaikan pembayaran untuk memulai';
    }
    if (normalized.contains('progress')) {
      return 'Lihat progres terbaru dari freelancer';
    }
    if (normalized.contains('submitted')) {
      return 'Tinjau hasil pekerjaan yang dikirim';
    }
    if (normalized.contains('completed') || normalized.contains('done')) {
      return 'Tugas sudah selesai';
    }
    return 'Periksa detail tugas';
  }

  static String _projectStatusLabel(String? status) {
    final mapped = _projectStatusToTaskStatus(status);
    return taskStatusLabel(mapped);
  }

  static Color _projectStatusColor(String? status) {
    final mapped = _projectStatusToTaskStatus(status);
    return taskStatusColor(mapped);
  }

  static TaskStatus _projectStatusToTaskStatus(String? status) {
    final normalized = status?.toLowerCase() ?? '';
    if (normalized.contains('completed') || normalized.contains('done')) {
      return TaskStatus.completed;
    }
    if (normalized.contains('submitted')) {
      return TaskStatus.submitted;
    }
    if (normalized.contains('payment')) {
      if (normalized.contains('waiting') || normalized.contains('pending')) {
        return TaskStatus.waitingPayment;
      }
      return TaskStatus.paymentVerified;
    }
    if (normalized.contains('progress')) {
      return TaskStatus.onProgress;
    }
    if (normalized.contains('negotiation')) {
      return TaskStatus.negotiation;
    }
    if (normalized.contains('open') || normalized.contains('waiting')) {
      return TaskStatus.waitingOffer;
    }
    return TaskStatus.open;
  }

  static ClientTask _projectToClientTask(ProjectModel project) {
    final mappedStatus = _projectStatusToTaskStatus(project.status);
    final deadline = project.deadline;
    return ClientTask(
      id: project.id?.toString() ?? '',
      title: project.judul ?? 'Judul tidak tersedia',
      category: project.kategori?.namaKategori ?? 'Kategori lain',
      description: project.deskripsi ?? '',
      initialBudget: project.anggaranMin ?? 0,
      agreedBudget: project.anggaranMax,
      deadlineLabel: _projectDeadlineLabel(deadline),
      createdAtLabel: 'Baru saja',
      status: mappedStatus,
      paymentStatus: mappedStatus == TaskStatus.waitingPayment
          ? PaymentStatus.pending
          : PaymentStatus.unpaid,
      assistanceType: AssistanceType.online,
      nearestAction: _projectNearestAction(project.status),
      progress: mappedStatus == TaskStatus.onProgress ? 50 : 20,
      offers: const [],
      resultFileName: project.resultFileName ?? project.resultFile,
      resultFileUrl: project.resultFileUrl,
      resultLink: project.resultLink,
      resultNote: project.resultNote,
      resultSubmittedAt: project.resultSubmittedAt,
      assignedFreelancer: project.offers?.first.freelancer?.namaLengkap,
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
