import 'package:flutter/material.dart';

import '../../models/user_role.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/auth_flow_widgets.dart';

class NotificationScreen extends StatelessWidget {
  final UserRole userRole;

  const NotificationScreen({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final items = userRole == UserRole.client
        ? const [
            _NotificationData(
              icon: Icons.local_offer_outlined,
              title: 'Penawaran baru masuk',
              message: 'Nadia mengirim penawaran untuk Poster Seminar.',
              time: '5 menit lalu',
              color: Color(0xFF059669),
            ),
            _NotificationData(
              icon: Icons.payments_outlined,
              title: 'Pembayaran menunggu',
              message: 'Selesaikan pembayaran Midtrans agar tugas dimulai.',
              time: 'Hari ini',
              color: Color(0xFFF59E0B),
            ),
            _NotificationData(
              icon: Icons.task_alt_outlined,
              title: 'Hasil siap direview',
              message: 'Edit Video Reels Event Kampus menunggu konfirmasi.',
              time: 'Kemarin',
              color: Color(0xFFEC4899),
            ),
          ]
        : const [
            _NotificationData(
              icon: Icons.assignment_outlined,
              title: 'Penawaran dilihat client',
              message: 'Penawaran kamu untuk Poster Seminar sedang diproses.',
              time: '8 menit lalu',
              color: Color(0xFF059669),
            ),
            _NotificationData(
              icon: Icons.work_outline_rounded,
              title: 'Deadline mendekat',
              message: 'Review PPT Sidang Proposal jatuh tempo hari ini.',
              time: 'Hari ini',
              color: Color(0xFFF59E0B),
            ),
            _NotificationData(
              icon: Icons.savings_outlined,
              title: 'Dana siap dicairkan',
              message: 'Pembayaran tugas selesai sudah masuk saldo.',
              time: 'Kemarin',
              color: Color(0xFF10B981),
            ),
          ];

    return Scaffold(
      backgroundColor: AppUi.pageBackground,
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: ListView(
        padding: AppUi.pagePadding,
        children: [
          const AppSectionTitle(
            title: 'Update Terbaru',
            subtitle: 'Status penting dari tugas, pembayaran, dan chat.',
          ),
          const SizedBox(height: 14),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _NotificationCard(data: item),
            ),
          ),
          const SizedBox(height: 4),
          const AppEmptyState(
            icon: Icons.cloud_sync_outlined,
            title: 'Siap tersambung Laravel',
            message:
                'Nanti notifikasi ini diisi dari API untuk offer, payment callback, chat, dan deadline.',
          ),
        ],
      ),
    );
  }
}

class _NotificationData {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final Color color;

  const _NotificationData({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.color,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationData data;

  const _NotificationCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: data.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: AuthFlowPalette.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.message,
                  style: const TextStyle(
                    color: AuthFlowPalette.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.time,
                  style: TextStyle(
                    color: data.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
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
