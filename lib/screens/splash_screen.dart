import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import 'main_navigation_screen.dart';
import 'onboarding_screen.dart';
import 'role_selection_screen.dart';
import '../widgets/auth_flow_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _sessionService = SessionService();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final onboardingSeen = await _sessionService.isOnboardingSeen();
    final savedSession = await _authService.getSavedSession();
    if (!mounted) return;

    final Widget targetScreen;
    if (savedSession != null) {
      targetScreen = MainNavigationScreen(userRole: savedSession.role);
    } else if (onboardingSeen) {
      targetScreen = const RoleSelectionScreen();
    } else {
      targetScreen = const OnboardingScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => targetScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = authVerticalSpacing(context);

    return Scaffold(
      body: AuthGradientBackground(
        child: SafeArea(
          child: AuthContentContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const AuthBrandMark(size: 108),
                SizedBox(height: spacing),
                const Text(
                  'SkillBantuin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Cari bantuan. Kerjakan tugas. Pantau progres.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
                SizedBox(height: spacing),
                const AuthGlassCard(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Menyiapkan aplikasi...',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Client dan freelancer dalam satu aplikasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 0.2,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
