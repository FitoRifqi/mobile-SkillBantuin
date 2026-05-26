import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../models/workflow_results.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/auth_flow_widgets.dart';

class ClientPaymentScreen extends StatelessWidget {
  final ClientTask task;
  final VolunteerOffer? selectedOffer;

  const ClientPaymentScreen({
    super.key,
    required this.task,
    this.selectedOffer,
  });

  int get _totalPayment =>
      selectedOffer?.offeredBudget ?? task.agreedBudget ?? task.initialBudget;

  String get _freelancerName =>
      selectedOffer?.freelancerName ??
      task.assignedFreelancer ??
      'Belum dipilih';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUi.pageBackground,
      appBar: AppBar(
        title: const Text('Pembayaran Midtrans'),
      ),
      body: ListView(
        padding: AppUi.pagePadding,
        children: [
          _PaymentHero(
            taskTitle: task.title,
            freelancerName: _freelancerName,
            totalPayment: _totalPayment,
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan Pembayaran',
                  style: TextStyle(
                    color: AuthFlowPalette.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                _SummaryRow(label: 'Tugas', value: task.title),
                _SummaryRow(label: 'Freelancer', value: _freelancerName),
                const _SummaryRow(
                  label: 'Metode',
                  value: 'Midtrans Snap',
                ),
                _SummaryRow(
                  label: 'Status',
                  value: paymentStatusLabel(task.paymentStatus),
                ),
                _SummaryRow(
                  label: 'Total bayar',
                  value: formatRupiah(_totalPayment),
                  isTotal: true,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const AppSectionTitle(
            title: 'Metode Pembayaran',
            subtitle: 'Pilih metode di halaman aman Midtrans Snap.',
          ),
          const SizedBox(height: 10),
          const AppCard(
            child: Column(
              children: [
                _MidtransTile(
                  icon: Icons.qr_code_2_rounded,
                  title: 'QRIS',
                  subtitle: 'Bayar dengan semua aplikasi QRIS.',
                ),
                _MidtransTile(
                  icon: Icons.account_balance_rounded,
                  title: 'Virtual Account',
                  subtitle: 'BCA, BNI, BRI, Mandiri, dan bank lain.',
                ),
                _MidtransTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'E-Wallet',
                  subtitle: 'GoPay, ShopeePay, dan metode lain.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: AuthFlowPalette.primary,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Status pembayaran akan diperbarui otomatis setelah Midtrans mengirim notifikasi.',
                    style: TextStyle(
                      color: AuthFlowPalette.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _simulateMidtransPayment(context),
            icon: const Icon(Icons.lock_rounded, size: 18),
            label: const Text('Bayar Sekarang'),
          ),
        ],
      ),
    );
  }

  void _simulateMidtransPayment(BuildContext context) {
    final result = PaymentSubmissionResult(
      paymentMethod: 'Midtrans',
      proofFileName: 'midtrans-snap-pending',
      totalAmount: _totalPayment,
      paymentStatus: PaymentStatus.pending,
      nextTaskStatus: TaskStatus.waitingPayment,
    );

    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menunggu Pembayaran',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AuthFlowPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selesaikan pembayaran di Midtrans. Setelah berhasil, status tugas akan berubah otomatis.',
                  style: TextStyle(
                    color: AuthFlowPalette.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      Navigator.pop(context, result);
                    },
                    child: const Text('Mengerti'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PaymentHero extends StatelessWidget {
  final String taskTitle;
  final String freelancerName;
  final int totalPayment;

  const _PaymentHero({
    required this.taskTitle,
    required this.freelancerName,
    required this.totalPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AuthFlowPalette.backgroundGradient,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pembayaran aman via Midtrans',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            taskTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          _HeroRow(label: 'Freelancer', value: freelancerName),
          _HeroRow(label: 'Total', value: formatRupiah(totalPayment)),
        ],
      ),
    );
  }
}

class _HeroRow extends StatelessWidget {
  final String label;
  final String value;

  const _HeroRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.76),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isLast;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: const TextStyle(
                color: AuthFlowPalette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: isTotal
                    ? AuthFlowPalette.primary
                    : AuthFlowPalette.textPrimary,
                fontSize: isTotal ? 18 : 14,
                fontWeight: isTotal ? FontWeight.w900 : FontWeight.w800,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MidtransTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MidtransTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AuthFlowPalette.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AuthFlowPalette.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AuthFlowPalette.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AuthFlowPalette.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
