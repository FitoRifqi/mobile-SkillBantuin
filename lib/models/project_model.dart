import 'client_model.dart';
import 'category_model.dart';
import 'offer_model.dart';
import 'bid_model.dart';

class ProjectModel {
  final int? id;
  final int? clientId;
  final int? kategoriId;
  final String? judul;
  final String? deskripsi;
  final int? anggaranMin;
  final int? anggaranMax;
  final int? agreedBudget;
  final DateTime? deadline;
  final String? status;
  final String? attachmentFile;
  final String? attachmentFileName;
  final String? attachmentFileUrl;
  final ClientModel? client;
  final CategoryModel? kategori;
  final List<BidModel>? bids;
  final List<OfferModel>? offers;
  final String? resultFile;
  final String? resultFileName;
  final String? resultFileUrl;
  final String? resultLink;
  final String? resultNote;
  final String? resultSubmittedAt;
  final int? reviewRating;
  final String? reviewComment;
  final String? reviewedAt;

  ProjectModel({
    this.id,
    this.clientId,
    this.kategoriId,
    this.judul,
    this.deskripsi,
    this.anggaranMin,
    this.anggaranMax,
    this.agreedBudget,
    this.deadline,
    this.status,
    this.attachmentFile,
    this.attachmentFileName,
    this.attachmentFileUrl,
    this.client,
    this.kategori,
    this.bids,
    this.offers,
    this.resultFile,
    this.resultFileName,
    this.resultFileUrl,
    this.resultLink,
    this.resultNote,
    this.resultSubmittedAt,
    this.reviewRating,
    this.reviewComment,
    this.reviewedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDeadline;
    if (json['deadline'] != null) {
      try {
        parsedDeadline = DateTime.tryParse(json['deadline'].toString());
      } catch (_) {
        parsedDeadline = null;
      }
    }

    return ProjectModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      clientId: json['client_id'] != null
          ? int.tryParse(json['client_id'].toString())
          : null,
      kategoriId: json['kategori_id'] != null
          ? int.tryParse(json['kategori_id'].toString())
          : null,
      judul: json['judul'] as String?,
      deskripsi: json['deskripsi'] as String?,
      anggaranMin: json['anggaran_min'] != null
          ? int.tryParse(json['anggaran_min'].toString())
          : null,
      anggaranMax: json['anggaran_max'] != null
          ? int.tryParse(json['anggaran_max'].toString())
          : null,
      agreedBudget: json['agreed_budget'] != null
          ? int.tryParse(json['agreed_budget'].toString())
          : null,
      deadline: parsedDeadline,
      status: json['status'] as String?,
      attachmentFile: json['attachment_file'] as String?,
      attachmentFileName: json['attachment_file_name'] as String?,
      attachmentFileUrl: json['attachment_file_url'] as String?,
      client: json['client'] != null
          ? ClientModel.fromJson(Map<String, dynamic>.from(json['client']))
          : null,
      kategori: json['kategori'] != null
          ? CategoryModel.fromJson(Map<String, dynamic>.from(json['kategori']))
          : null,
      bids: json['bids'] is List
          ? List<BidModel>.from((json['bids'] as List)
              .map((e) => BidModel.fromJson(Map<String, dynamic>.from(e))))
          : null,
      offers: json['offers'] is List
          ? List<OfferModel>.from((json['offers'] as List)
              .map((e) => OfferModel.fromJson(Map<String, dynamic>.from(e))))
          : null,
      resultFile: json['result_file'] as String?,
      resultFileName: json['result_file_name'] as String?,
      resultFileUrl: json['result_file_url'] as String?,
      resultLink: json['result_link'] as String?,
      resultNote: json['result_note'] as String?,
      resultSubmittedAt: json['result_submitted_at'] as String?,
      reviewRating: json['review_rating'] != null
          ? int.tryParse(json['review_rating'].toString())
          : null,
      reviewComment: json['review_comment'] as String?,
      reviewedAt: json['reviewed_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'kategori_id': kategoriId,
      'judul': judul,
      'deskripsi': deskripsi,
      'anggaran_min': anggaranMin,
      'anggaran_max': anggaranMax,
      'agreed_budget': agreedBudget,
      'deadline': deadline?.toIso8601String(),
      'status': status,
      'attachment_file': attachmentFile,
      'attachment_file_name': attachmentFileName,
      'attachment_file_url': attachmentFileUrl,
      'client': client?.toJson(),
      'kategori': kategori?.toJson(),
      'bids': bids?.map((b) => b.toJson()).toList(),
      'offers': offers?.map((o) => o.toJson()).toList(),
      'result_file': resultFile,
      'result_file_name': resultFileName,
      'result_file_url': resultFileUrl,
      'result_link': resultLink,
      'result_note': resultNote,
      'result_submitted_at': resultSubmittedAt,
      'review_rating': reviewRating,
      'review_comment': reviewComment,
      'reviewed_at': reviewedAt,
    };
  }
}
