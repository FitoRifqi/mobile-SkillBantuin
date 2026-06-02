class CategoryModel {
  final int? id;
  final String? namaKategori;
  final String? icon;
  final String? deskripsi;
  final String? status;

  CategoryModel({
    this.id,
    this.namaKategori,
    this.icon,
    this.deskripsi,
    this.status,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      namaKategori: json['nama_kategori'] as String?,
      icon: json['icon'] as String?,
      deskripsi: json['deskripsi'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kategori': namaKategori,
      'icon': icon,
      'deskripsi': deskripsi,
      'status': status,
    };
  }
}
