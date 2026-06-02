import 'package:flutter/material.dart';

import '../../models/offer_model.dart';
import '../../models/task_models.dart';
import '../../services/marketplace_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';

class FreelancerEarningsScreen extends StatefulWidget {
  const FreelancerEarningsScreen({super.key});

  @override
  State<FreelancerEarningsScreen> createState() =>
      _FreelancerEarningsScreenState();
}

class _FreelancerEarningsScreenState extends State<FreelancerEarningsScreen> {
  final MarketplaceService _marketplaceService = MarketplaceService();
  late Future<List<EarningTransaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _loadTransactions();
  }

  Future<List<EarningTransaction>> _loadTransactions() async {
    final offers = await _marketplaceService.fetchMyOffers();
    return offers
        .where((offer) => offer.status == 'accepted')
        .map(_earningFromOffer)
        .toList();
  }

  void _refresh() {
    setState(() {
      _transactionsFuture = _loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendapatan'),
      ),
      body: FutureBuilder<List<EarningTransaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Gagal memuat pendapatan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final transactions = snapshot.data ?? const <EarningTransaction>[];
          final total =
              transactions.fold<int>(0, (sum, item) => sum + item.amount);
          final verified = transactions
              .where((item) => item.status == PaymentStatus.verified)
              .fold<int>(0, (sum, item) => sum + item.amount);
          final pending = transactions
              .where((item) => item.status == PaymentStatus.pending)
              .fold<int>(0, (sum, item) => sum + item.amount);

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF047857)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ringkasan Pendapatan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        formatRupiah(total),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _summaryRow('Dibayar/selesai', formatRupiah(verified)),
                      _summaryRow('Menunggu selesai', formatRupiah(pending)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (transactions.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Belum ada pendapatan dari penawaran yang diterima.',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ),
                ...transactions.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.dateLabel,
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatRupiah(item.amount),
                                style: const TextStyle(
                                  color: Color(0xFF059669),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              StatusBadge(
                                label: paymentStatusLabel(item.status),
                                color: paymentStatusColor(item.status),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  EarningTransaction _earningFromOffer(OfferModel offer) {
    final projectStatus = offer.project?.status?.toLowerCase() ?? '';
    final status =
        projectStatus.contains('completed') || projectStatus.contains('done')
            ? PaymentStatus.verified
            : PaymentStatus.pending;

    return EarningTransaction(
      id: offer.id?.toString() ?? '',
      title: offer.project?.judul ?? offer.projectTitle ?? 'Proyek diterima',
      amount: offer.offeredBudget ?? offer.project?.anggaranMax ?? 0,
      status: status,
      dateLabel: offer.createdAt ?? '-',
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.78),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
