import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillbantuin/main.dart';

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

  await tester.pumpWidget(const SkillBantuinApp());
}
