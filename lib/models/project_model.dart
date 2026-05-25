import 'task_models.dart';

class ProjectModel {
  final int id;
  final String title;
  final String categoryName;
  final String description;
  final int budget;
  final int? agreedBudget;
  final String deadlineLabel;
  final String createdAtLabel;
  final String status;
  final String paymentStatus;
  final AssistanceType assistanceType;
  final String location;
  final String clientName;
  final int applicantsCount;
  final String assignedFreelancer;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.categoryName,
    required this.description,
    required this.budget,
    required this.agreedBudget,
    required this.deadlineLabel,
    required this.createdAtLabel,
    required this.status,
    required this.paymentStatus,
    required this.assistanceType,
    required this.location,
    required this.clientName,
    required this.applicantsCount,
    required this.assignedFreelancer,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] ?? json['kategori'];
    final client = json['client'] ?? json['user'];
    final freelancer = json['freelancer'] ?? json['helper'];

    return ProjectModel(
      id: _parseInt(json['id']),
      title: _parseString(json['title'] ?? json['judul'] ?? json['name']),
      categoryName: _parseRelatedName(category).isEmpty
          ? _parseString(json['category_name'] ?? json['kategori_nama'])
          : _parseRelatedName(category),
      description: _parseString(
        json['description'] ?? json['deskripsi'] ?? json['detail'],
      ),
      budget:
          _parseInt(json['budget'] ?? json['initial_budget'] ?? json['reward']),
      agreedBudget:
          _parseNullableInt(json['agreed_budget'] ?? json['deal_budget']),
      deadlineLabel: _formatDateLabel(json['deadline'] ?? json['deadline_at']),
      createdAtLabel: _formatDateLabel(json['created_at'] ?? json['posted_at']),
      status: _parseString(json['status']).toLowerCase(),
      paymentStatus: _parseString(json['payment_status']).toLowerCase(),
      assistanceType: _parseAssistanceType(
        json['assistance_type'] ?? json['type'] ?? json['tipe_bantuan'],
      ),
      location: _parseString(json['location'] ?? json['lokasi']),
      clientName: _parseRelatedName(client).isEmpty
          ? _parseString(json['client_name'] ?? json['nama_client'])
          : _parseRelatedName(client),
      applicantsCount: _parseInt(
        json['applicants_count'] ??
            json['offers_count'] ??
            json['pelamar_count'],
      ),
      assignedFreelancer: _parseRelatedName(freelancer).isEmpty
          ? _parseString(json['freelancer_name'] ?? json['helper_name'])
          : _parseRelatedName(freelancer),
    );
  }

  ClientTask toClientTask() {
    return ClientTask(
      id: id.toString(),
      title: title,
      category: categoryName,
      description: description,
      initialBudget: budget,
      agreedBudget: agreedBudget,
      deadlineLabel: deadlineLabel,
      createdAtLabel: createdAtLabel,
      status: _toTaskStatus(status),
      paymentStatus: _toPaymentStatus(paymentStatus),
      assistanceType: assistanceType,
      nearestAction: _nearestAction(status),
      progress: _progressFromStatus(status),
      offers: const [],
      location: location.isEmpty ? null : location,
      assignedFreelancer:
          assignedFreelancer.isEmpty ? null : assignedFreelancer,
    );
  }

  AvailableTask toAvailableTask() {
    return AvailableTask(
      id: id.toString(),
      title: title,
      category: categoryName,
      description: description,
      initialBudget: budget,
      deadlineLabel: deadlineLabel,
      assistanceType: assistanceType,
      clientName: clientName.isEmpty ? 'Client SkillBantuin' : clientName,
      postedLabel: createdAtLabel.isEmpty ? 'Baru diposting' : createdAtLabel,
      applicantsCount: applicantsCount,
      budgetRangeLabel: budget > 0 ? 'Rp$budget' : 'Budget fleksibel',
      location: location.isEmpty ? 'Online' : location,
    );
  }

  static int _parseInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int? _parseNullableInt(Object? value) {
    if (value == null) return null;
    final parsed = _parseInt(value);
    return parsed == 0 ? null : parsed;
  }

  static String _parseString(Object? value) {
    return value?.toString() ?? '';
  }

  static String _parseRelatedName(Object? value) {
    if (value is Map<String, dynamic>) {
      return _parseString(value['name'] ?? value['title'] ?? value['nama']);
    }
    return '';
  }

  static String _formatDateLabel(Object? value) {
    final raw = _parseString(value);
    if (raw.isEmpty) return '';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return '${parsed.day}/${parsed.month}/${parsed.year}';
  }

  static AssistanceType _parseAssistanceType(Object? value) {
    final raw = _parseString(value).toLowerCase();
    return raw == 'offline' ? AssistanceType.offline : AssistanceType.online;
  }

  static TaskStatus _toTaskStatus(String value) {
    switch (value) {
      case 'waiting_offer':
      case 'waitingoffer':
      case 'open':
        return TaskStatus.waitingOffer;
      case 'negotiation':
        return TaskStatus.negotiation;
      case 'waiting_payment':
      case 'waitingpayment':
        return TaskStatus.waitingPayment;
      case 'payment_verified':
      case 'paymentverified':
        return TaskStatus.paymentVerified;
      case 'on_progress':
      case 'onprogress':
      case 'in_progress':
        return TaskStatus.onProgress;
      case 'submitted':
        return TaskStatus.submitted;
      case 'completed':
      case 'done':
        return TaskStatus.completed;
      case 'cancelled':
      case 'canceled':
        return TaskStatus.cancelled;
      case 'overdue':
        return TaskStatus.overdue;
      default:
        return TaskStatus.open;
    }
  }

  static PaymentStatus _toPaymentStatus(String value) {
    switch (value) {
      case 'pending':
        return PaymentStatus.pending;
      case 'verified':
      case 'paid':
        return PaymentStatus.verified;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.unpaid;
    }
  }

  static String _nearestAction(String value) {
    switch (value) {
      case 'waiting_payment':
      case 'waitingpayment':
        return 'Lanjutkan pembayaran agar pekerjaan bisa dimulai';
      case 'on_progress':
      case 'onprogress':
      case 'in_progress':
        return 'Pantau progres pengerjaan dari helper';
      case 'submitted':
        return 'Tinjau hasil yang sudah dikirim helper';
      case 'completed':
      case 'done':
        return 'Bantuan selesai dan siap direview';
      default:
        return 'Menunggu helper mengirim penawaran';
    }
  }

  static int _progressFromStatus(String value) {
    switch (value) {
      case 'waiting_payment':
      case 'waitingpayment':
        return 35;
      case 'on_progress':
      case 'onprogress':
      case 'in_progress':
        return 65;
      case 'submitted':
        return 90;
      case 'completed':
      case 'done':
        return 100;
      default:
        return 10;
    }
  }
}
