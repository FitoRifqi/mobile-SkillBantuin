import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_role.dart';
import '../../models/project_model.dart';
import '../../models/task_models.dart';
import '../../providers/project_provider.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/dashboard_widgets.dart';
import '../shared/notification_screen.dart';
import 'freelancer_search_screen.dart';
import 'freelancer_task_detail_screen.dart';
import 'freelancer_work_screen.dart';

class FreelancerHomeScreen extends StatefulWidget {
  const FreelancerHomeScreen({super.key});

  @override
  State<FreelancerHomeScreen> createState() => _FreelancerHomeScreenState();
}

class _FreelancerHomeScreenState extends State<FreelancerHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchProjects(params: {'status': 'open'});
    });
  }

  @override
  Widget build(BuildContext context) {
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
          Consumer<ProjectProvider>(
            builder: (context, projectProvider, _) {
              return DashboardMetricGrid(
                metrics: [
                  DashboardMetricData(
                    label: 'Tersedia',
                    value: projectProvider.projects.length
                        .toString()
                        .padLeft(2, '0'),
                    helperText: 'Siap dilamar',
                    icon: Icons.travel_explore_rounded,
                    color: AuthFlowPalette.primary,
                  ),
                  // TODO: Add freelancer-specific work and earnings metrics once
                  // protected endpoints are implemented in the backend.
                ],
              );
            },
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
          Consumer<ProjectProvider>(
            builder: (context, projectProvider, _) {
              if (projectProvider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (projectProvider.errorMessage != null) {
                return DashboardPanel(
                  child: Text(
                    'Gagal memuat tugas: ${projectProvider.errorMessage}',
                    style: const TextStyle(
                      color: AuthFlowPalette.textSecondary,
                      height: 1.5,
                    ),
                  ),
                );
              }

              if (projectProvider.projects.isEmpty) {
                return const DashboardPanel(
                  child: Text(
                    'Belum ada tugas yang tersedia saat ini.',
                    style: TextStyle(
                      color: AuthFlowPalette.textSecondary,
                      height: 1.5,
                    ),
                  ),
                );
              }

              return Column(
                children: projectProvider.projects
                    .take(3)
                    .map(
                      (project) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _RecommendedProjectCard(data: project),
                      ),
                    )
                    .toList(),
              );
            },
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
  final ProjectModel data;

  const _RecommendedProjectCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final judul = data.judul ?? 'Untitled';
    final kategoriNama = data.kategori?.namaKategori ?? 'Umum';
    final clientNama = data.client?.namaKontak ?? 'Client';
    final anggaran = data.anggaranMin ?? 0;
    final anggaranMax = data.anggaranMax;
    final deadline = data.deadline;
    final budgetLabel = (anggaranMax != null)
        ? '${formatRupiah(anggaran)} - ${formatRupiah(anggaranMax)}'
        : formatRupiah(anggaran);

    final deadlineLabel = deadline != null
        ? 'dalam ${deadline.difference(DateTime.now()).inDays} hari'
        : 'TBD';

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
                      judul,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AuthFlowPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$kategoriNama • $clientNama',
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
                  formatRupiah(anggaran),
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
              _LiteChip(icon: Icons.flash_on_rounded, label: budgetLabel),
              _LiteChip(icon: Icons.schedule_rounded, label: deadlineLabel),
              _LiteChip(
                  icon: Icons.access_time_rounded,
                  label: 'Status: ${data.status}'),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () async {
                final shouldRefresh = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FreelancerTaskDetailScreen(
                      task: _projectToAvailableTask(data),
                    ),
                  ),
                );
                if (shouldRefresh == true && context.mounted) {
                  context
                      .read<ProjectProvider>()
                      .fetchProjects(params: {'status': 'open'});
                }
              },
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Lihat Detail'),
            ),
          ),
        ],
      ),
    );
  }

  AvailableTask _projectToAvailableTask(ProjectModel project) {
    final minBudget = project.anggaranMin ?? 0;
    final maxBudget = project.anggaranMax ?? minBudget;
    return AvailableTask(
      id: project.id?.toString() ?? '',
      title: project.judul ?? 'Untitled',
      category: project.kategori?.namaKategori ?? 'Umum',
      description: project.deskripsi ?? '',
      initialBudget: maxBudget,
      deadlineLabel: project.deadline != null
          ? '${project.deadline!.difference(DateTime.now()).inDays} hari'
          : 'TBD',
      assistanceType: AssistanceType.online,
      clientName: project.client?.namaKontak ??
          project.client?.namaPerusahaan ??
          'Client',
      postedLabel: 'Terbaru',
      applicantsCount: project.offers?.length ?? project.bids?.length ?? 0,
      budgetRangeLabel:
          '${formatRupiah(minBudget)} - ${formatRupiah(maxBudget)}',
      location: project.client?.alamat ?? 'Online',
      attachmentName: project.attachmentFileName ?? project.attachmentFile,
      attachmentUrl: project.attachmentFileUrl,
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
