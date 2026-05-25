import 'package:flutter/material.dart';

import 'app_ui.dart';
import 'auth_flow_widgets.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool showCheckIcon;

  const ProfileSection({
    super.key,
    required this.title,
    required this.items,
    this.showCheckIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AuthFlowPalette.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: showCheckIcon
                  ? Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: AuthFlowPalette.textSecondary,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      item,
                      style: const TextStyle(
                        color: AuthFlowPalette.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
