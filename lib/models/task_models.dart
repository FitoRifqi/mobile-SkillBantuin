enum TaskStatus {
  open,
  waitingOffer,
  negotiation,
  waitingPayment,
  paymentVerified,
  onProgress,
  submitted,
  completed,
  cancelled,
  overdue,
}

enum OfferStatus {
  pending,
  accepted,
  rejected,
  countered,
  counterAccepted,
}

enum WorkStatus {
  notStarted,
  inProgress,
  waitingConfirmation,
  completed,
  overdue,
}

enum PaymentStatus {
  unpaid,
  pending,
  verified,
  failed,
  refunded,
}

enum AssistanceType {
  online,
  offline,
}

Map<String, dynamic> _asMap(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return <String, dynamic>{};
}

String _stringValue(Map<String, dynamic> data, List<String> keys,
    [String defaultValue = '']) {
  for (final key in keys) {
    if (data.containsKey(key) && data[key] != null) {
      if (data[key] is Map) continue;
      return data[key].toString();
    }
  }
  return defaultValue;
}

int _intValue(Map<String, dynamic> data, List<String> keys,
    [int defaultValue = 0]) {
  final raw = _stringValue(data, keys);
  return int.tryParse(raw) ?? defaultValue;
}

double _doubleValue(Map<String, dynamic> data, List<String> keys,
    [double defaultValue = 0]) {
  final raw = _stringValue(data, keys);
  return double.tryParse(raw) ?? defaultValue;
}

T _enumValue<T>(Map<String, dynamic> data, List<String> keys, List<T> values,
    String Function(T) name, T defaultValue) {
  final raw = _stringValue(data, keys).toLowerCase().replaceAll('_', '');
  for (final value in values) {
    if (name(value).toLowerCase().replaceAll('_', '') == raw) {
      return value;
    }
  }
  return defaultValue;
}

class VolunteerOffer {
  final String id;
  final String freelancerName;
  final String freelancerSkill;
  final double rating;
  final int completedTasks;
  final int offeredBudget;
  final String proposedDeadline;
  final String message;
  final OfferStatus status;

  const VolunteerOffer({
    required this.id,
    required this.freelancerName,
    required this.freelancerSkill,
    required this.rating,
    required this.completedTasks,
    required this.offeredBudget,
    required this.proposedDeadline,
    required this.message,
    required this.status,
  });

  factory VolunteerOffer.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json);
    return VolunteerOffer(
      id: _stringValue(data, ['id', 'offerId', 'offer_id']),
      freelancerName: _stringValue(
          data, ['freelancerName', 'freelancer_name', 'name', 'freelancer']),
      freelancerSkill:
          _stringValue(data, ['freelancerSkill', 'freelancer_skill', 'skill']),
      rating: _doubleValue(data, ['rating', 'rate']),
      completedTasks: _intValue(data, ['completedTasks', 'completed_tasks']),
      offeredBudget:
          _intValue(data, ['offeredBudget', 'offered_budget', 'budget']),
      proposedDeadline: _stringValue(
        data,
        ['proposedDeadline', 'proposed_deadline', 'deadline'],
        data['proposed_deadline_days'] != null
            ? '${data['proposed_deadline_days']} hari'
            : '',
      ),
      message: _stringValue(data, ['message', 'note', 'description']),
      status: _enumValue<OfferStatus>(
        data,
        ['status'],
        OfferStatus.values,
        (value) => value.name,
        OfferStatus.pending,
      ),
    );
  }
}

class ClientTask {
  final String id;
  final String title;
  final String category;
  final String description;
  final int initialBudget;
  final int? agreedBudget;
  final String deadlineLabel;
  final String createdAtLabel;
  final TaskStatus status;
  final PaymentStatus paymentStatus;
  final AssistanceType assistanceType;
  final String? location;
  final String? attachmentName;
  final String? resultFileName;
  final String? resultFileUrl;
  final String? resultLink;
  final String? resultNote;
  final String? resultSubmittedAt;
  final int? reviewRating;
  final String? reviewComment;
  final String? reviewedAt;
  final String nearestAction;
  final int progress;
  final String? assignedFreelancer;
  final List<VolunteerOffer> offers;

  const ClientTask({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.initialBudget,
    required this.deadlineLabel,
    required this.createdAtLabel,
    required this.status,
    required this.paymentStatus,
    required this.assistanceType,
    required this.nearestAction,
    required this.progress,
    required this.offers,
    this.agreedBudget,
    this.location,
    this.attachmentName,
    this.resultFileName,
    this.resultFileUrl,
    this.resultLink,
    this.resultNote,
    this.resultSubmittedAt,
    this.reviewRating,
    this.reviewComment,
    this.reviewedAt,
    this.assignedFreelancer,
  });

