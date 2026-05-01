import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'role_selection_screen.dart';
import '../widgets/auth_flow_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final SessionService _sessionService = SessionService();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      icon: Icons.volunteer_activism,
      title: 'Bantu Sesama',
      description:
          'Bagikan keahlianmu untuk membantu orang lain dalam tugas-tugas kecil.',
      color: const Color(0xFF4A6FFF),
    ),
    OnboardingData(
      icon: Icons.work_outline,
      title: 'Dapatkan Penghargaan',
      description:
          'Dapatkan poin, sertifikat, dan testimoni dari orang yang kamu bantu.',
      color: const Color(0xFF6C8EFF),
    ),
    OnboardingData(
      icon: Icons.schedule,
      title: 'Fleksibel & Cepat',
      description:
          'Tugas kecil yang bisa diselesaikan dalam hitungan menit, di mana saja.',
      color: const Color(0xFF8CAAFF),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = authVerticalSpacing(context);

    return Scaffold(
      body: AuthGradientBackground(
        child: SafeArea(
          child: AuthContentContainer(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    const AuthBrandMark(size: 56),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SkillBantuin',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Kolaborasi cepat untuk klien dan freelancer',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.76),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_currentPage < _onboardingData.length - 1)
                      TextButton(
                        onPressed: _goToRoleSelection,
                        child: const Text('Lewati'),
                      ),
                  ],
                ),
                SizedBox(height: spacing),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _onboardingData.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnboardingContent(data: _onboardingData[index]);
                    },
                  ),
                ),
                SizedBox(height: spacing),
                AuthGlassCard(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.28),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthPrimaryButton(
                        label: _currentPage == _onboardingData.length - 1
                            ? 'Mulai Sekarang'
                            : 'Lanjut',
                        onPressed: () {
                          if (_currentPage == _onboardingData.length - 1) {
                            _goToRoleSelection();
                            return;
                          }

                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeInOut,
                          );
                        },
                        trailing: Icon(
                          _currentPage == _onboardingData.length - 1
                              ? Icons.arrow_forward_rounded
                              : Icons.chevron_right_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToRoleSelection() async {
    await _sessionService.markOnboardingSeen();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final OnboardingData data;
  const OnboardingContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final spacing = authVerticalSpacing(context);

    return Center(
      child: AuthGlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),
              child: Icon(
                data.icon,
                size: 42,
                color: Colors.white,
              ),
            ),
            SizedBox(height: spacing),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              data.description,
              style: TextStyle(
                fontSize: 15,
                height: 1.65,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withValues(alpha: 0.08),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tampilan dibuat ringan dan nyaman dibaca di layar kecil maupun besar.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.76),
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
