import 'package:flutter/material.dart';

class ClientSearchScreen extends StatelessWidget {
  const ClientSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Freelancer')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari freelancer berdasarkan skill...',
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
                _buildSearchResult(
                  'Muhammad Abdullah',
                  'Full Stack Developer',
                  4.9,
                  45,
                  150,
                ),
                _buildSearchResult(
                  'Dewi Sartika',
                  'UI/UX Designer',
                  5.0,
                  32,
                  120,
                ),
                _buildSearchResult(
                  'Rizky Febian',
                  'Mobile Developer',
                  4.7,
                  28,
                  180,
                ),
                _buildSearchResult(
                  'Andi Wijaya',
                  'Data Scientist',
                  4.8,
                  15,
                  250,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResult(
    String name,
    String skill,
    double rating,
    int projects,
    int price,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(Icons.person, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  skill,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Color(0xFFF59E0B)),
                    Text(' $rating ($projects proyek)'),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '\$$price/h',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(height: 4),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Lihat', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
