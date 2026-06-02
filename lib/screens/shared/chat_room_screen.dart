import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../models/chat_models.dart';
import '../../models/chat_message_model.dart';
import '../../models/user_role.dart';
import '../../services/marketplace_service.dart';
import '../../utils/task_ui_utils.dart';
import '../../widgets/status_badge.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatRoom room;
  final UserRole currentRole;

  const ChatRoomScreen({
    super.key,
    required this.room,
    required this.currentRole,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final _marketplaceService = MarketplaceService();
  final SpeechToText _speechToText = SpeechToText();
  final List<ChatMessage> _draftMessages = [];
  List<ChatMessage> _serverMessages = [];
  bool _isLoadingMessages = true;
  bool _isSending = false;
  bool _isSpeechReady = false;
  bool _isListening = false;
  String? _loadError;
  Timer? _refreshTimer;

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _initSpeech();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _loadMessages(silent: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentParty = widget.currentRole == UserRole.client
        ? ChatPartyRole.client
        : ChatPartyRole.freelancer;
    final messages = [
      ...(_serverMessages.isEmpty ? widget.room.messages : _serverMessages),
      ..._draftMessages,
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF059669).withValues(alpha: 0.1),
              child: const Icon(Icons.person_rounded, color: Color(0xFF059669)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.room.counterpartName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    widget.room.taskTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusBadge(
                  label: taskStatusLabel(widget.room.taskStatus),
                  color: taskStatusColor(widget.room.taskStatus),
                ),
                _MiniChip(label: widget.room.counterpartRoleLabel),
                _MiniChip(label: widget.room.taskTitle),
              ],
            ),
          ),
          Expanded(
            child: _isLoadingMessages
                ? const Center(child: CircularProgressIndicator())
                : _loadError != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            _loadError!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF64748B)),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMine = message.sender == currentParty;

                          if (message.type == ChatMessageType.negotiation &&
                              message.negotiation != null) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _NegotiationCard(
                                isMine: isMine,
                                message: message,
                                onActionTap: (action) =>
                                    _handleNegotiationAction(action),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Align(
                              alignment: isMine
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 290),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMine
                                        ? const Color(0xFF059669)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.content,
                                        style: TextStyle(
                                          color: isMine
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${message.timeLabel} • ${_chatStatusLabel(message.status)}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isMine
                                              ? Colors.white
                                                  .withValues(alpha: 0.72)
                                              : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Lampiran opsional akan dilanjutkan di tahap berikutnya.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.attach_file_rounded),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan...',
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: _isListening
                        ? const Color(0xFFDC2626)
                        : const Color(0xFFEFF6FF),
                    child: IconButton(
                      tooltip: _isListening
                          ? 'Berhenti rekam suara'
                          : 'Voice recognition',
                      onPressed: _toggleVoiceRecognition,
                      icon: Icon(
                        _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                        color: _isListening
                            ? Colors.white
                            : const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: _isSending
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF059669),
                    child: IconButton(
                      onPressed:
                          _isSending ? null : () => _sendMessage(currentParty),
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadMessages({bool silent = false}) async {
    try {
      final messages = await _marketplaceService.fetchChats(widget.room.taskId);
      if (!mounted) return;
      setState(() {
        _serverMessages = messages.map(_chatMessageFromApi).toList();
        _loadError = null;
        _isLoadingMessages = false;
      });
    } catch (error) {
      if (!mounted) return;
      if (silent) return;
      setState(() {
        _loadError = error.toString();
        _isLoadingMessages = false;
      });
    }
  }

  Future<void> _initSpeech() async {
    final available = await _speechToText.initialize(
      onStatus: (status) {
        if (!mounted) return;
        setState(() {
          _isListening = status == 'listening';
        });
      },
      onError: (error) {
        if (!mounted) return;
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Voice recognition gagal: ${error.errorMsg}')),
        );
      },
    );

    if (!mounted) return;
    setState(() => _isSpeechReady = available);
  }

  Future<void> _toggleVoiceRecognition() async {
    if (_isListening) {
      await _speechToText.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    if (!_isSpeechReady) {
      await _initSpeech();
    }

    if (!_isSpeechReady) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice recognition belum tersedia di device ini.'),
        ),
      );
      return;
    }

    await _speechToText.listen(
      onResult: _handleSpeechResult,
      listenOptions: SpeechListenOptions(
        localeId: 'id_ID',
        listenMode: ListenMode.dictation,
        partialResults: true,
      ),
    );

    if (mounted) setState(() => _isListening = true);
  }

  void _handleSpeechResult(SpeechRecognitionResult result) {
    final recognizedWords = result.recognizedWords.trim();
    if (recognizedWords.isEmpty) return;

    _messageController.text = recognizedWords;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
  }

  Future<void> _sendMessage(ChatPartyRole currentParty) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isSending = true;
      _messageController.clear();
    });

    try {
      await _marketplaceService.sendChat(
        projectId: widget.room.taskId,
        content: text,
      );
      if (!mounted) return;
      await _loadMessages(silent: true);
    } catch (error) {
      if (!mounted) return;
      _messageController.text = text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  ChatMessage _chatMessageFromApi(ChatMessageModel message) {
    return ChatMessage(
      id: message.id?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      sender: message.senderRole == 'client'
          ? ChatPartyRole.client
          : ChatPartyRole.freelancer,
      type: message.messageType == 'negotiation'
          ? ChatMessageType.negotiation
          : message.messageType == 'system'
              ? ChatMessageType.system
              : ChatMessageType.text,
      content: message.content ?? '',
      timeLabel: message.createdAt ?? '',
      status: ChatStatus.sent,
    );
  }

  void _handleNegotiationAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aksi "$action" dipilih.'),
      ),
    );
  }

  String _chatStatusLabel(ChatStatus status) {
    switch (status) {
      case ChatStatus.sent:
        return 'sent';
      case ChatStatus.read:
        return 'read';
      case ChatStatus.unread:
        return 'unread';
    }
  }
}

