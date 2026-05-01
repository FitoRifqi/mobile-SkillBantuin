import 'package:flutter/material.dart';

import '../models/auth_flow_mode.dart';
import '../models/user_role.dart';
import '../services/auth_service.dart';
import '../widgets/auth_flow_widgets.dart';
import 'main_navigation_screen.dart';
import 'role_selection_screen.dart';

class RegisterScreen extends StatefulWidget {
  final UserRole selectedRole;

  const RegisterScreen({
    super.key,
    required this.selectedRole,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  late final UserRole _selectedRole;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _keepSignedIn = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.selectedRole;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.register(
        fullName: _fullNameController.text,
        email: _emailController.text,
        username: _usernameController.text,
        phoneNumber: _phoneController.text,
        password: _passwordController.text,
        role: _selectedRole,
        keepSignedIn: _keepSignedIn,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akun demo berhasil dibuat. Selamat datang di SkillBantuin!'),
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
      _showInfoMessage('Terjadi kendala saat membuat akun. Coba lagi sebentar.');
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
                            'Daftar ke SkillBantuin',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            isClient
                                ? 'Siapkan akun client untuk membuat dan mengelola permintaan bantuan.'
                                : 'Siapkan akun freelancer untuk mencari peluang dan mengajukan penawaran.',
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white.withValues(alpha: 0.92),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Pendaftaran ini masih mock untuk demo UAS. Data tersimpan lokal bila opsi tetap masuk aktif.',
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
                          'Buat akun baru',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AuthFlowPalette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Lengkapi data sederhana dulu. Struktur ini nanti mudah disambungkan ke API Laravel.',
                          style: TextStyle(
                            color: AuthFlowPalette.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),
                        TextFormField(
                          controller: _fullNameController,
                          decoration: _buildInputDecoration(
                            hintText: 'Nama lengkap',
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama lengkap tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _buildInputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icons.email_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            if (!value.contains('@')) {
                              return 'Format email belum valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _usernameController,
                          decoration: _buildInputDecoration(
                            hintText: 'Username',
                            prefixIcon: Icons.alternate_email_rounded,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Username tidak boleh kosong';
                            }
                            if (value.trim().length < 4) {
                              return 'Username minimal 4 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: _buildInputDecoration(
                            hintText: 'Nomor HP',
                            prefixIcon: Icons.phone_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nomor HP tidak boleh kosong';
                            }
                            if (value.trim().length < 10) {
                              return 'Nomor HP minimal 10 digit';
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: _buildInputDecoration(
                            hintText: 'Konfirmasi password',
                            prefixIcon: Icons.verified_user_outlined,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AuthFlowPalette.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Konfirmasi password tidak boleh kosong';
                            }
                            if (value != _passwordController.text) {
                              return 'Konfirmasi password belum sama';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          value: _keepSignedIn,
                          onChanged: (value) {
                            setState(() {
                              _keepSignedIn = value ?? true;
                            });
                          },
                          activeColor: AuthFlowPalette.primary,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                            'Tetap masuk di perangkat ini',
                            style: TextStyle(
                              fontSize: 14,
                              color: AuthFlowPalette.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        AuthPrimaryButton(
                          label: _isLoading ? 'Memproses...' : 'Daftar Sekarang',
                          onPressed: _isLoading ? null : _handleRegister,
                          trailing: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(
                                  Icons.how_to_reg_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
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
                        'Sudah punya akun?',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.74),
                        ),
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
                        child: const Text('Masuk'),
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
      prefixIcon: Icon(prefixIcon, color: AuthFlowPalette.primary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
    );
  }

  Widget _buildSelectedRoleCard() {
    final isClient = _selectedRole == UserRole.client;

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
              isClient ? Icons.storefront_rounded : Icons.handyman_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              isClient ? 'Daftar sebagai Client' : 'Daftar sebagai Freelancer',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
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
            child: const Text('Ubah'),
          ),
        ],
      ),
    );
  }

  void _showInfoMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
