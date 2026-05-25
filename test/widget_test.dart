// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillbantuin/main.dart'; // Pastikan nama package sesuai

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'skillbantuin_onboarding_seen': true,
    });
  });

  Future<void> pumpAppPastSplash(WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
        const SkillBantuinApp()); // Ganti MyApp menjadi SkillBantuinApp
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  testWidgets('Shows role selection after splash', (WidgetTester tester) async {
    await pumpAppPastSplash(tester);

    // Verify that our app starts with role selection page after onboarding.
    expect(find.text('Pilih peran untuk masuk ke dashboard yang tepat'),
        findsOneWidget);
    expect(find.text('Saya Client'), findsOneWidget);
    expect(find.text('Saya Freelancer'), findsOneWidget);
  });

  testWidgets('Client role opens client login flow',
      (WidgetTester tester) async {
    await pumpAppPastSplash(tester);

    // Tap client button
    await tester.tap(find.text('Saya Client'));
    await tester.pumpAndSettle();

    // Should navigate to client login
    expect(find.text('Masuk ke SkillBantuin'), findsOneWidget);
    expect(find.text('Kelola pencarian freelancer dan kebutuhan proyekmu.'),
        findsOneWidget);
  });

  testWidgets('Freelancer role opens freelancer login flow',
      (WidgetTester tester) async {
    await pumpAppPastSplash(tester);

    // Tap freelancer button
    final freelancerRole = find.text('Saya Freelancer');
    await tester.ensureVisible(freelancerRole);
    await tester.tap(freelancerRole);
    await tester.pumpAndSettle();

    // Should navigate to freelancer login
    expect(find.text('Masuk ke SkillBantuin'), findsOneWidget);
    expect(find.text('Lanjutkan mencari proyek dan peluang kerja yang cocok.'),
        findsOneWidget);
  });
}
