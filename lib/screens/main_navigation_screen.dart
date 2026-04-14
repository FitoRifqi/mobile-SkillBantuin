import 'package:flutter/material.dart';
import '../models/user_role.dart';
import 'client/client_home_screen.dart';
import 'client/client_search_screen.dart';
import 'client/client_projects_screen.dart';
import 'client/client_chat_screen.dart';
import 'client/client_profile_screen.dart';
import 'freelancer/freelancer_home_screen.dart';
import 'freelancer/freelancer_search_screen.dart';
import 'freelancer/freelancer_projects_screen.dart';
import 'freelancer/freelancer_chat_screen.dart';
import 'freelancer/freelancer_profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final UserRole userRole;
  const MainNavigationScreen({super.key, required this.userRole});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    if (widget.userRole == UserRole.client) {
      _pages = const [
        ClientHomeScreen(),
        ClientSearchScreen(),
        ClientProjectsScreen(),
        ClientChatScreen(),
        ClientProfileScreen(),
      ];
    } else {
      _pages = const [
        FreelancerHomeScreen(),
        FreelancerSearchScreen(),
        FreelancerProjectsScreen(),
        FreelancerChatScreen(),
        FreelancerProfileScreen(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> items = widget.userRole == UserRole.client
        ? const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
            BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: 'Proyek'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
          ]
        : const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Cari Proyek'),
            BottomNavigationBarItem(icon: Icon(Icons.history_outlined), label: 'Lamaran'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
          ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: items,
        ),
      ),
    );
  }
}