  factory ClientTask.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json);
    final offersRaw = data['offers'];
    final offers = <VolunteerOffer>[];
    if (offersRaw is List) {
      offers.addAll(
        offersRaw
            .whereType<Map<String, dynamic>>()
            .map(VolunteerOffer.fromJson),
      );
    }

    return ClientTask(
      id: _stringValue(data, ['id', 'taskId', 'task_id']),
      title: _stringValue(data, ['title', 'name', 'judul']),
      category: _stringValue(
          data,
          ['category', 'taskCategory', 'task_category'],
          _stringValue(
              _asMap(data['kategori']), ['nama_kategori', 'name'], 'Umum')),
      description: _stringValue(
          data, ['description', 'detail', 'task_description', 'deskripsi']),
      initialBudget: _intValue(
          data, ['initialBudget', 'initial_budget', 'budget', 'anggaran_max']),
      agreedBudget: _intValue(data,
          ['agreedBudget', 'agreed_budget', 'finalBudget', 'anggaran_max']),
      deadlineLabel:
          _stringValue(data, ['deadlineLabel', 'deadline_label', 'deadline']),
      createdAtLabel: _stringValue(data,
          ['createdAtLabel', 'created_at_label', 'createdAt', 'created_at']),
      status: _enumValue<TaskStatus>(
        data,
        ['status'],
        TaskStatus.values,
        (value) => value.name,
        TaskStatus.open,
      ),
      paymentStatus: _enumValue<PaymentStatus>(
        data,
        ['paymentStatus', 'payment_status'],
        PaymentStatus.values,
        (value) => value.name,
        PaymentStatus.unpaid,
      ),
      assistanceType: _enumValue<AssistanceType>(
        data,
        ['assistanceType', 'assistance_type'],
        AssistanceType.values,
        (value) => value.name,
        AssistanceType.online,
      ),
      location: _stringValue(data, ['location', 'place']),
      attachmentName: _stringValue(
          data, ['attachmentName', 'attachment_name', 'attachment']),
      resultFileName: _stringValue(
          data, ['resultFileName', 'result_file_name', 'result_file']),
      resultFileUrl: _stringValue(data, ['resultFileUrl', 'result_file_url']),
      resultLink: _stringValue(data, ['resultLink', 'result_link']),
      resultNote: _stringValue(data, ['resultNote', 'result_note']),
      resultSubmittedAt:
          _stringValue(data, ['resultSubmittedAt', 'result_submitted_at']),
      reviewRating: _intValue(data, ['reviewRating', 'review_rating']),
      reviewComment: _stringValue(data, ['reviewComment', 'review_comment']),
      reviewedAt: _stringValue(data, ['reviewedAt', 'reviewed_at']),
      nearestAction: _stringValue(data, [
        'nearestAction',
        'nearest_action',
        'nextStep',
        'next_step',
        'action'
      ]),
      progress: _intValue(data, ['progress', 'completion', 'percent']),
      assignedFreelancer: _stringValue(
        data,
        ['assignedFreelancer', 'assigned_freelancer', 'freelancer'],
      ),
      offers: offers,
    );
  }
}

class HelperCategory {
  final String title;
  final String subtitle;

  const HelperCategory({
    required this.title,
    required this.subtitle,
  });

  factory HelperCategory.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json);
    return HelperCategory(
      title: _stringValue(data, ['title', 'name']),
      subtitle: _stringValue(data, ['subtitle', 'sub_title', 'description']),
    );
  }
}

class RecommendedFreelancer {
  final String name;
  final String skill;
  final double rating;
  final String responseTime;
  final int baseRate;

  const RecommendedFreelancer({
    required this.name,
    required this.skill,
    required this.rating,
    required this.responseTime,
    required this.baseRate,
  });

  factory RecommendedFreelancer.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json);
    return RecommendedFreelancer(
      name: _stringValue(data, ['name']),
      skill: _stringValue(data, ['skill', 'expertise']),
      rating: _doubleValue(data, ['rating', 'rate']),
      responseTime: _stringValue(data, ['responseTime', 'response_time']),
      baseRate: _intValue(data, ['baseRate', 'base_rate', 'rate']),
    );
  }
}

class AvailableTask {
  final String id;
  final String title;
  final String category;
  final String description;
  final int initialBudget;
  final String deadlineLabel;
  final AssistanceType assistanceType;
  final String clientName;
  final String postedLabel;
  final int applicantsCount;
  final String budgetRangeLabel;
  final String location;
  final String? attachmentName;
  final String? attachmentUrl;

