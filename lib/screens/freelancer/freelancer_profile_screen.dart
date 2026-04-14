import 'package:flutter/material.dart';
import '../../widgets/profile_section.dart';

class FreelancerProfileScreen extends StatelessWidget {
  const FreelancerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Freelancer'),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () {})],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          const ProfileSection(
            title: 'Portfolio',
            items: [
              'E-Commerce App - Flutter',
              'Company Profile Website',
              'Mobile Banking UI/UX',
            ],
            showCheckIcon: true,
          ),
          const SizedBox(height: 16),
          const ProfileSection(
            title: 'Keahlian',
            items: [
              'Flutter & Dart',
              'Laravel & PHP',
              'UI/UX Design',
              'Database Management',
            ],
            showCheckIcon: true,
          ),
          const SizedBox(height: 16),
          const ProfileSection(
            title: 'Pengaturan Akun',
            items: [
              'Verifikasi Email',
              'Verifikasi KTP',
              'Pengaturan Notifikasi',
              'Metode Penarikan Dana',
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: const Text('Tarik Dana Sekarang'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 50, color: Color(0xFF2563EB)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ahmad Rizki',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Full Stack Developer',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
              Text(' 4.9'),
              SizedBox(width: 16),
              Icon(Icons.work, size: 16),
              Text(' 12 Proyek'),
              SizedBox(width: 16),
              Icon(Icons.attach_money),
              Text(' \$2,450'),
            ],
          ),
        ],
      ),
    );
  }
}
