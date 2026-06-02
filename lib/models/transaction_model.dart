class TransactionModel {
  final int? id;
  final String? orderId;
  final int? projectId;
  final String? paymentType;
  final String? status;
  final int? amount;
  final Map<String, dynamic>? midtransPayload;
  final String? createdAt;

  TransactionModel({
    this.id,
    this.orderId,
    this.projectId,
    this.paymentType,
    this.status,
    this.amount,
    this.midtransPayload,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      orderId: json['order_id'] as String?,
      projectId: json['project_id'] != null ? int.tryParse(json['project_id'].toString()) : null,
      paymentType: json['payment_type'] as String?,
      status: json['status'] as String?,
      amount: json['amount'] != null ? int.tryParse(json['amount'].toString()) : null,
      midtransPayload: json['midtrans_payload'] != null ? Map<String, dynamic>.from(json['midtrans_payload']) : null,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'project_id': projectId,
      'payment_type': paymentType,
      'status': status,
      'amount': amount,
      'midtrans_payload': midtransPayload,
      'created_at': createdAt,
    };
  }
}
