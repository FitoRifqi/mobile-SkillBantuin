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
    this.assignedFreelancer,
  });
}

class HelperCategory {
  final String title;
  final String subtitle;

  const HelperCategory({
    required this.title,
    required this.subtitle,
  });
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
  });
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
}
