class ChatMessageModel {
  final int? id;
  final int? projectId;
  final int? senderId;
  final String? senderName;
  final String? senderRole;
  final String? messageType;
  final String? content;
  final Map<String, dynamic>? metadata;
  final String? createdAt;

  ChatMessageModel({
    this.id,
    this.projectId,
    this.senderId,
    this.senderName,
    this.senderRole,
    this.messageType,
    this.content,
    this.metadata,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      projectId: json['project_id'] != null ? int.tryParse(json['project_id'].toString()) : null,
      senderId: json['sender_id'] != null ? int.tryParse(json['sender_id'].toString()) : null,
      senderName: json['sender_name'] as String?,
      senderRole: json['sender_role'] as String?,
      messageType: json['message_type'] as String?,
      content: json['content'] as String?,
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_role': senderRole,
      'message_type': messageType,
      'content': content,
      'metadata': metadata,
      'created_at': createdAt,
    };
  }
}
