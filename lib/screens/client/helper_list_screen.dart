import 'package:flutter/material.dart';

import '../../models/freelancer_model.dart';
import '../../services/freelancer_service.dart';
import '../../utils/task_ui_utils.dart';
import 'helper_detail_screen.dart';

class HelperListScreen extends StatefulWidget {
  const HelperListScreen({super.key});

  @override
  State<HelperListScreen> createState() => _HelperListScreenState();
}

class _HelperListScreenState extends State<HelperListScreen> {
  final _freelancerService = FreelancerService();
  final _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;
  List<FreelancerModel> _freelancers = const [];

  @override
  void initState() {
    super.initState();
    _loadFreelancers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFreelancers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final freelancers = await _freelancerService.getFreelancers();
      if (!mounted) return;
      setState(() {
        _freelancers = freelancers;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Data helper belum bisa dimuat dari server.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredFreelancers = _freelancers.where((freelancer) {
      return query.isEmpty ||
          freelancer.name.toLowerCase().contains(query) ||
          freelancer.skill.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Helper')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Cari helper berdasarkan nama atau skill...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const _HelperListState(
                    message: 'Memuat helper dari backend Laravel...',
                    showLoader: true,
                  )
                : _errorMessage != null
                    ? _HelperListState(
                        message: _errorMessage!,
                        icon: Icons.error_outline_rounded,
                        actionLabel: 'Coba Lagi',
                        onActionTap: _loadFreelancers,
                      )
                    : filteredFreelancers.isEmpty
                        ? const _HelperListState(
                            message: 'Belum ada helper yang cocok.',
                            icon: Icons.person_search_rounded,
                          )
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: filteredFreelancers
                                .map(
                                  (freelancer) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _HelperCard(freelancer: freelancer),
                                  ),
                                )
                                .toList(),
                          ),
          ),
        ],
      ),
    );
  }
}

class _HelperCard extends StatelessWidget {
  final FreelancerModel freelancer;

  const _HelperCard({required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HelperDetailScreen(freelancer: freelancer),
          ),
        );
      },
      child: Container(
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
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.person_rounded, color: Color(0xFF2563EB)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    freelancer.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    freelancer.skill,
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rating ${freelancer.rating == 0 ? 4.8 : freelancer.rating} • ${freelancer.completedProjects} proyek',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatRupiah(freelancer.baseRate),
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelperListState extends StatelessWidget {
  final String message;
  final bool showLoader;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const _HelperListState({
    required this.message,
    this.showLoader = false,
    this.icon = Icons.sync_rounded,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLoader)
              const CircularProgressIndicator()
            else
              Icon(icon, size: 42, color: const Color(0xFF2563EB)),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
            if (actionLabel != null && onActionTap != null) ...[
              const SizedBox(height: 10),
              TextButton(onPressed: onActionTap, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
