import 'package:flutter/material.dart';

import '../../models/task_models.dart';
import '../../services/mock_task_service.dart';
import 'client_task_detail_screen.dart';

class ClientSearchScreen extends StatefulWidget {
  const ClientSearchScreen({super.key});

  @override
  State<ClientSearchScreen> createState() => _ClientSearchScreenState();
}

class _ClientSearchScreenState extends State<ClientSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController(text: '30000');
  final _locationController = TextEditingController();
  final _attachmentController = TextEditingController();
  final _taskService = MockTaskService();

  String? _selectedCategory;
  DateTime? _selectedDeadline;
  AssistanceType _assistanceType = AssistanceType.online;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    _attachmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _taskService.getClientCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Bantuan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF047857)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Permintaan Bantuan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Isi tugas, budget, dan deadline.',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Utama',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Judul bantuan',
                      hintText: 'Contoh: Bantu Desain Poster Seminar',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Judul bantuan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategori skill',
                    ),
                    items: categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category.title,
                            child: Text(category.title),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih kategori skill';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      hintText: 'Jelaskan kebutuhan bantuan dengan jelas...',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      if (value.trim().length < 20) {
                        return 'Deskripsi minimal 20 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Budget awal',
                      prefixText: 'Rp ',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Budget awal tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickDeadline,
                    borderRadius: BorderRadius.circular(18),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Deadline',
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            _selectedDeadline == null
                                ? 'Pilih tanggal deadline'
                                : '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tipe bantuan',
                    style: TextStyle(
                      color: Color(0xFF334155),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<AssistanceType>(
                    segments: const [
                      ButtonSegment(
                        value: AssistanceType.online,
                        label: Text('Online'),
                        icon: Icon(Icons.language_rounded),
                      ),
                      ButtonSegment(
                        value: AssistanceType.offline,
                        label: Text('Offline'),
                        icon: Icon(Icons.location_on_outlined),
                      ),
                    ],
                    selected: {_assistanceType},
                    onSelectionChanged: (value) {
                      setState(() {
                        _assistanceType = value.first;
                      });
                    },
                  ),
                  if (_assistanceType == AssistanceType.offline) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Lokasi bantuan',
                        hintText: 'Contoh: Kampus A, Gedung B, Jakarta',
                      ),
                      validator: (value) {
                        if (_assistanceType == AssistanceType.offline &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Lokasi wajib diisi untuk bantuan offline';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _attachmentController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Lampiran opsional',
                      hintText: 'Upload brief atau file pendukung',
                      suffixIcon: TextButton(
                        onPressed: _pickAttachment,
                        child: const Text('Upload'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitTask,
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Kirim Permintaan Bantuan'),
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

  Future<void> _pickDeadline() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
      initialDate:
          _selectedDeadline ?? DateTime.now().add(const Duration(days: 3)),
    );

    if (selected == null) return;

    setState(() {
      _selectedDeadline = selected;
    });
  }

  void _pickAttachment() {
    setState(() {
      _attachmentController.text = 'brief-tugas-client.pdf';
    });
  }

  void _submitTask() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih deadline terlebih dahulu.')),
      );
      return;
    }

    final newTask = ClientTask(
      id: 'draft-task-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      category: _selectedCategory!,
      description: _descriptionController.text.trim(),
      initialBudget: int.tryParse(_budgetController.text.trim()) ?? 0,
      deadlineLabel:
          '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}',
      createdAtLabel: 'Hari ini',
      status: TaskStatus.waitingOffer,
      paymentStatus: PaymentStatus.unpaid,
      assistanceType: _assistanceType,
      nearestAction: 'Menunggu freelancer mengirim penawaran',
      progress: 10,
      offers: const [],
      location: _assistanceType == AssistanceType.offline
          ? _locationController.text.trim()
          : null,
      attachmentName: _attachmentController.text.isEmpty
          ? null
          : _attachmentController.text,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClientTaskDetailScreen(task: newTask),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bantuan berhasil dibuat.'),
      ),
    );
  }
}
