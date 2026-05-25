import 'package:flutter/material.dart';

import 'app_ui.dart';
import 'auth_flow_widgets.dart';

class FreelancerCard extends StatelessWidget {
  final String name;
  final String skill;
  final double rating;
  final int projects;
  final int price;

  const FreelancerCard({
    super.key,
    required this.name,
    required this.skill,
    required this.rating,
    required this.projects,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AuthFlowPalette.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.person, color: AuthFlowPalette.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AuthFlowPalette.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  skill,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AuthFlowPalette.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                    Expanded(
                      child: Text(
                        ' $rating ($projects proyek)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '\$$price',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AuthFlowPalette.primary,
                ),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(76, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Pilih', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
