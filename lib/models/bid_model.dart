class BidModel {
  final int? id;
  final int? projectId;
  final int? freelancerId;
  final int? hargaPenawaran;
  final String? pesanPenawaran;
  final int? estimasiHari;
  final String? status;
  final String? createdAt;

  BidModel({
    this.id,
    this.projectId,
    this.freelancerId,
    this.hargaPenawaran,
    this.pesanPenawaran,
    this.estimasiHari,
    this.status,
    this.createdAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      projectId: json['project_id'] != null ? int.tryParse(json['project_id'].toString()) : null,
      freelancerId: json['freelancer_id'] != null ? int.tryParse(json['freelancer_id'].toString()) : null,
      hargaPenawaran: json['harga_penawaran'] != null ? int.tryParse(json['harga_penawaran'].toString()) : null,
      pesanPenawaran: json['pesan_penawaran'] as String?,
      estimasiHari: json['estimasi_hari'] != null ? int.tryParse(json['estimasi_hari'].toString()) : null,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'freelancer_id': freelancerId,
      'harga_penawaran': hargaPenawaran,
      'pesan_penawaran': pesanPenawaran,
      'estimasi_hari': estimasiHari,
      'status': status,
      'created_at': createdAt,
    };
  }
}
