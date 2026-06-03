import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _OfferCard extends StatefulWidget {
  final ClientTask task;
  final VolunteerOffer offer;
  final VoidCallback onChanged;

  const _OfferCard({
    required this.task,
    required this.offer,
    required this.onChanged,
  });

  @override
  State<_OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<_OfferCard> {
  final MarketplaceService _marketplaceService = MarketplaceService();
  bool _isProcessing = false;

  ClientTask get task => widget.task;
  VolunteerOffer get offer => widget.offer;
  VoidCallback get onChanged => widget.onChanged;

  @override
  Widget build(BuildContext context) {
    final isWaitingFreelancerApproval = offer.status == OfferStatus.countered;
    final canAcceptAndPay = offer.status == OfferStatus.pending ||
        offer.status == OfferStatus.accepted ||
        offer.status == OfferStatus.counterAccepted;
    final isActionDisabled = _isProcessing || !canAcceptAndPay;

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
                onPressed: isActionDisabled
                    ? null
                    : () async {
                        setState(() => _isProcessing = true);
                        final canContinue =
                            offer.status == OfferStatus.accepted ||
                                await _runOfferAction(
                                  context,
                                  () =>
                                      _marketplaceService.acceptOffer(offer.id),
                                  'Penawaran ${offer.freelancerName} diterima.',
                                );
                        if (mounted) {
                          setState(() => _isProcessing = false);
                        }
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
                icon: _isProcessing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: Text(
                  _isProcessing
                      ? 'Memproses...'
                      : isWaitingFreelancerApproval
                          ? 'Menunggu Freelancer'
                          : 'Terima & Bayar',
                ),
              ),
              OutlinedButton(
                onPressed: _isProcessing ||
                        !(offer.status == OfferStatus.pending ||
                            offer.status == OfferStatus.countered ||
                            offer.status == OfferStatus.counterAccepted)
                    ? null
                    : () async {
                        setState(() => _isProcessing = true);
                        await _runOfferAction(
                          context,
                          () => _marketplaceService.rejectOffer(offer.id),
                          'Penawaran ${offer.freelancerName} ditolak.',
                        );
                        if (mounted) {
                          setState(() => _isProcessing = false);
                        }
                      },
                child: const Text('Tolak'),
              ),
              TextButton(
                onPressed: _isProcessing ||
                        !(offer.status == OfferStatus.pending ||
                            offer.status == OfferStatus.countered)
                    ? null
                    : () => _showCounterOfferDialog(context),
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

  Future<void> _showCounterOfferDialog(BuildContext context) async {
    final result = await showDialog<_CounterOfferPayload>(
      context: context,
      builder: (_) => _CounterOfferDialog(
        initialBudget: offer.offeredBudget,
        initialDeadlineDays: _deadlineDaysFromLabel(offer.proposedDeadline),
      ),
    );

    if (result == null || !context.mounted) return;

    setState(() => _isProcessing = true);
    await _runOfferAction(
      context,
      () => _marketplaceService.counterOffer(
        offerId: offer.id,
        offeredBudget: result.offeredBudget,
        proposedDeadlineDays: result.proposedDeadlineDays,
        message: result.message,
      ),
      'Tawar balik berhasil dikirim ke ${offer.freelancerName}.',
    );
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  int _deadlineDaysFromLabel(String label) {
    final match = RegExp(r'\d+').firstMatch(label);
    return int.tryParse(match?.group(0) ?? '') ?? 1;
  }
}

class _CounterOfferPayload {
  final int offeredBudget;
  final int proposedDeadlineDays;
  final String message;

  const _CounterOfferPayload({
    required this.offeredBudget,
    required this.proposedDeadlineDays,
    required this.message,
  });
}

class _CounterOfferDialog extends StatefulWidget {
  final int initialBudget;
  final int initialDeadlineDays;

  const _CounterOfferDialog({
    required this.initialBudget,
    required this.initialDeadlineDays,
  });

  @override
  State<_CounterOfferDialog> createState() => _CounterOfferDialogState();
}

class _CounterOfferDialogState extends State<_CounterOfferDialog> {
  late final TextEditingController _budgetController;
  late final TextEditingController _deadlineController;
  late final TextEditingController _messageController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _budgetController =
        TextEditingController(text: widget.initialBudget.toString());
    _deadlineController =
        TextEditingController(text: widget.initialDeadlineDays.toString());
    _messageController = TextEditingController(
      text: 'Saya tawar di ${formatRupiah(widget.initialBudget)}.',
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _deadlineController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tawar Balik'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Harga tawaran',
                prefixText: 'Rp ',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _deadlineController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Estimasi deadline',
                suffixText: 'hari',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Catatan untuk freelancer',
              ),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _errorText!,
                  style: const TextStyle(
                    color: Color(0xFFDC2626),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Kirim'),
        ),
      ],
    );
  }

  void _submit() {
    final budget = int.tryParse(_budgetController.text.trim()) ?? 0;
    final deadline = int.tryParse(_deadlineController.text.trim()) ?? 0;
    final message = _messageController.text.trim();

    if (budget < 1000 || deadline < 1 || message.isEmpty) {
      setState(() {
        _errorText = 'Isi harga, deadline, dan catatan dulu.';
      });
      return;
    }

    Navigator.pop(
      context,
      _CounterOfferPayload(
        offeredBudget: budget,
        proposedDeadlineDays: deadline,
        message: message,
      ),
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
