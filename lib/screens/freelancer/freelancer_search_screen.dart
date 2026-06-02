import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../models/task_models.dart';
import '../../providers/project_provider.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';
import 'freelancer_task_detail_screen.dart';

class FreelancerSearchScreen extends StatefulWidget {
  const FreelancerSearchScreen({super.key});

  @override
  State<FreelancerSearchScreen> createState() => _FreelancerSearchScreenState();
}

class _FreelancerSearchScreenState extends State<FreelancerSearchScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchProjects(params: {'status': 'open'});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Tugas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) {
                setState(() {});
              },
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
            child: Consumer<ProjectProvider>(
              builder: (context, projectProvider, _) {
                if (projectProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (projectProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: Color(0xFFDC2626),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Gagal memuat data',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          projectProvider.errorMessage ?? 'Terjadi kesalahan',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            projectProvider
                                .fetchProjects(params: {'status': 'open'});
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                final filteredProjects =
                    projectProvider.projects.where((project) {
                  final matchesSearch = _searchController.text.trim().isEmpty ||
                      (project.judul
                              ?.toLowerCase()
                              .contains(_searchController.text.toLowerCase()) ??
                          false) ||
                      (project.kategori?.namaKategori
                              ?.toLowerCase()
                              .contains(_searchController.text.toLowerCase()) ??
                          false);
                  final matchesCategory = _selectedCategory == null ||
                      project.kategori?.namaKategori == _selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredProjects.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada proyek yang tersedia',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Coba ubah filter atau cari kembali nanti.',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: filteredProjects
                      .map(
                        (project) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ProjectCard(project: project),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final projectProvider = context.read<ProjectProvider>();
    final allProjects = projectProvider.projects;
    final uniqueCategories = <String>{};
    for (var project in allProjects) {
      if (project.kategori?.namaKategori != null) {
        uniqueCategories.add(project.kategori!.namaKategori!);
      }
    }

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
                ...uniqueCategories.map(
                  (categoryName) => ChoiceChip(
                    label: Text(categoryName),
                    selected: _selectedCategory == categoryName,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = categoryName;
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

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _ProjectCard({required this.project});

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
                      project.judul ?? 'Untitled',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      project.deskripsi ?? '',
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
                label: project.kategori?.namaKategori ?? 'Umum',
                color: const Color(0xFF059669),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(
                icon: Icons.wallet_outlined,
                label:
                    '${formatRupiah(project.anggaranMin ?? 0)} - ${formatRupiah(project.anggaranMax ?? 0)}',
              ),
              _FilterChip(
                icon: Icons.schedule_rounded,
                label: project.deadline != null
                    ? '${project.deadline!.difference(DateTime.now()).inDays} hari'
                    : 'TBD',
              ),
              _FilterChip(
                icon: Icons.person_outline_rounded,
                label: project.client?.namaKontak ?? 'Client',
              ),
              _FilterChip(
                icon: Icons.location_on_outlined,
                label: project.client?.alamat ?? 'Online',
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Status: ${project.status ?? 'unknown'}',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () async {
                  final shouldRefresh = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FreelancerTaskDetailScreen(
                        task: _projectToAvailableTask(project),
                      ),
                    ),
                  );
                  if (shouldRefresh == true && context.mounted) {
                    context
                        .read<ProjectProvider>()
                        .fetchProjects(params: {'status': 'open'});
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(88, 44),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Detail'),
              ),
            ],
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
