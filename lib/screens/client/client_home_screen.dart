import 'package:flutter/material.dart';
import '../../widgets/category_card.dart';
import '../../widgets/freelancer_card.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'SkillBantuin',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2563EB),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF2563EB),
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(),
                  const SizedBox(height: 24),
                  const Text(
                    'Kategori Populer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryList(),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Freelancer Terbaik',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const FreelancerCard(
                  name: 'Ahmad Rizki',
                  skill: 'UI/UX Designer',
                  rating: 4.9,
                  projects: 120,
                  price: 85,
                ),
                const FreelancerCard(
                  name: 'Siti Nurhaliza',
                  skill: 'Flutter Developer',
                  rating: 4.8,
                  projects: 95,
                  price: 120,
                ),
                const FreelancerCard(
                  name: 'Budi Santoso',
                  skill: 'Backend Engineer',
                  rating: 5.0,
                  projects: 200,
                  price: 150,
                ),
              ]),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Butuh Freelancer?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Posting proyek Anda dan dapatkan penawaran dari freelancer terverifikasi',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2563EB),
                  ),
                  child: const Text('+ Posting Proyek'),
                ),
              ],
            ),
          ),
          const Icon(Icons.work_outline, color: Colors.white, size: 60),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CategoryCard(
            title: 'UI/UX Design',
            icon: Icons.design_services,
            price: 250,
          ),
          CategoryCard(title: 'Web Dev', icon: Icons.code, price: 180),
          CategoryCard(
            title: 'Mobile Dev',
            icon: Icons.phone_android,
            price: 200,
          ),
          CategoryCard(title: 'Writing', icon: Icons.edit, price: 120),
          CategoryCard(title: 'Marketing', icon: Icons.trending_up, price: 95),
        ],
      ),
    );
  }
}
