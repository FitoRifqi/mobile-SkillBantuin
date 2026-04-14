import 'package:flutter/material.dart';
import '../../widgets/project_card.dart';

class ClientProjectsScreen extends StatelessWidget {
  const ClientProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyek Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
            tooltip: 'Posting Proyek Baru',
          ),
        ],
      ),
      body: ListView(
        // Hapus 'const' di sini
        padding: const EdgeInsets.all(16),
        children: const [
          // Bisa tetap pakai const di children array-nya
          ProjectCard(
            title: 'Aplikasi Mobile E-Commerce',
            status: 'Sedang Berjalan',
            progress: 0.6,
            budget: 500,
            assignedTo: 'Ahmad Rizki',
          ),
          ProjectCard(
            title: 'Redesign Website Perusahaan',
            status: 'Menunggu Konfirmasi',
            progress: 0.3,
            budget: 350,
            assignedTo: 'Menunggu',
          ),
          ProjectCard(
            title: 'Landing Page Startup',
            status: 'Selesai',
            progress: 1.0,
            budget: 200,
            assignedTo: 'Siti Nurhaliza',
          ),
          ProjectCard(
            title: 'Sistem Manajemen Database',
            status: 'Dalam Review',
            progress: 0.8,
            budget: 750,
            assignedTo: 'Budi Santoso',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add),
      ),
    );
  }
}
