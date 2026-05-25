import '../models/chat_models.dart';
import '../models/task_models.dart';

class MockChatService {
  List<ChatRoom> getClientRooms() {
    return _clientRooms;
  }

  List<ChatRoom> getFreelancerRooms() {
    return _freelancerRooms;
  }

  ChatRoom getRoomById(String id) {
    return [..._clientRooms, ..._freelancerRooms]
        .firstWhere((room) => room.id == id);
  }
}

const List<ChatMessage> _room001Messages = [
  ChatMessage(
    id: 'msg-001',
    sender: ChatPartyRole.client,
    type: ChatMessageType.text,
    content:
        'Halo Kak Nadia, saya tertarik dengan penawarannya untuk poster seminar.',
    timeLabel: '09:10',
    status: ChatStatus.read,
  ),
  ChatMessage(
    id: 'msg-002',
    sender: ChatPartyRole.freelancer,
    type: ChatMessageType.negotiation,
    content: 'Saya ajukan penawaran awal untuk task ini.',
    timeLabel: '09:12',
    status: ChatStatus.read,
    negotiation: NegotiationData(
      title: 'Penawaran Volunteer',
      reward: 35000,
      deadline: '1 hari',
      status: NegotiationStatus.pending,
      actions: ['Terima', 'Tawar Balik'],
    ),
  ),
  ChatMessage(
    id: 'msg-003',
    sender: ChatPartyRole.client,
    type: ChatMessageType.negotiation,
    content: 'Bisa saya tawar sedikit supaya tetap sesuai budget acara?',
    timeLabel: '09:18',
    status: ChatStatus.read,
    negotiation: NegotiationData(
      title: 'Tawaran Balik Client',
      reward: 30000,
      deadline: '2 hari',
      status: NegotiationStatus.countered,
      actions: ['Setuju', 'Tolak'],
    ),
  ),
  ChatMessage(
    id: 'msg-004',
    sender: ChatPartyRole.freelancer,
    type: ChatMessageType.text,
    content: 'Kalau reward jadi Rp32.000, saya bisa kirim draft malam ini.',
    timeLabel: '10:30',
    status: ChatStatus.unread,
  ),
];

const List<ChatMessage> _room002Messages = [
  ChatMessage(
    id: 'msg-005',
    sender: ChatPartyRole.freelancer,
    type: ChatMessageType.text,
    content: 'Siap, saya bisa bantu rapikan sheet dan rekap dalam 1 hari.',
    timeLabel: '08:45',
    status: ChatStatus.read,
  ),
  ChatMessage(
    id: 'msg-006',
    sender: ChatPartyRole.client,
    type: ChatMessageType.text,
    content: 'Pembayaran sudah saya upload, silakan mulai kerja ya.',
    timeLabel: '09:15',
    status: ChatStatus.read,
  ),
];

const List<ChatMessage> _room003Messages = [
  ChatMessage(
    id: 'msg-007',
    sender: ChatPartyRole.freelancer,
    type: ChatMessageType.text,
    content: 'Versi portrait dan landscape sudah saya kirim ke folder Drive.',
    timeLabel: 'Kemarin 18:20',
    status: ChatStatus.read,
  ),
  ChatMessage(
    id: 'msg-008',
    sender: ChatPartyRole.client,
    type: ChatMessageType.text,
    content: 'Saya sudah cek hasilnya, tinggal final export 1080x1920 ya.',
    timeLabel: 'Kemarin 18:42',
    status: ChatStatus.unread,
  ),
];

const List<ChatRoom> _clientRooms = [
  ChatRoom(
    id: 'room-001',
    taskId: 'task-001',
    taskTitle: 'Bantu Desain Poster Seminar',
    counterpartName: 'Nadia Putri',
    counterpartRoleLabel: 'Graphic Designer',
    counterpartOnline: true,
    lastMessage: 'Kalau reward jadi Rp32.000, saya bisa kirim draft malam ini.',
    lastMessageTime: '10:30',
    unreadCount: 2,
    taskStatus: TaskStatus.negotiation,
    messages: _room001Messages,
  ),
  ChatRoom(
    id: 'room-002',
    taskId: 'task-002',
    taskTitle: 'Rapikan Data Absensi Excel',
    counterpartName: 'Budi Santoso',
    counterpartRoleLabel: 'Data Entry Specialist',
    counterpartOnline: false,
    lastMessage: 'Pembayaran sudah saya upload, silakan mulai kerja ya.',
    lastMessageTime: '09:15',
    unreadCount: 0,
    taskStatus: TaskStatus.waitingPayment,
    messages: _room002Messages,
  ),
  ChatRoom(
    id: 'room-003',
    taskId: 'task-004',
    taskTitle: 'Edit Video Reels Event Kampus',
    counterpartName: 'Raka Aditya',
    counterpartRoleLabel: 'Video Editor',
    counterpartOnline: true,
    lastMessage: 'Saya sudah cek hasilnya, tinggal final export 1080x1920 ya.',
    lastMessageTime: 'Kemarin',
    unreadCount: 1,
    taskStatus: TaskStatus.submitted,
    messages: _room003Messages,
  ),
];

const List<ChatRoom> _freelancerRooms = [
  ChatRoom(
    id: 'room-001',
    taskId: 'task-001',
    taskTitle: 'Bantu Desain Poster Seminar',
    counterpartName: 'Dina Amelia',
    counterpartRoleLabel: 'Client',
    counterpartOnline: true,
    lastMessage: 'Kalau reward jadi Rp32.000, saya bisa kirim draft malam ini.',
    lastMessageTime: '10:30',
    unreadCount: 2,
    taskStatus: TaskStatus.negotiation,
    messages: _room001Messages,
  ),
  ChatRoom(
    id: 'room-002',
    taskId: 'task-002',
    taskTitle: 'Rapikan Data Absensi Excel',
    counterpartName: 'Budi Santosa',
    counterpartRoleLabel: 'Client',
    counterpartOnline: false,
    lastMessage: 'Pembayaran sudah saya upload, silakan mulai kerja ya.',
    lastMessageTime: '09:15',
    unreadCount: 0,
    taskStatus: TaskStatus.waitingPayment,
    messages: _room002Messages,
  ),
  ChatRoom(
    id: 'room-003',
    taskId: 'task-004',
    taskTitle: 'Edit Video Reels Event Kampus',
    counterpartName: 'Rian Kurniawan',
    counterpartRoleLabel: 'Client',
    counterpartOnline: true,
    lastMessage: 'Saya sudah cek hasilnya, tinggal final export 1080x1920 ya.',
    lastMessageTime: 'Kemarin',
    unreadCount: 1,
    taskStatus: TaskStatus.submitted,
    messages: _room003Messages,
  ),
];
