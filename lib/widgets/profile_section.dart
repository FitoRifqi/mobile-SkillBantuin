import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool showCheckIcon;

  const ProfileSection({
    super.key,
    required this.title,
    required this.items,
    this.showCheckIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: showCheckIcon
                  ? Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 8),
                        Text(item, style: const TextStyle(fontSize: 14)),
                      ],
                    )
                  : Text(item, style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
