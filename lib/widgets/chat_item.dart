import 'package:flutter/material.dart';

import 'app_ui.dart';
import 'auth_flow_widgets.dart';

class ChatItem extends StatelessWidget {
  final String name;
  final String role;
  final String lastMessage;
  final String time;
  final bool isActive;
  final bool isClient;

  const ChatItem({
    super.key,
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.time,
    required this.isActive,
    this.isClient = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AuthFlowPalette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  isClient ? Icons.person : Icons.business,
                  color: AuthFlowPalette.primary,
                ),
              ),
              if (isActive)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AuthFlowPalette.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AuthFlowPalette.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  lastMessage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
