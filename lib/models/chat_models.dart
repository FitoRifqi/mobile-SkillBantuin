import 'task_models.dart';

enum ChatStatus {
  sent,
  read,
  unread,
}

enum ChatPartyRole {
  client,
  freelancer,
}

enum ChatMessageType {
  text,
  negotiation,
  system,
}

enum NegotiationStatus {
  pending,
  accepted,
  rejected,
  countered,
}

class NegotiationData {
  final String title;
  final int reward;
  final String deadline;
  final NegotiationStatus status;
  final List<String> actions;

  const NegotiationData({
    required this.title,
    required this.reward,
    required this.deadline,
    required this.status,
    required this.actions,
  });
}

class ChatMessage {
  final String id;
  final ChatPartyRole sender;
  final ChatMessageType type;
  final String content;
  final String timeLabel;
  final ChatStatus status;
  final NegotiationData? negotiation;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.type,
    required this.content,
    required this.timeLabel,
    required this.status,
    this.negotiation,
  });
}

class ChatRoom {
  final String id;
  final String taskId;
  final String taskTitle;
  final String counterpartName;
  final String counterpartRoleLabel;
  final bool counterpartOnline;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final TaskStatus taskStatus;
  final List<ChatMessage> messages;

  const ChatRoom({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.counterpartName,
    required this.counterpartRoleLabel,
    required this.counterpartOnline,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.taskStatus,
    required this.messages,
  });
}
