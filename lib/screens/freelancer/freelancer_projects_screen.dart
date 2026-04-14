import 'package:flutter/material.dart';
import '../../widgets/application_card.dart';

class FreelancerProjectsScreen extends StatelessWidget {
  const FreelancerProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lamaran Saya')),
      body: ListView(
        // Hapus 'const' di sini
        padding: const EdgeInsets.all(16),
        children: const [
          // Bisa tetap pakai const di children array-nya
          ApplicationCard(
            title: 'Aplikasi E-Commerce',
            status: 'Diterima',
            progressStatus: 'Sedang Berjalan',
            budget: 500,
            progress: 0.4,
          ),
          ApplicationCard(
            title: 'Redesign Website',
            status: 'Menunggu',
            progressStatus: 'Dalam Review',
            budget: 350,
            progress: 0.0,
          ),
          ApplicationCard(
            title: 'Database Migration',
            status: 'Selesai',
            progressStatus: 'Selesai',
            budget: 1000,
            progress: 1.0,
          ),
          ApplicationCard(
            title: 'API Integration',
            status: 'Ditolak',
            progressStatus: 'Tidak Dilanjutkan',
            budget: 400,
            progress: 0.0,
          ),
        ],
      ),
    );
  }
}
