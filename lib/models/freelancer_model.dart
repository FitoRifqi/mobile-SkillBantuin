class FreelancerModel {
  final int? id;
  final String? namaLengkap;
  final String? email;
  final String? noTelepon;
  final String? keahlian;
  final String? portfolio;
  final String? deskripsi;
  final int? hargaPerHari;
  final int? pengalamanTahun;
  final double? rating;
  final String? status;

  FreelancerModel({
    this.id,
    this.namaLengkap,
    this.email,
    this.noTelepon,
    this.keahlian,
    this.portfolio,
    this.deskripsi,
    this.hargaPerHari,
    this.pengalamanTahun,
    this.rating,
    this.status,
  });

  factory FreelancerModel.fromJson(Map<String, dynamic> json) {
    return FreelancerModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      namaLengkap: json['nama_lengkap'] as String?,
      email: json['email'] as String?,
      noTelepon: json['no_telepon'] as String?,
      keahlian: json['keahlian'] as String?,
      portfolio: json['portfolio'] as String?,
      deskripsi: json['deskripsi'] as String?,
      hargaPerHari: json['harga_per_hari'] != null ? int.tryParse(json['harga_per_hari'].toString()) : null,
      pengalamanTahun: json['pengalaman_tahun'] != null ? int.tryParse(json['pengalaman_tahun'].toString()) : null,
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_lengkap': namaLengkap,
      'email': email,
      'no_telepon': noTelepon,
      'keahlian': keahlian,
      'portfolio': portfolio,
      'deskripsi': deskripsi,
      'harga_per_hari': hargaPerHari,
      'pengalaman_tahun': pengalamanTahun,
      'rating': rating,
      'status': status,
    };
  }
}
