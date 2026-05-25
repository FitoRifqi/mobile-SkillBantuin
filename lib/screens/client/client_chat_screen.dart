import 'package:flutter/material.dart';

import '../../models/chat_models.dart';
import '../../models/user_role.dart';
import '../../services/mock_chat_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';
import '../shared/chat_room_screen.dart';

class ClientChatScreen extends StatelessWidget {
  const ClientChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = MockChatService().getClientRooms();

    return Scaffold(
      appBar: AppBar(title: const Text('Pesan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: rooms
            .map(
              (room) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChatRoomTile(
                  room: room,
                  currentRole: UserRole.client,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  final ChatRoom room;
  final UserRole currentRole;

  const _ChatRoomTile({
    required this.room,
    required this.currentRole,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatRoomScreen(
              room: room,
              currentRole: currentRole,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor:
                      const Color(0xFF059669).withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFF059669),
                  ),
                ),
                if (room.counterpartOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.counterpartName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Text(
                        room.lastMessageTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.taskTitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      StatusBadge(
                        label: taskStatusLabel(room.taskStatus),
                        color: taskStatusColor(room.taskStatus),
                      ),
                      const Spacer(),
                      if (room.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            room.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
