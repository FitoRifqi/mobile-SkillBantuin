import 'package:flutter/material.dart';

import '../../models/chat_models.dart';
import '../../models/task_models.dart';
import '../../models/user_role.dart';
import '../../models/workflow_results.dart';
import '../../services/marketplace_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';
import '../client/client_payment_screen.dart';
import '../shared/chat_room_screen.dart';

class ClientOffersScreen extends StatefulWidget {
  final ClientTask task;

  const ClientOffersScreen({
    super.key,
    required this.task,
  });

  @override
  State<ClientOffersScreen> createState() => _ClientOffersScreenState();
}

class _ClientOffersScreenState extends State<ClientOffersScreen> {
  final _marketplaceService = MarketplaceService();
  late Future<List<VolunteerOffer>> _offersFuture;

  @override
  void initState() {
    super.initState();
    _offersFuture = _loadOffers();
  }

  Future<List<VolunteerOffer>> _loadOffers() async {
    final offers =
        await _marketplaceService.fetchProjectVolunteerOffers(widget.task.id);
    return offers.isEmpty ? widget.task.offers : offers;
  }

  void _refreshOffers() {
    setState(() {
      _offersFuture = _loadOffers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Penawaran'),
      ),
      body: FutureBuilder<List<VolunteerOffer>>(
        future: _offersFuture,
        builder: (context, snapshot) {
          final offers = snapshot.data ?? widget.task.offers;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _TaskSummaryCard(task: widget.task),
              const SizedBox(height: 16),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (snapshot.hasError)
                _InfoPanel(
                  title: 'Gagal memuat penawaran',
                  subtitle: snapshot.error.toString(),
                ),
              ...offers.map(
                (offer) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OfferCard(
                    task: widget.task,
                    offer: offer,
                    onChanged: _refreshOffers,
                  ),
                ),
              ),
              if (!snapshot.hasError && offers.isEmpty)
                const _InfoPanel(
                  title: 'Belum ada penawaran',
                  subtitle: 'Penawaran freelancer akan muncul di sini.',
                ),
            ],
          );
        },
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
  final VoidCallback onChanged;
  final MarketplaceService _marketplaceService = MarketplaceService();

  _OfferCard({
    required this.task,
    required this.offer,
    required this.onChanged,
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
                  color: const Color(0xFF059669).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF059669),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomScreen(
                        room: ChatRoom(
                          id: 'project-${task.id}',
                          taskId: task.id,
                          taskTitle: task.title,
                          counterpartName: offer.freelancerName,
                          counterpartRoleLabel: 'Freelancer',
                          counterpartOnline: false,
                          lastMessage: offer.message,
                          lastMessageTime: offer.proposedDeadline,
                          unreadCount: 0,
                          taskStatus: task.status,
                          messages: const [],
                        ),
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
                        final canContinue =
                            offer.status == OfferStatus.accepted ||
                                await _runOfferAction(
                                  context,
                                  () =>
                                      _marketplaceService.acceptOffer(offer.id),
                                  'Penawaran ${offer.freelancerName} diterima.',
                                );
                        if (!canContinue) return;
                        if (!context.mounted) return;
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
                                'Menunggu pembayaran Midtrans untuk ${offer.freelancerName}.',
                              ),
                            ),
                          );
                        }
                      },
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: const Text('Terima & Bayar'),
              ),
              OutlinedButton(
                onPressed: () => _runOfferAction(
                  context,
                  () => _marketplaceService.rejectOffer(offer.id),
                  'Penawaran ${offer.freelancerName} ditolak.',
                ),
                child: const Text('Tolak'),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tawar balik lewat chat.')),
                  );
                },
                child: const Text('Tawar Balik'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _runOfferAction(
    BuildContext context,
    Future<void> Function() action,
    String message,
  ) async {
    try {
      await action();
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      onChanged();
      return true;
    } catch (error) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
      return false;
    }
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
