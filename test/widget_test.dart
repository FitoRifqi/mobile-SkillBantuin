// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:skillbantuin/main.dart'; // Pastikan nama package sesuai

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
        const SkillBantuinApp()); // Ganti MyApp menjadi SkillBantuinApp

    // Verify that our app starts with role selection page.
    expect(find.text('SkillBantuin'), findsWidgets);
    expect(find.text('Platform Freelance Terpercaya'), findsOneWidget);
    expect(find.text('Masuk sebagai:'), findsOneWidget);
    expect(find.text('Klien - Cari Freelancer'), findsOneWidget);
    expect(find.text('Freelancer - Cari Proyek'), findsOneWidget);
  });

  testWidgets('Role selection buttons work', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillBantuinApp());

    // Tap client button
    await tester.tap(find.text('Klien - Cari Freelancer'));
    await tester.pumpAndSettle();

    // Should navigate to client home
    expect(find.text('Butuh Freelancer?'), findsOneWidget);
  });

  testWidgets('Freelancer role navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillBantuinApp());

    // Tap freelancer button
    await tester.tap(find.text('Freelancer - Cari Proyek'));
    await tester.pumpAndSettle();

    // Should navigate to freelancer home
    expect(find.text('Halo, Freelancer!'), findsOneWidget);
  });
}
