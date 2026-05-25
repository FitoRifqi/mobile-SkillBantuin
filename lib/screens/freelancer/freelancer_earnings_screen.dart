import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../services/mock_task_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';

class FreelancerEarningsScreen extends StatelessWidget {
  const FreelancerEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockTaskService();
    final transactions = service.getEarningTransactions();
    final total = transactions.fold<int>(0, (sum, item) => sum + item.amount);
    final verified = transactions
        .where((item) => item.status == PaymentStatus.verified)
        .fold<int>(0, (sum, item) => sum + item.amount);
    final pending = transactions
        .where((item) => item.status == PaymentStatus.pending)
        .fold<int>(0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendapatan'),
      ),
      body: ListView(
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
                _summaryRow('Berhasil', formatRupiah(verified)),
                _summaryRow('Pending', formatRupiah(pending)),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
