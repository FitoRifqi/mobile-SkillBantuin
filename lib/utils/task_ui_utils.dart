import 'package:flutter/material.dart';

import '../models/task_models.dart';

String taskStatusLabel(TaskStatus status) {
  switch (status) {
    case TaskStatus.open:
      return 'Open';
    case TaskStatus.waitingOffer:
      return 'Menunggu Penawaran';
    case TaskStatus.negotiation:
      return 'Negosiasi';
    case TaskStatus.waitingPayment:
      return 'Menunggu Pembayaran';
    case TaskStatus.paymentVerified:
      return 'Pembayaran Terverifikasi';
    case TaskStatus.onProgress:
      return 'Sedang Dikerjakan';
    case TaskStatus.submitted:
      return 'Hasil Dikirim';
    case TaskStatus.completed:
      return 'Selesai';
    case TaskStatus.cancelled:
      return 'Batal';
    case TaskStatus.overdue:
      return 'Terlambat';
  }
}

Color taskStatusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.open:
    case TaskStatus.waitingOffer:
      return const Color(0xFF0EA5E9);
    case TaskStatus.negotiation:
      return const Color(0xFF7C3AED);
    case TaskStatus.waitingPayment:
      return const Color(0xFFF59E0B);
    case TaskStatus.paymentVerified:
    case TaskStatus.onProgress:
      return const Color(0xFF2563EB);
    case TaskStatus.submitted:
      return const Color(0xFFEC4899);
    case TaskStatus.completed:
      return const Color(0xFF10B981);
    case TaskStatus.cancelled:
      return const Color(0xFF6B7280);
    case TaskStatus.overdue:
      return const Color(0xFFDC2626);
  }
}

String offerStatusLabel(OfferStatus status) {
  switch (status) {
    case OfferStatus.pending:
      return 'Pending';
    case OfferStatus.accepted:
      return 'Diterima';
    case OfferStatus.rejected:
      return 'Ditolak';
    case OfferStatus.countered:
      return 'Ditawar Balik';
  }
}

Color offerStatusColor(OfferStatus status) {
  switch (status) {
    case OfferStatus.pending:
      return const Color(0xFFF59E0B);
    case OfferStatus.accepted:
      return const Color(0xFF10B981);
    case OfferStatus.rejected:
      return const Color(0xFFDC2626);
    case OfferStatus.countered:
      return const Color(0xFF7C3AED);
  }
}

String paymentStatusLabel(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.unpaid:
      return 'Belum Bayar';
    case PaymentStatus.pending:
      return 'Menunggu Verifikasi';
    case PaymentStatus.verified:
      return 'Terverifikasi';
    case PaymentStatus.failed:
      return 'Gagal';
    case PaymentStatus.refunded:
      return 'Refund';
  }
}

Color paymentStatusColor(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.unpaid:
      return const Color(0xFFF59E0B);
    case PaymentStatus.pending:
      return const Color(0xFF0EA5E9);
    case PaymentStatus.verified:
      return const Color(0xFF10B981);
    case PaymentStatus.failed:
      return const Color(0xFFDC2626);
    case PaymentStatus.refunded:
      return const Color(0xFF6B7280);
  }
}

String assistanceTypeLabel(AssistanceType type) {
  switch (type) {
    case AssistanceType.online:
      return 'Online';
    case AssistanceType.offline:
      return 'Offline';
  }
}

String workStatusLabel(WorkStatus status) {
  switch (status) {
    case WorkStatus.notStarted:
      return 'Belum Dikerjakan';
    case WorkStatus.inProgress:
      return 'Sedang Dikerjakan';
    case WorkStatus.waitingConfirmation:
      return 'Menunggu Konfirmasi';
    case WorkStatus.completed:
      return 'Selesai';
    case WorkStatus.overdue:
      return 'Terlambat';
  }
}

Color workStatusColor(WorkStatus status) {
  switch (status) {
    case WorkStatus.notStarted:
      return const Color(0xFF64748B);
    case WorkStatus.inProgress:
      return const Color(0xFF2563EB);
    case WorkStatus.waitingConfirmation:
      return const Color(0xFFF59E0B);
    case WorkStatus.completed:
      return const Color(0xFF10B981);
    case WorkStatus.overdue:
      return const Color(0xFFDC2626);
  }
}

String formatRupiah(int amount) {
  final raw = amount.toString();
  final buffer = StringBuffer();
  int counter = 0;

  for (int i = raw.length - 1; i >= 0; i--) {
    buffer.write(raw[i]);
    counter++;
    if (counter % 3 == 0 && i != 0) {
      buffer.write('.');
    }
  }

  return 'Rp${buffer.toString().split('').reversed.join()}';
}
