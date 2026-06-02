import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillbantuin/main.dart';
import 'package:skillbantuin/providers/auth_provider.dart';
import 'package:skillbantuin/providers/freelancer_provider.dart';
import 'package:skillbantuin/providers/project_provider.dart';
import 'package:skillbantuin/services/api_service.dart';
import 'package:skillbantuin/services/auth_service.dart';
import 'package:skillbantuin/services/session_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Splash screen renders app branding', (tester) async {
    await _pumpApp(tester);

    expect(find.text('SkillBantuin'), findsWidgets);
    expect(
      find.text(
        'Cari bantuan. Kerjakan tugas. Pantau progres.',
      ),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('Onboarding can continue to role selection', (tester) async {
    await _pumpApp(tester);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();

    expect(find.text('Saya Client'), findsOneWidget);
    expect(find.text('Saya Freelancer'), findsOneWidget);
  });

  testWidgets('Role selection opens login form', (tester) async {
    await _pumpApp(tester);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Saya Freelancer'));
    await tester.tap(find.text('Saya Freelancer'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke SkillBantuin'), findsOneWidget);
    expect(
      find.text('Contoh akun: freelancerdemo / demo123'),
      findsOneWidget,
    );
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final preferences = await SharedPreferences.getInstance();
  final sessionService = SessionService(sharedPreferences: preferences);
  final apiService = ApiService();
  final authService = AuthService(
    apiService: apiService,
    sessionService: sessionService,
  );

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: preferences),
        Provider<SessionService>.value(value: sessionService),
        Provider<ApiService>.value(value: apiService),
        Provider<AuthService>.value(value: authService),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService)..initialize(),
        ),
        ChangeNotifierProvider<ProjectProvider>(
          create: (_) => ProjectProvider(apiService, sessionService),
        ),
        ChangeNotifierProvider<FreelancerProvider>(
          create: (_) => FreelancerProvider(apiService),
        ),
      ],
      child: const SkillBantuinApp(),
    ),
  );
}
