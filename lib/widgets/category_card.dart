import 'package:flutter/material.dart';

import 'app_ui.dart';
import 'auth_flow_widgets.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int price;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: AppCard(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AuthFlowPalette.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 24, color: AuthFlowPalette.primary),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AuthFlowPalette.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Start from \$$price',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: AuthFlowPalette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
