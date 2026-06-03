import 'package:flutter/material.dart';

import '../../models/offer_model.dart';
import '../../models/task_models.dart';
import '../../models/user_role.dart';
import '../../services/marketplace_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../../widgets/status_badge.dart';
import '../shared/notification_screen.dart';

class FreelancerProjectsScreen extends StatefulWidget {
  const FreelancerProjectsScreen({super.key});

  @override
  State<FreelancerProjectsScreen> createState() =>
      _FreelancerProjectsScreenState();
}

class _FreelancerProjectsScreenState extends State<FreelancerProjectsScreen> {
  final _marketplaceService = MarketplaceService();
  final _searchController = TextEditingController();
  late Future<List<OfferModel>> _offersFuture;

  @override
  void initState() {
    super.initState();
    _offersFuture = _marketplaceService.fetchMyOffers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();

    return Scaffold(
      backgroundColor: AppUi.pageBackground,
      appBar: AppBar(
        title: const Text('Penawaran Saya'),
        actions: [
          IconButton(
            tooltip: 'Notifikasi',
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(
                    userRole: UserRole.freelancer,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: AppUi.pagePadding,
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Cari penawaran, kategori, atau status...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<OfferModel>>(
            future: _offersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return AppCard(
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      color: AuthFlowPalette.textSecondary,
                      height: 1.5,
                    ),
                  ),
                );
              }

              final offers = (snapshot.data ?? const <OfferModel>[])
                  .where((item) => _matchesQuery(item, query))
                  .toList();

              if (offers.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.inbox_outlined,
                  title: 'Penawaran tidak ditemukan',
                  message: 'Coba ubah kata kunci pencarian.',
                );
              }

              return Column(
                children: offers
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ApplicationCard(
                          item: item,
                          onChanged: _refreshOffers,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _matchesQuery(OfferModel item, String query) {
    if (query.isEmpty) return true;
    final status = _offerStatusFromString(item.status);
    final values = [
      item.project?.judul,
      item.project?.kategori?.namaKategori,
      item.message,
      item.status,
      offerStatusLabel(status),
      item.proposedDeadlineDays != null
          ? '${item.proposedDeadlineDays} hari'
          : null,
    ].whereType<String>().map((value) => value.toLowerCase());
    return values.any((value) => value.contains(query));
  }

  void _refreshOffers() {
    setState(() {
      _offersFuture = _marketplaceService.fetchMyOffers();
    });
  }
}

class _ApplicationCard extends StatefulWidget {
  final OfferModel item;
  final VoidCallback onChanged;

  const _ApplicationCard({
    required this.item,
    required this.onChanged,
  });

  @override
  State<_ApplicationCard> createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<_ApplicationCard> {
  final _marketplaceService = MarketplaceService();
  bool _isProcessing = false;

  OfferModel get item => widget.item;

  @override
  Widget build(BuildContext context) {
    final offerStatus = _offerStatusFromString(item.status);
    final isCountered = offerStatus == OfferStatus.countered;
    final isCounterAccepted = offerStatus == OfferStatus.counterAccepted;

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.project?.judul ?? 'Tugas #${item.projectId ?? '-'}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AuthFlowPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.project?.kategori?.namaKategori ?? 'Kategori lain',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(
                label: offerStatusLabel(offerStatus),
                color: offerStatusColor(offerStatus),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MiniChip(
                icon: Icons.payments_outlined,
                label: formatRupiah(item.offeredBudget ?? 0),
              ),
              _MiniChip(
                icon: Icons.schedule_outlined,
                label: item.proposedDeadlineDays != null
                    ? '${item.proposedDeadlineDays} hari'
                    : 'Deadline belum tersedia',
              ),
              _MiniChip(
                icon: Icons.update_rounded,
                label: item.createdAt ?? 'Baru saja',
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.message ?? '-',
            style: const TextStyle(
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
          if (isCountered || isCounterAccepted) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCounterAccepted
                        ? 'Tawar Balik Sudah Disetujui'
                        : 'Client Menawar Balik',
                    style: const TextStyle(
                      color: Color(0xFF047857),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isCounterAccepted
                        ? 'Menunggu client menerima penawaran dan membayar via Midtrans.'
                        : 'Jika harga dan deadline ini cocok, setujui agar client bisa lanjut menerima dan membayar.',
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isCountered) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _acceptCounter,
                        icon: _isProcessing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.handshake_outlined, size: 18),
                        label: Text(
                          _isProcessing
                              ? 'Memproses...'
                              : 'Setujui Tawar Balik',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _acceptCounter() async {
    final offerId = item.id?.toString();
    if (offerId == null || offerId.isEmpty) return;

    setState(() => _isProcessing = true);
    try {
      await _marketplaceService.acceptCounterOffer(offerId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tawar balik disetujui. Menunggu client membayar.'),
        ),
      );
      widget.onChanged();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}

OfferStatus _offerStatusFromString(String? status) {
  switch (status) {
    case 'accepted':
      return OfferStatus.accepted;
    case 'rejected':
      return OfferStatus.rejected;
    case 'countered':
      return OfferStatus.countered;
    case 'counter_accepted':
      return OfferStatus.counterAccepted;
    case 'pending':
    default:
      return OfferStatus.pending;
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniChip({
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
