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
        title: const Text('Pembayaran'),
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
          const AppSectionTitle(
            title: 'Metode Pembayaran',
            subtitle: 'Nanti terhubung ke Midtrans.',
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
                  Icons.info_outline_rounded,
                  color: AuthFlowPalette.primary,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Saat backend siap, tombol bayar akan membuka Midtrans Snap.',
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
            label: const Text('Bayar via Midtrans'),
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
      nextTaskStatus: TaskStatus.paymentVerified,
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
                  'Pembayaran Diproses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AuthFlowPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Status akan diperbarui setelah Midtrans mengirim callback.',
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
