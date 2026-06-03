import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../models/task_models.dart';
import '../../models/user_role.dart';
import '../../providers/project_provider.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/status_badge.dart';
import '../shared/notification_screen.dart';
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
  final _searchController = TextEditingController();
  TaskStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchMyProjects();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesSelectedStatus(ProjectModel project) {
    if (_selectedStatus == null) return true;
    final normalized = project.status?.toLowerCase() ?? '';

    switch (_selectedStatus!) {
      case TaskStatus.open:
      case TaskStatus.waitingOffer:
        return normalized.contains('open') || normalized.contains('waiting');
      case TaskStatus.negotiation:
        return normalized.contains('negotiation');
      case TaskStatus.waitingPayment:
        return normalized.contains('waiting payment') ||
            normalized.contains('payment');
      case TaskStatus.paymentVerified:
        return normalized.contains('verified') ||
            normalized.contains('payment');
      case TaskStatus.onProgress:
        return normalized.contains('progress');
      case TaskStatus.submitted:
        return normalized.contains('submitted');
      case TaskStatus.completed:
        return normalized.contains('completed') || normalized.contains('done');
      case TaskStatus.cancelled:
        return normalized.contains('cancel');
      case TaskStatus.overdue:
        return normalized.contains('overdue');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        final query = _searchController.text.trim().toLowerCase();
        final filteredProjects = provider.projects.where((project) {
          final matchesStatus = _matchesSelectedStatus(project);
          final matchesSearch = query.isEmpty ||
              (project.judul?.toLowerCase().contains(query) ?? false) ||
              (project.deskripsi?.toLowerCase().contains(query) ?? false) ||
              (project.kategori?.namaKategori?.toLowerCase().contains(query) ??
                  false) ||
              _ActivityProjectCard._projectNearestAction(project.status)
                  .toLowerCase()
                  .contains(query) ||
              _ActivityProjectCard._projectStatusLabel(project.status)
                  .toLowerCase()
                  .contains(query);
          return matchesStatus && matchesSearch;
        }).toList();

        return Scaffold(
          backgroundColor: AppUi.pageBackground,
          appBar: AppBar(
            title: const Text('Aktivitas Client'),
            actions: [
              IconButton(
                tooltip: 'Notifikasi',
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const NotificationScreen(userRole: UserRole.client),
                    ),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: AppUi.pagePadding,
            children: [
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText:
                            'Cari aktivitas, kategori, atau freelancer...',
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
                    const SizedBox(height: 18),
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
              if (provider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (provider.errorMessage != null)
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gagal memuat proyek: ${provider.errorMessage}',
                        style: const TextStyle(
                          color: AuthFlowPalette.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          provider.fetchMyProjects();
                        },
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                )
              else if (filteredProjects.isEmpty)
                const AppEmptyState(
                  icon: Icons.inbox_outlined,
                  title: 'Aktivitas tidak ditemukan',
                  message:
                      'Ubah kata kunci atau filter status untuk melihat lainnya.',
                )
              else
                ...filteredProjects.map(
                  (project) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ActivityProjectCard(project: project),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivityProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _ActivityProjectCard({required this.project});

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
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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
              _MiniChip(
                icon: Icons.sell_outlined,
                label: project.kategori?.namaKategori ?? 'Kategori lain',
              ),
              _MiniChip(
                icon: Icons.schedule_rounded,
                label: _projectDeadlineLabel(project.deadline),
              ),
              _MiniChip(
                icon: Icons.wallet_outlined,
                label: _projectBudgetLabel(project),
              ),
              _MiniChip(
                icon: Icons.person_outline_rounded,
                label: project.offers?.isNotEmpty == true
                    ? project.offers!.first.freelancer?.namaLengkap ??
                        'Freelancer terdaftar'
                    : 'Belum ada freelancer',
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
                        builder: (_) => ClientTaskDetailScreen(
                          task: _projectToClientTask(project),
                        ),
                      ),
                    );
                  },
                  child: const Text('Detail'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final task = _projectToClientTask(project);
                    if (task.status == TaskStatus.waitingPayment) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClientPaymentScreen(task: task),
                        ),
                      );
                      return;
                    }

                    if (task.status == TaskStatus.completed ||
                        task.status == TaskStatus.submitted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClientReviewScreen(task: task),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientTaskDetailScreen(task: task),
                      ),
                    );
                  },
                  child: Text(_primaryActionLabel(project.status)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _primaryActionLabel(String? status) {
    final mapped = _projectStatusToTaskStatus(status);
    if (mapped == TaskStatus.waitingPayment) return 'Bayar Sekarang';
    if (mapped == TaskStatus.paymentVerified ||
        mapped == TaskStatus.onProgress) {
      return 'Menunggu Hasil';
    }
    if (mapped == TaskStatus.completed || mapped == TaskStatus.submitted) {
      return 'Review';
    }
    return 'Lanjut';
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
    if (normalized.contains('payment')) {
      if (normalized.contains('verified') ||
          normalized.contains('success') ||
          normalized.contains('paid')) {
        return 'Pembayaran berhasil. Menunggu hasil dari freelancer';
      }
      return 'Selesaikan pembayaran untuk memulai';
    }
    if (normalized.contains('progress')) {
      return 'Pembayaran berhasil. Menunggu hasil dari freelancer';
    }
    if (normalized.contains('negotiation')) {
      return 'Negosiasi penawaran freelancer';
    }
    if (normalized.contains('open') || normalized.contains('waiting')) {
      return 'Menunggu freelancer mengajukan penawaran';
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
      agreedBudget: project.agreedBudget,
      deadlineLabel: _projectDeadlineLabel(deadline),
      createdAtLabel: 'Baru saja',
      status: mappedStatus,
      paymentStatus: _paymentStatusFromTaskStatus(mappedStatus),
      assistanceType: AssistanceType.online,
      nearestAction: _projectNearestAction(project.status),
      progress: mappedStatus == TaskStatus.onProgress ? 50 : 20,
      offers: const [],
      attachmentName: project.attachmentFileName ?? project.attachmentFile,
      resultFileName: project.resultFileName ?? project.resultFile,
      resultFileUrl: project.resultFileUrl,
      resultLink: project.resultLink,
      resultNote: project.resultNote,
      resultSubmittedAt: project.resultSubmittedAt,
      assignedFreelancer: project.offers?.isNotEmpty == true
          ? project.offers!.first.freelancer?.namaLengkap
          : null,
    );
  }

  static PaymentStatus _paymentStatusFromTaskStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.waitingPayment:
        return PaymentStatus.pending;
      case TaskStatus.paymentVerified:
      case TaskStatus.onProgress:
      case TaskStatus.submitted:
      case TaskStatus.completed:
        return PaymentStatus.verified;
      case TaskStatus.cancelled:
        return PaymentStatus.failed;
      case TaskStatus.open:
      case TaskStatus.waitingOffer:
      case TaskStatus.negotiation:
      case TaskStatus.overdue:
        return PaymentStatus.unpaid;
    }
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
