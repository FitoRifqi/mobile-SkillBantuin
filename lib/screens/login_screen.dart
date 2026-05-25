import 'package:flutter/material.dart';

import '../models/auth_flow_mode.dart';
import '../models/user_role.dart';
import '../services/auth_service.dart';
import '../widgets/auth_flow_widgets.dart';
import 'main_navigation_screen.dart';
import 'role_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserRole selectedRole;

  const LoginScreen({
    super.key,
    required this.selectedRole,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  late final UserRole _selectedRole;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.selectedRole;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.login(
        identity: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
        rememberMe: _rememberMe,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login berhasil. Selamat datang kembali!'),
          backgroundColor: Colors.green,
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(userRole: _selectedRole),
        ),
        (route) => false,
      );
    } on AuthException catch (error) {
      _showInfoMessage(error.message);
    } catch (_) {
      _showInfoMessage('Terjadi kendala saat login. Coba lagi sebentar.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = authVerticalSpacing(context);
    final isClient = _selectedRole == UserRole.client;

    return Scaffold(
      body: AuthGradientBackground(
        child: SafeArea(
          child: AuthContentContainer(
            scrollable: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacing * 0.4),
                Row(
                  children: [
                    const AuthBrandMark(size: 60),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Masuk ke SkillBantuin',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            isClient
                                ? 'Kelola bantuan dan freelancer.'
                                : 'Cari tugas dan kelola pekerjaan.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing * 0.8),
                _buildSelectedRoleCard(),
                const SizedBox(height: 12),
                AuthGlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.tips_and_updates_outlined,
                        color: Colors.white.withValues(alpha: 0.92),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isClient
                              ? 'Contoh akun: clientdemo / demo123'
                              : 'Contoh akun: freelancerdemo / demo123',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.78),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 28,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat datang kembali',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AuthFlowPalette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Masukkan akun untuk lanjut.',
                          style: TextStyle(
                            color: AuthFlowPalette.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),
                        TextFormField(
                          controller: _emailController,
                          decoration: _buildInputDecoration(
                            hintText: 'Username atau email',
                            prefixIcon: Icons.alternate_email_rounded,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username atau email tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: _buildInputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AuthFlowPalette.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (value.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: AuthFlowPalette.primary,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: const Text(
                                  'Ingat saya',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AuthFlowPalette.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _showInfoMessage(
                                'Fitur lupa password belum tersedia.',
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: AuthFlowPalette.primary,
                              ),
                              child: const Text('Lupa password?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AuthPrimaryButton(
                          label: _isLoading ? 'Memproses...' : 'Masuk',
                          onPressed: _isLoading ? null : _handleLogin,
                          trailing: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'atau',
                                style: TextStyle(
                                  color: AuthFlowPalette.textSecondary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSocialButton(
                                icon: Icons.g_mobiledata_rounded,
                                label: 'Google',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSocialButton(
                                icon: Icons.apple_rounded,
                                label: 'Apple',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      Text(
                        'Belum punya akun?',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.74),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RoleSelectionScreen(
                                mode: AuthFlowMode.register,
                              ),
                            ),
                          );
                        },
                        child: const Text('Daftar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RoleSelectionScreen(),
                            ),
                          );
                        },
                        child: const Text('Ganti peran'),
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

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(
        prefixIcon,
        color: AuthFlowPalette.primary,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
  }) {
    return OutlinedButton.icon(
      onPressed: () => _showInfoMessage(
        'Login dengan $label belum tersedia.',
      ),
      icon: Icon(
        icon,
        color: AuthFlowPalette.textPrimary,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: AuthFlowPalette.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildSelectedRoleCard() {
    final bool isClient = _selectedRole == UserRole.client;

    return AuthGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isClient ? Icons.search_rounded : Icons.work_outline_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isClient ? 'Mode Client' : 'Mode Freelancer',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isClient
                      ? 'Buat tugas dan pilih freelancer'
                      : 'Cari tugas dan kelola penawaran',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.74),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const RoleSelectionScreen(
                    mode: AuthFlowMode.login,
                  ),
                ),
              );
            },
            child: const Text('Ubah'),
          ),
        ],
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
