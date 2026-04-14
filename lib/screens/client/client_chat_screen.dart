import 'package:flutter/material.dart';
import '../../widgets/chat_item.dart';

class ClientChatScreen extends StatelessWidget {
  const ClientChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesan')),
      body: ListView(
        // Hapus 'const' di sini
        padding: const EdgeInsets.all(16),
        children: const [
          // Bisa tetap pakai const di children array-nya
          ChatItem(
            name: 'Ahmad Rizki',
            role: 'UI/UX Designer',
            lastMessage: 'Progres project sudah 60%',
            time: '10:30',
            isActive: true,
            isClient: true,
          ),
          ChatItem(
            name: 'Siti Nurhaliza',
            role: 'Flutter Developer',
            lastMessage: 'Apakah ada revisi lagi?',
            time: '09:15',
            isActive: false,
            isClient: true,
          ),
          ChatItem(
            name: 'Budi Santoso',
            role: 'Backend Engineer',
            lastMessage: 'API sudah selesai',
            time: 'Kemarin',
            isActive: false,
            isClient: true,
          ),
        ],
      ),
    );
  }
}
