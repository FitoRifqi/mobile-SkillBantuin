import 'freelancer_model.dart';
import 'project_model.dart';

class OfferModel {
  final int? id;
  final int? projectId;
  final int? freelancerId;
  final FreelancerModel? freelancer;
  final ProjectModel? project;
  final int? offeredBudget;
  final String? message;
  final int? proposedDeadlineDays;
  final String? status;
  final String? createdAt;

  OfferModel({
    this.id,
    this.projectId,
    this.freelancerId,
    this.freelancer,
    this.project,
    this.offeredBudget,
    this.message,
    this.proposedDeadlineDays,
    this.status,
    this.createdAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      projectId: json['project_id'] != null
          ? int.tryParse(json['project_id'].toString())
          : null,
      freelancerId: json['freelancer_id'] != null
          ? int.tryParse(json['freelancer_id'].toString())
          : null,
      freelancer: json['freelancer'] != null
          ? FreelancerModel.fromJson(
              Map<String, dynamic>.from(json['freelancer']))
          : null,
      project: json['project'] != null
          ? ProjectModel.fromJson(Map<String, dynamic>.from(json['project']))
          : null,
      offeredBudget: json['offered_budget'] != null
          ? int.tryParse(json['offered_budget'].toString())
          : null,
      message: json['message'] as String?,
      proposedDeadlineDays: json['proposed_deadline_days'] != null
          ? int.tryParse(json['proposed_deadline_days'].toString())
          : null,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'freelancer_id': freelancerId,
      'freelancer': freelancer?.toJson(),
      'project': project?.toJson(),
      'offered_budget': offeredBudget,
      'message': message,
      'proposed_deadline_days': proposedDeadlineDays,
      'status': status,
      'created_at': createdAt,
    };
  }
}
