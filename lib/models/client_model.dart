class ClientModel {
  final int? id;
  final String? namaPerusahaan;
  final String? namaKontak;
  final String? email;
  final String? noTelepon;
  final String? alamat;
  final String? bidangUsaha;
  final int? totalProyek;
  final String? status;

  ClientModel({
    this.id,
    this.namaPerusahaan,
    this.namaKontak,
    this.email,
    this.noTelepon,
    this.alamat,
    this.bidangUsaha,
    this.totalProyek,
    this.status,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      namaPerusahaan: json['nama_perusahaan'] as String?,
      namaKontak: json['nama_kontak'] as String?,
      email: json['email'] as String?,
      noTelepon: json['no_telepon'] as String?,
      alamat: json['alamat'] as String?,
      bidangUsaha: json['bidang_usaha'] as String?,
      totalProyek: json['total_proyek'] != null ? int.tryParse(json['total_proyek'].toString()) : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_perusahaan': namaPerusahaan,
      'nama_kontak': namaKontak,
      'email': email,
      'no_telepon': noTelepon,
      'alamat': alamat,
      'bidang_usaha': bidangUsaha,
      'total_proyek': totalProyek,
      'status': status,
    };
  }
}
