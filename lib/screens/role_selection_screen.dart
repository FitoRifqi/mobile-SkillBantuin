import 'package:flutter/material.dart';
import '../models/auth_flow_mode.dart';
import '../models/user_role.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../widgets/auth_flow_widgets.dart';

class RoleSelectionScreen extends StatelessWidget {
  final AuthFlowMode mode;

  const RoleSelectionScreen({
    super.key,
    this.mode = AuthFlowMode.login,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = authVerticalSpacing(context);

    return Scaffold(
      body: AuthGradientBackground(
        child: SafeArea(
          child: AuthContentContainer(
            scrollable: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacing * 0.4),
                const Center(child: AuthBrandMark(size: 96)),
                SizedBox(height: spacing),
                Text(
                  mode == AuthFlowMode.login
                      ? 'Pilih peran untuk masuk ke dashboard yang tepat'
                      : 'Pilih peran untuk mulai membuat akun',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  mode == AuthFlowMode.login
                      ? 'Role dipakai untuk menentukan alur kerja dan navigasi yang akan kamu lihat setelah login.'
                      : 'Role dipakai untuk menyiapkan form daftar dan dashboard yang sesuai kebutuhan client atau freelancer.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.65,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: spacing),
                _RoleCard(
                  title: 'Saya Client',
                  subtitle:
                      'Cari freelancer dengan cepat dan kelola kebutuhan proyek dengan rapi.',
                  icon: Icons.manage_search_rounded,
                  accentColor: const Color(0xFF93C5FD),
                  points: const [
                    'Cocok untuk yang ingin mencari bantuan profesional',
                    'Masuk untuk memposting proyek dan mengatur kandidat',
                  ],
                  onTap: () => _goToLogin(context, UserRole.client),
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  title: 'Saya Freelancer',
                  subtitle:
                      'Temukan proyek sesuai skill dan bangun profil kerja yang lebih meyakinkan.',
                  icon: Icons.work_history_rounded,
                  accentColor: const Color(0xFFBFDBFE),
                  points: const [
                    'Cocok untuk yang ingin mencari peluang kerja fleksibel',
                    'Masuk untuk melihat proyek dan mengelola lamaran',
                  ],
                  onTap: () => _goToLogin(context, UserRole.freelancer),
                ),
                SizedBox(height: spacing),
                AuthGlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          mode == AuthFlowMode.login
                              ? 'Belum punya akun? Kamu bisa lanjut ke flow daftar dengan peran yang sama.'
                              : 'Sudah punya akun? Kamu bisa balik ke flow login tanpa kehilangan pilihan peran.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.78),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoleSelectionScreen(
                            mode: mode == AuthFlowMode.login
                                ? AuthFlowMode.register
                                : AuthFlowMode.login,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      mode == AuthFlowMode.login
                          ? 'Belum punya akun? Daftar'
                          : 'Sudah punya akun? Masuk',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToLogin(BuildContext context, UserRole role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => mode == AuthFlowMode.login
            ? LoginScreen(selectedRole: role)
            : RegisterScreen(selectedRole: role),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<String> points;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.points,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AuthGlassCard(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: accentColor.withValues(alpha: 0.18),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.white.withValues(alpha: 0.78),
              ),
            ),
            const SizedBox(height: 14),
            ...points.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.74),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
