import 'package:flutter/material.dart';

class FreelancerSearchScreen extends StatelessWidget {
  const FreelancerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Proyek')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari proyek berdasarkan kategori...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildProjectItem(
                  'Mobile App Development',
                  'Flutter Developer',
                  800,
                  50,
                  '5 hari yang lalu',
                ),
                _buildProjectItem(
                  'Website Corporate',
                  'Web Developer',
                  600,
                  30,
                  '3 hari yang lalu',
                ),
                _buildProjectItem(
                  'UI/UX Design',
                  'Product Designer',
                  450,
                  40,
                  '1 hari yang lalu',
                ),
                _buildProjectItem(
                  'Database Migration',
                  'Database Engineer',
                  1000,
                  20,
                  '2 hari yang lalu',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectItem(
    String title,
    String skill,
    int budget,
    int applicants,
    String posted,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(skill, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget: \$$budget',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
              Text(
                '$applicants melamar',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Diposting: $posted',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Lamar Sekarang',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
