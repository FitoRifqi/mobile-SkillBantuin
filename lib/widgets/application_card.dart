import 'package:flutter/material.dart';

import 'app_ui.dart';
import 'auth_flow_widgets.dart';
import 'status_badge.dart';

class ApplicationCard extends StatelessWidget {
  final String title;
  final String status;
  final String progressStatus;
  final int budget;
  final double progress;

  const ApplicationCard({
    super.key,
    required this.title,
    required this.status,
    required this.progressStatus,
    required this.budget,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = status == 'Diterima'
        ? const Color(0xFF10B981)
        : (status == 'Menunggu' ? const Color(0xFFF59E0B) : Colors.red);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AuthFlowPalette.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              StatusBadge(label: status, color: statusColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Budget: \$$budget',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF059669),
            ),
          ),
          if (progress > 0) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
                color: const Color(0xFF059669),
                minHeight: 6,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'Status: $progressStatus',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
