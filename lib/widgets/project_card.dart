import 'package:flutter/material.dart';

import 'app_ui.dart';
import 'auth_flow_widgets.dart';
import 'status_badge.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String status;
  final double progress;
  final int budget;
  final String assignedTo;

  const ProjectCard({
    super.key,
    required this.title,
    required this.status,
    required this.progress,
    required this.budget,
    required this.assignedTo,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Sedang Berjalan':
        statusColor = const Color(0xFF059669);
        break;
      case 'Selesai':
        statusColor = const Color(0xFF10B981);
        break;
      case 'Dalam Review':
        statusColor = const Color(0xFFF59E0B);
        break;
      default:
        statusColor = Colors.grey;
    }

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AuthFlowPalette.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              StatusBadge(label: status, color: statusColor),
            ],
          ),
          const SizedBox(height: 12),
          if (progress > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 12,
                    color: AuthFlowPalette.textSecondary,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                color: AuthFlowPalette.primary,
                minHeight: 6,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget: \$$budget',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AuthFlowPalette.primary,
                ),
              ),
              Text(
                'Freelancer: $assignedTo',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
