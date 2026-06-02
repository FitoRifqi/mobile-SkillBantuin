import 'package:flutter/material.dart';

import '../../models/chat_models.dart';
import '../../models/offer_model.dart';
import '../../models/task_models.dart';
import '../../models/user_role.dart';
import '../../services/marketplace_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';
import '../shared/chat_room_screen.dart';

class FreelancerChatScreen extends StatefulWidget {
  const FreelancerChatScreen({super.key});

  @override
  State<FreelancerChatScreen> createState() => _FreelancerChatScreenState();
}

class _FreelancerChatScreenState extends State<FreelancerChatScreen> {
  final _marketplaceService = MarketplaceService();
  late Future<List<ChatRoom>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _roomsFuture = _loadRooms();
  }

  Future<List<ChatRoom>> _loadRooms() async {
    final offers = await _marketplaceService.fetchMyOffers();
    return offers
        .where((offer) => offer.projectId != null || offer.project?.id != null)
        .map(_roomFromOffer)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesan')),
      body: FutureBuilder<List<ChatRoom>>(
        future: _roomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
              ),
            );
          }

          final rooms = snapshot.data ?? const <ChatRoom>[];
          if (rooms.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada chat. Kirim penawaran dulu ke sebuah tugas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: rooms
                .map(
                  (room) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _FreelancerChatRoomTile(room: room),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  ChatRoom _roomFromOffer(OfferModel offer) {
    final project = offer.project;
    final projectId = offer.projectId ?? project?.id ?? 0;
    return ChatRoom(
      id: 'project-$projectId',
      taskId: projectId.toString(),
      taskTitle: project?.judul ?? 'Tugas #$projectId',
      counterpartName: project?.client?.namaKontak ??
          project?.client?.namaPerusahaan ??
          'Client',
      counterpartRoleLabel: 'Client',
      counterpartOnline: false,
      lastMessage: offer.message ?? 'Penawaran terkirim',
      lastMessageTime: offer.createdAt ?? '',
      unreadCount: 0,
      taskStatus: _taskStatusFromProject(project?.status),
      messages: const [],
    );
  }

  TaskStatus _taskStatusFromProject(String? status) {
    final normalized = status?.toLowerCase() ?? '';
    if (normalized.contains('progress')) return TaskStatus.onProgress;
    if (normalized.contains('completed')) return TaskStatus.completed;
    if (normalized.contains('cancel')) return TaskStatus.cancelled;
    return TaskStatus.waitingOffer;
  }
}

class _FreelancerChatRoomTile extends StatelessWidget {
  final ChatRoom room;

  const _FreelancerChatRoomTile({
    required this.room,
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
              currentRole: UserRole.freelancer,
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
                    Icons.business_center_rounded,
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
