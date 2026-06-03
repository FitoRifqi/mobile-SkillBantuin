import 'package:flutter/material.dart';

import '../../models/offer_model.dart';
import '../../models/task_models.dart';
import '../../models/user_role.dart';
import '../../models/workflow_results.dart';
import '../../services/marketplace_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/status_badge.dart';
import '../shared/notification_screen.dart';
import 'freelancer_upload_result_screen.dart';

class FreelancerWorkScreen extends StatefulWidget {
  const FreelancerWorkScreen({super.key});

  @override
  State<FreelancerWorkScreen> createState() => _FreelancerWorkScreenState();
}

class _FreelancerWorkScreenState extends State<FreelancerWorkScreen> {
  final _marketplaceService = MarketplaceService();
  final _searchController = TextEditingController();
  WorkStatus? _selectedStatus;
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
      appBar: AppBar(
        title: const Text('Pekerjaan'),
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
        padding: const EdgeInsets.all(16),
        children: [
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari pekerjaan, client, atau status...',
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Semua'),
                      selected: _selectedStatus == null,
                      onSelected: (_) {
                        setState(() {
                          _selectedStatus = null;
                        });
                      },
                    ),
                    ...WorkStatus.values.map(
                      (status) => ChoiceChip(
                        label: Text(workStatusLabel(status)),
                        selected: _selectedStatus == status,
                        onSelected: (_) {
                          setState(() {
                            _selectedStatus = status;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
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
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                );
              }

              final works = (snapshot.data ?? const <OfferModel>[])
                  .where((offer) => offer.status == 'accepted')
                  .where((offer) => _matchesWork(offer, query))
                  .where((offer) =>
                      _selectedStatus == null ||
                      _workStatusFromOffer(offer) == _selectedStatus)
                  .toList();

              if (works.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.inbox_outlined,
                  title: 'Pekerjaan tidak ditemukan',
                  message:
                      'Pekerjaan aktif muncul setelah penawaran diterima dan pembayaran client selesai.',
                );
              }

              return Column(
                children: works
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _WorkCard(item: item),
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

  bool _matchesWork(OfferModel item, String query) {
    if (query.isEmpty) return true;
    final values = [
      item.project?.judul,
      item.project?.client?.namaKontak,
      item.project?.client?.namaPerusahaan,
      item.project?.status,
      item.message,
      workStatusLabel(_workStatusFromOffer(item)),
    ].whereType<String>().map((value) => value.toLowerCase());
    return values.any((value) => value.contains(query));
  }
}

class _WorkCard extends StatelessWidget {
  final OfferModel item;

  const _WorkCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final workStatus = _workStatusFromOffer(item);
    final canUpload = workStatus == WorkStatus.inProgress ||
        workStatus == WorkStatus.overdue;
    final isWaitingPayment = _isWaitingPayment(item);

    return Container(
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
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Client: ${item.project?.client?.namaKontak ?? item.project?.client?.namaPerusahaan ?? 'Client'}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(
                label: isWaitingPayment
                    ? 'Menunggu Pembayaran'
                    : workStatusLabel(workStatus),
                color: isWaitingPayment
                    ? const Color(0xFFF59E0B)
                    : workStatusColor(workStatus),
              ),
            ],
          ),
          if (canUpload) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.play_circle_fill_rounded,
                    color: Color(0xFF059669),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pembayaran sudah diterima. Kamu bisa mulai mengerjakan tugas ini.',
                      style: TextStyle(
                        color: Color(0xFF047857),
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Text(
            _nextStepFromOffer(item),
            style: const TextStyle(
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Budget ${formatRupiah(item.offeredBudget ?? 0)}',
                  style: const TextStyle(
                    color: Color(0xFF059669),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'Deadline ${_deadlineLabel(item)}',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: _progressFromOffer(item) / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E8F0),
              color: workStatusColor(_workStatusFromOffer(item)),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: canUpload
                  ? () async {
                      final result =
                          await Navigator.push<WorkSubmissionResult>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FreelancerUploadResultScreen(
                            item: _toWorkItem(item),
                          ),
                        ),
                      );
                      if (result != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Hasil dikirim. Menunggu review client.',
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              icon: Icon(
                canUpload
                    ? Icons.upload_file_rounded
                    : Icons.hourglass_top_rounded,
                size: 18,
              ),
              label: Text(
                canUpload
                    ? 'Upload Hasil'
                    : isWaitingPayment
                        ? 'Menunggu Pembayaran'
                        : 'Belum Bisa Upload',
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isWaitingPayment(OfferModel item) {
    final status = item.project?.status?.toLowerCase();
    return item.status == 'accepted' &&
        status != 'in_progress' &&
        status != 'completed';
  }

  String _deadlineLabel(OfferModel item) {
    final deadline = item.project?.deadline;
    if (deadline == null) return 'TBD';
    final days = deadline.difference(DateTime.now()).inDays;
    return days >= 0 ? '$days hari' : 'Lewat ${days.abs()} hari';
  }

  String _nextStepFromOffer(OfferModel item) {
    if (_isWaitingPayment(item)) {
      return 'Penawaran diterima. Menunggu client menyelesaikan pembayaran sebelum tugas bisa dikerjakan.';
    }

    final status = _workStatusFromOffer(item);
    switch (status) {
      case WorkStatus.notStarted:
        return 'Penawaran diterima. Mulai kerjakan sesuai brief client.';
      case WorkStatus.inProgress:
        return 'Kerjakan tugas dan upload hasil saat sudah siap.';
      case WorkStatus.waitingConfirmation:
        return 'Hasil dikirim. Menunggu konfirmasi client.';
      case WorkStatus.completed:
        return 'Pekerjaan selesai.';
      case WorkStatus.overdue:
        return 'Deadline terlewat. Segera koordinasi dengan client.';
    }
  }

  FreelancerWorkItem _toWorkItem(OfferModel item) {
    return FreelancerWorkItem(
      id: item.projectId?.toString() ?? item.project?.id?.toString() ?? '',
      taskTitle: item.project?.judul ?? 'Tugas #${item.projectId ?? '-'}',
      clientName: item.project?.client?.namaKontak ??
          item.project?.client?.namaPerusahaan ??
          'Client',
      deadlineLabel: _deadlineLabel(item),
      agreedBudget: item.offeredBudget ?? 0,
      progress: _progressFromOffer(item),
      status: _workStatusFromOffer(item),
      nextStep: _nextStepFromOffer(item),
    );
  }
}

WorkStatus _workStatusFromOffer(OfferModel item) {
  final projectStatus = item.project?.status?.toLowerCase();
  if (projectStatus == 'completed') {
    return WorkStatus.completed;
  }

  if (projectStatus != 'in_progress' && projectStatus != 'completed') {
    return WorkStatus.notStarted;
  }

  final deadline = item.project?.deadline;
  if (deadline != null && deadline.isBefore(DateTime.now())) {
    return WorkStatus.overdue;
  }

  switch (projectStatus) {
    case 'in_progress':
      return WorkStatus.inProgress;
    default:
      return WorkStatus.notStarted;
  }
}

int _progressFromOffer(OfferModel item) {
  switch (_workStatusFromOffer(item)) {
    case WorkStatus.notStarted:
      return 10;
    case WorkStatus.inProgress:
      return 50;
    case WorkStatus.waitingConfirmation:
      return 80;
    case WorkStatus.completed:
      return 100;
    case WorkStatus.overdue:
      return 35;
  }
}
