import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../services/mock_task_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/status_badge.dart';

class FreelancerProjectsScreen extends StatelessWidget {
  const FreelancerProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final applications = MockTaskService().getFreelancerApplications();

    return Scaffold(
      backgroundColor: AppUi.pageBackground,
      appBar: AppBar(title: const Text('Penawaran Saya')),
      body: ListView(
        padding: AppUi.pagePadding,
        children: applications
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ApplicationCard(item: item),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final FreelancerApplication item;

  const _ApplicationCard({required this.item});

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
                      item.taskTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AuthFlowPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.category,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(
                label: offerStatusLabel(item.status),
                color: offerStatusColor(item.status),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MiniChip(
                icon: Icons.payments_outlined,
                label: formatRupiah(item.offeredBudget),
              ),
              _MiniChip(
                icon: Icons.schedule_outlined,
                label: item.proposedDeadline,
              ),
              _MiniChip(
                icon: Icons.update_rounded,
                label: item.updatedAtLabel,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.note,
            style: const TextStyle(
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
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