  const AvailableTask({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.initialBudget,
    required this.deadlineLabel,
    required this.assistanceType,
    required this.clientName,
    required this.postedLabel,
    required this.applicantsCount,
    required this.budgetRangeLabel,
    required this.location,
    this.attachmentName,
    this.attachmentUrl,
  });

  factory AvailableTask.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json);
    return AvailableTask(
      id: _stringValue(data, ['id', 'taskId', 'task_id']),
      title: _stringValue(data, ['title', 'name', 'judul']),
      category: _stringValue(
          data,
          ['category', 'taskCategory', 'task_category'],
          _stringValue(
              _asMap(data['kategori']), ['nama_kategori', 'name'], 'Umum')),
      description: _stringValue(
          data, ['description', 'detail', 'task_description', 'deskripsi']),
      initialBudget: _intValue(
          data, ['initialBudget', 'initial_budget', 'budget', 'anggaran_max']),
      deadlineLabel:
          _stringValue(data, ['deadlineLabel', 'deadline_label', 'deadline']),
      assistanceType: _enumValue<AssistanceType>(
        data,
        ['assistanceType', 'assistance_type'],
        AssistanceType.values,
        (value) => value.name,
        AssistanceType.online,
      ),
      clientName: _stringValue(
          data,
          ['clientName', 'client_name'],
          _stringValue(_asMap(data['client']),
              ['nama_kontak', 'nama_perusahaan'], 'Client')),
      postedLabel: _stringValue(
          data, ['postedLabel', 'posted_label', 'postedAt', 'created_at']),
      applicantsCount: _intValue(data, ['applicantsCount', 'applicants_count']),
      budgetRangeLabel: _stringValue(
          data,
          ['budgetRangeLabel', 'budget_range_label'],
          '${_intValue(data, ['anggaran_min'])} - ${_intValue(data, [
                'anggaran_max'
              ])}'),
      location: _stringValue(data, ['location', 'place'],
          _stringValue(_asMap(data['client']), ['alamat'], 'Online')),
      attachmentName: _stringValue(
          data, ['attachmentName', 'attachment_file_name', 'attachment_file']),
      attachmentUrl:
          _stringValue(data, ['attachmentUrl', 'attachment_file_url']),
    );
  }
}

class FreelancerApplication {
  final String id;
  final String taskTitle;
  final String category;
  final int offeredBudget;
  final String proposedDeadline;
  final String note;
  final OfferStatus status;
  final String updatedAtLabel;

  const FreelancerApplication({
    required this.id,
    required this.taskTitle,
    required this.category,
    required this.offeredBudget,
    required this.proposedDeadline,
    required this.note,
    required this.status,
    required this.updatedAtLabel,
  });
}

class FreelancerWorkItem {
  final String id;
  final String taskTitle;
  final String clientName;
  final String deadlineLabel;
  final int agreedBudget;
  final int progress;
  final WorkStatus status;
  final String nextStep;

  const FreelancerWorkItem({
    required this.id,
    required this.taskTitle,
    required this.clientName,
    required this.deadlineLabel,
    required this.agreedBudget,
    required this.progress,
    required this.status,
    required this.nextStep,
  });

  factory FreelancerWorkItem.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json);
    return FreelancerWorkItem(
      id: _stringValue(data, ['id', 'workId', 'work_id']),
      taskTitle:
          _stringValue(data, ['taskTitle', 'task_title', 'title', 'name']),
      clientName: _stringValue(data, ['clientName', 'client_name', 'client']),
      deadlineLabel:
          _stringValue(data, ['deadlineLabel', 'deadline_label', 'deadline']),
      agreedBudget:
          _intValue(data, ['agreedBudget', 'agreed_budget', 'budget']),
      progress: _intValue(data, ['progress', 'completion', 'percent']),
      status: _enumValue<WorkStatus>(
        data,
        ['status'],
        WorkStatus.values,
        (value) => value.name,
        WorkStatus.notStarted,
      ),
      nextStep: _stringValue(data, ['nextStep', 'next_step', 'action']),
    );
  }
}

class EarningTransaction {
  final String id;
  final String title;
  final int amount;
  final PaymentStatus status;
  final String dateLabel;

  const EarningTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.status,
    required this.dateLabel,
  });

  factory EarningTransaction.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json);
    return EarningTransaction(
      id: _stringValue(data, ['id', 'transactionId', 'transaction_id']),
      title: _stringValue(data, ['title', 'description', 'name']),
      amount: _intValue(data, ['amount', 'value', 'total']),
      status: _enumValue<PaymentStatus>(
        data,
        ['status'],
        PaymentStatus.values,
        (value) => value.name,
        PaymentStatus.unpaid,
      ),
      dateLabel:
          _stringValue(data, ['dateLabel', 'date_label', 'date', 'createdAt']),
    );
  }
}
