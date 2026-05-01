import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../services/mock_task_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/dashboard_widgets.dart';
import 'freelancer_projects_screen.dart';
import 'freelancer_search_screen.dart';
import 'freelancer_task_detail_screen.dart';
import 'freelancer_work_screen.dart';

class FreelancerHomeScreen extends StatelessWidget {
  const FreelancerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockTaskService();
    final tasks = service.getAvailableTasks();
    final applications = service.getFreelancerApplications();
    final works = service.getFreelancerWorks();
    final earnings = service.getEarningTransactions();

    return DashboardScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeroCard(
            greeting: 'Cari Tugas Freelancer',
            title: 'Temukan tugas yang cocok, kirim penawaran, lalu lanjut ke pekerjaan aktif.',
            description:
                'Beranda freelancer sekarang difokuskan untuk demo UAS: cari tugas, cek status penawaran, pantau pekerjaan, dan lihat progres pendapatan secara ringkas.',
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
                label: 'Penawaran',
                icon: Icons.assignment_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FreelancerProjectsScreen(),
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
          TextField(
            readOnly: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FreelancerSearchScreen(),
                ),
              );
            },
            decoration: InputDecoration(
              hintText: 'Cari tugas berdasarkan kategori, budget, atau deadline...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FreelancerSearchScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.tune_rounded),
              ),
            ),
          ),
          const SizedBox(height: 24),
          DashboardMetricGrid(
            metrics: [
              DashboardMetricData(
                label: 'Tugas Tersedia',
                value: tasks.length.toString().padLeft(2, '0'),
                helperText: 'Siap dilamar',
                icon: Icons.travel_explore_rounded,
                color: AuthFlowPalette.primary,
              ),
              DashboardMetricData(
                label: 'Penawaran Aktif',
                value: applications.where((item) => item.status == OfferStatus.pending || item.status == OfferStatus.countered).length.toString().padLeft(2, '0'),
                helperText: 'Perlu follow-up',
                icon: Icons.assignment_turned_in_rounded,
                color: const Color(0xFFF59E0B),
              ),
              DashboardMetricData(
                label: 'Pekerjaan Jalan',
                value: works.where((item) => item.status == WorkStatus.inProgress || item.status == WorkStatus.waitingConfirmation).length.toString().padLeft(2, '0'),
                helperText: 'Jaga deadline',
                icon: Icons.work_history_rounded,
                color: const Color(0xFF7C3AED),
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
          const DashboardSectionHeader(
            title: 'Progress Profil',
            subtitle: 'Semakin lengkap profilmu, semakin tinggi peluang dipilih klien.',
          ),
          const SizedBox(height: 14),
          const _ProfileStrengthCard(),
          const SizedBox(height: 28),
          DashboardSectionHeader(
            title: 'Tugas Rekomendasi',
            subtitle: 'Kurasi tugas yang paling relevan dengan skill dan kapasitasmu saat ini.',
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
          ...tasks.take(3).map((project) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RecommendedProjectCard(data: project),
              )),
          const SizedBox(height: 16),
          DashboardSectionHeader(
            title: 'Status Penawaran',
            subtitle: 'Supaya kamu tahu penawaran mana yang perlu direspon lebih dulu.',
            actionLabel: 'Lihat Semua',
            onActionTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FreelancerProjectsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          DashboardPanel(
            child: Column(
              children: applications
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.only(
                        bottom: item == applications.last ? 0 : 14,
                      ),
                      child: _PipelineTile(data: item),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          const DashboardSectionHeader(
            title: 'Agenda Terdekat',
            subtitle: 'Deadline dan follow-up yang perlu kamu jaga hari ini.',
          ),
          const SizedBox(height: 14),
          ...works.take(3).map((agenda) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AgendaCard(data: agenda),
              )),
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

class _ProfileStrengthCard extends StatelessWidget {
  const _ProfileStrengthCard();

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AuthFlowPalette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AuthFlowPalette.primary,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Strength 82%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AuthFlowPalette.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tambahkan 2 portofolio lagi dan verifikasi identitas untuk meningkatkan trust.',
                      style: TextStyle(
                        color: AuthFlowPalette.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.82,
              minHeight: 10,
              backgroundColor: Color(0xFFE2E8F0),
              color: AuthFlowPalette.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ChecklistChip(label: 'Portofolio visual', done: true),
              _ChecklistChip(label: 'Verifikasi identitas', done: false),
              _ChecklistChip(label: 'Headline profil', done: true),
              _ChecklistChip(label: 'Testimoni klien', done: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChecklistChip extends StatelessWidget {
  final String label;
  final bool done;

  const _ChecklistChip({
    required this.label,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    final color = done ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.error_outline_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
              _LiteChip(icon: Icons.flash_on_rounded, label: data.budgetRangeLabel),
              _LiteChip(icon: Icons.schedule_rounded, label: data.deadlineLabel),
              _LiteChip(icon: Icons.access_time_rounded, label: data.postedLabel),
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

class _PipelineTile extends StatelessWidget {
  final FreelancerApplication data;

  const _PipelineTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: offerStatusColor(data.status).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.flag_rounded, color: offerStatusColor(data.status)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    data.taskTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AuthFlowPalette.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: offerStatusColor(data.status).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      offerStatusLabel(data.status),
                      style: TextStyle(
                        color: offerStatusColor(data.status),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                data.note,
                style: const TextStyle(
                  color: AuthFlowPalette.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.updatedAtLabel,
                style: TextStyle(
                  color: offerStatusColor(data.status),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AgendaCard extends StatelessWidget {
  final FreelancerWorkItem data;

  const _AgendaCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 380;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: workStatusColor(data.status).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.work_outline_rounded, color: workStatusColor(data.status)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.taskTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AuthFlowPalette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.nextStep,
                          style: const TextStyle(
                            color: AuthFlowPalette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: compact ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  '${data.deadlineLabel} • ${formatRupiah(data.agreedBudget)}',
                  textAlign: compact ? TextAlign.left : TextAlign.right,
                  style: TextStyle(
                    color: workStatusColor(data.status),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
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
