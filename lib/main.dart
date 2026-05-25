import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skillbantuin/screens/splash_screen.dart';
import 'package:skillbantuin/widgets/app_ui.dart';
import 'package:skillbantuin/widgets/auth_flow_widgets.dart';

void main() {
  runApp(const SkillBantuinApp());
}

class SkillBantuinApp extends StatelessWidget {
  const SkillBantuinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillBantuin',
      theme: ThemeData(
        primaryColor: AuthFlowPalette.primary,
        colorScheme: const ColorScheme.light(
          primary: AuthFlowPalette.primary,
          secondary: Color(0xFF10B981),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: AppUi.pageBackground,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1F2937),
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide:
                const BorderSide(color: AuthFlowPalette.primary, width: 1.6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFDC2626)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.4),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AuthFlowPalette.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            foregroundColor: AuthFlowPalette.primary,
            side: const BorderSide(color: Color(0xFFD1FAE5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AuthFlowPalette.primary,
            minimumSize: const Size(44, 44),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFF8FAFC),
          selectedColor: AuthFlowPalette.primary.withValues(alpha: 0.14),
          checkmarkColor: AuthFlowPalette.primary,
          labelStyle: const TextStyle(
            color: AuthFlowPalette.textSecondary,
            fontWeight: FontWeight.w700,
          ),
          secondaryLabelStyle: const TextStyle(
            color: AuthFlowPalette.primary,
            fontWeight: FontWeight.w800,
          ),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
