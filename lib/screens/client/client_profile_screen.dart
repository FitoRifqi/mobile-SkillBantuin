import 'package:flutter/material.dart';
import '../../widgets/profile_section.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () {})],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          const ProfileSection(
            title: 'Informasi Perusahaan',
            items: [
              'Bidang: Teknologi Informasi',
              'Lokasi: Jakarta, Indonesia',
              'Bergabung: Januari 2024',
              'Total Proyek: 12 Proyek',
            ],
          ),
          const SizedBox(height: 16),
          const ProfileSection(
            title: 'Metode Pembayaran',
            items: ['Visa •••• 4242', 'Bank BCA - 1234567890'],
          ),
          const SizedBox(height: 16),
          const ProfileSection(
            title: 'Pengaturan',
            items: [
              'Verifikasi Email',
              'Verifikasi Nomor HP',
              'Notifikasi',
              'Keamanan',
            ],
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
            child: const Icon(
              Icons.business,
              size: 50,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'PT Maju Bersama',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'info@majubersama.com',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