class _NegotiationCard extends StatelessWidget {
  final bool isMine;
  final ChatMessage message;
  final ValueChanged<String> onActionTap;

  const _NegotiationCard({
    required this.isMine,
    required this.message,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final negotiation = message.negotiation!;
    final color = _negotiationColor(negotiation.status);

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      negotiation.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  StatusBadge(
                    label: _negotiationStatusLabel(negotiation.status),
                    color: color,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _NegotiationRow(
                label: 'Budget',
                value: formatRupiah(negotiation.reward),
              ),
              const SizedBox(height: 8),
              _NegotiationRow(
                label: 'Deadline',
                value: negotiation.deadline,
              ),
              const SizedBox(height: 12),
              Text(
                message.content,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: negotiation.actions
                    .map(
                      (action) => action == negotiation.actions.first
                          ? ElevatedButton(
                              onPressed: () => onActionTap(action),
                              child: Text(action),
                            )
                          : OutlinedButton(
                              onPressed: () => onActionTap(action),
                              child: Text(action),
                            ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _negotiationColor(NegotiationStatus status) {
    switch (status) {
      case NegotiationStatus.pending:
        return const Color(0xFFF59E0B);
      case NegotiationStatus.accepted:
        return const Color(0xFF10B981);
      case NegotiationStatus.rejected:
        return const Color(0xFFDC2626);
      case NegotiationStatus.countered:
        return const Color(0xFF16A34A);
    }
  }

  String _negotiationStatusLabel(NegotiationStatus status) {
    switch (status) {
      case NegotiationStatus.pending:
        return 'Pending';
      case NegotiationStatus.accepted:
        return 'Diterima';
      case NegotiationStatus.rejected:
        return 'Ditolak';
      case NegotiationStatus.countered:
        return 'Counter';
    }
  }
}

class _NegotiationRow extends StatelessWidget {
  final String label;
  final String value;

  const _NegotiationRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;

  const _MiniChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF059669),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
