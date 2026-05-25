import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/user_role.dart';
import '../../models/workflow_results.dart';
import '../../services/mock_chat_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';
import '../client/client_payment_screen.dart';
import '../shared/chat_room_screen.dart';

class ClientOffersScreen extends StatelessWidget {
  final ClientTask task;

  const ClientOffersScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Penawaran'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TaskSummaryCard(task: task),
          const SizedBox(height: 16),
          ...task.offers.map(
            (offer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OfferCard(
                task: task,
                offer: offer,
              ),
            ),
          ),
          if (task.offers.isEmpty)
            const _InfoPanel(
              title: 'Belum ada penawaran',
              subtitle:
                  'Begitu volunteer mengajukan offer, daftar ini akan terisi otomatis.',
            ),
        ],
      ),
    );
  }
}

class _TaskSummaryCard extends StatelessWidget {
  final ClientTask task;

  const _TaskSummaryCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusBadge(
                label: taskStatusLabel(task.status),
                color: taskStatusColor(task.status),
              ),
              _MiniInfoChip(
                icon: Icons.sell_outlined,
                label: task.category,
              ),
              _MiniInfoChip(
                icon: Icons.wallet_outlined,
                label: formatRupiah(task.agreedBudget ?? task.initialBudget),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final ClientTask task;
  final VolunteerOffer offer;

  const _OfferCard({
    required this.task,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.freelancerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offer.freelancerSkill,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                label: offerStatusLabel(offer.status),
                color: offerStatusColor(offer.status),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MiniInfoChip(
                icon: Icons.star_rounded,
                label: '${offer.rating} (${offer.completedTasks} tugas)',
              ),
              _MiniInfoChip(
                icon: Icons.payments_outlined,
                label: formatRupiah(offer.offeredBudget),
              ),
              _MiniInfoChip(
                icon: Icons.schedule_outlined,
                label: offer.proposedDeadline,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            offer.message,
            style: const TextStyle(
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  final rooms = MockChatService().getClientRooms();
                  final matchedRooms =
                      rooms.where((item) => item.taskId == task.id).toList();
                  final room = matchedRooms.isNotEmpty
                      ? matchedRooms.first
                      : rooms.first;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomScreen(
                        room: room,
                        currentRole: UserRole.client,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: const Text('Chat'),
              ),
              ElevatedButton.icon(
                onPressed: offer.status == OfferStatus.rejected
                    ? null
                    : () async {
                        final result =
                            await Navigator.push<PaymentSubmissionResult>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClientPaymentScreen(
                              task: task,
                              selectedOffer: offer,
                            ),
                          ),
                        );
                        if (result != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Offer ${offer.freelancerName} diteruskan ke pembayaran. Status lanjut ke ${taskStatusLabel(result.nextTaskStatus)}.',
                              ),
                            ),
                          );
                        }
                      },
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: const Text('Terima'),
              ),
              OutlinedButton(
                onPressed: () => _showMessage(
                  context,
                  'Penawaran ${offer.freelancerName} ditandai sebagai ditolak.',
                ),
                child: const Text('Tolak'),
              ),
              TextButton(
                onPressed: () => _showMessage(
                  context,
                  'Tawar balik bisa dilanjutkan melalui chat.',
                ),
                child: const Text('Tawar Balik'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _MiniInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniInfoChip({
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
          Icon(icon, size: 16, color: const Color(0xFF2563EB)),
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

class _InfoPanel extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoPanel({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
