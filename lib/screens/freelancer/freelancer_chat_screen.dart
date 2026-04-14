import 'package:flutter/material.dart';
import '../../widgets/chat_item.dart';

class FreelancerChatScreen extends StatelessWidget {
  const FreelancerChatScreen({super.key});

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
            name: 'PT Maju Bersama',
            role: 'Klien',
            lastMessage: 'Progres project sudah 60%',
            time: '10:30',
            isActive: true,
            isClient: false,
          ),
          ChatItem(
            name: 'Startup Inovasi',
            role: 'Klien',
            lastMessage: 'Apakah ada revisi lagi?',
            time: '09:15',
            isActive: false,
            isClient: false,
          ),
          ChatItem(
            name: 'CV Kreatif',
            role: 'Klien',
            lastMessage: 'Terima kasih atas kerjanya',
            time: 'Kemarin',
            isActive: false,
            isClient: false,
          ),
        ],
      ),
    );
  }
}
