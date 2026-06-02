import 'package:flutter/material.dart';

import '../../models/user_role.dart';
import '../../services/marketplace_service.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/auth_flow_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  final UserRole userRole;

  const EditProfileScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _headlineController = TextEditingController();
  final _bioController = TextEditingController();
  final _primarySkillController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _rateController = TextEditingController();
  final _experienceController = TextEditingController();
  final _marketplaceService = MarketplaceService();

  bool _isLoadingProfile = true;
  bool _isSaving = false;

  bool get _isClient => widget.userRole == UserRole.client;

  @override
  void initState() {
    super.initState();
    if (_isClient) {
      _headlineController.text = 'Umum';
    } else {
      _headlineController.text = 'Umum';
      _primarySkillController.text = 'Umum';
      _rateController.text = '0';
      _experienceController.text = '0';
    }
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _headlineController.dispose();
    _bioController.dispose();
    _primarySkillController.dispose();
    _portfolioController.dispose();
    _rateController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUi.pageBackground,
      appBar: AppBar(
        title:
            Text(_isClient ? 'Edit Profil Client' : 'Edit Profil Freelancer'),
      ),
      body: _isLoadingProfile
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: AppUi.pagePadding,
                children: [
                  _EditProfileHero(isClient: _isClient),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(
                          title: _isClient
                              ? 'Informasi Client'
                              : 'Informasi Publik',
                          subtitle: _isClient
                              ? 'Data ini membantu freelancer memahami kebutuhanmu.'
                              : 'Data ini muncul saat client melihat profilmu.',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText:
                                _isClient ? 'Nama perusahaan/client' : 'Nama',
                            prefixIcon:
                                const Icon(Icons.person_outline_rounded),
                          ),
                          validator: _requiredValidator,
                        ),
                        if (_isClient) ...[
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _headlineController,
                            decoration: const InputDecoration(
                              labelText: 'Bidang usaha',
                              prefixIcon: Icon(Icons.business_center_outlined),
                            ),
                            validator: _requiredValidator,
                          ),
                        ],
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _bioController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Bio singkat',
                            prefixIcon: Icon(Icons.notes_outlined),
                            alignLabelWithHint: true,
                          ),
                          validator: _requiredValidator,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel(
                          title: 'Kontak',
                          subtitle:
                              'Dipakai untuk verifikasi dan komunikasi akun.',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Email login',
                            prefixIcon: Icon(Icons.email_outlined),
                            helperText:
                                'Email mengikuti akun login dan tidak diedit dari profil.',
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Nomor HP',
                            prefixIcon: Icon(Icons.phone_iphone_rounded),
                          ),
                          validator: _requiredValidator,
                        ),
                        if (_isClient) ...[
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              labelText: 'Alamat/Lokasi',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                            validator: _requiredValidator,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!_isClient) ...[
                    const SizedBox(height: 16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SectionLabel(
                            title: 'Skill & Portfolio',
                            subtitle: 'Pisahkan beberapa item dengan koma.',
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _primarySkillController,
                            minLines: 2,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Skill utama',
                              prefixIcon:
                                  Icon(Icons.workspace_premium_outlined),
                              alignLabelWithHint: true,
                            ),
                            validator: _requiredValidator,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _portfolioController,
                            minLines: 2,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Portfolio pilihan',
                              prefixIcon: Icon(Icons.folder_copy_outlined),
                              alignLabelWithHint: true,
                            ),
                            validator: _requiredValidator,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _rateController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Harga per hari',
                              prefixIcon: Icon(Icons.payments_outlined),
                              prefixText: 'Rp ',
                            ),
                            validator: (value) {
                              final parsed = _parseInt(value);
                              if (parsed == null || parsed < 0) {
                                return 'Harga per hari wajib berupa angka';
                              }
                              if (parsed > 99999999) {
                                return 'Maksimal Rp99.999.999';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _experienceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Pengalaman tahun',
                              prefixIcon: Icon(Icons.timeline_outlined),
                            ),
                            validator: (value) {
                              final parsed = _parseInt(value);
                              if (parsed == null || parsed < 0) {
                                return 'Pengalaman wajib berupa angka';
                              }
                              if (parsed > 80) {
                                return 'Pengalaman maksimal 80 tahun';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveProfile,
                    icon: const Icon(Icons.save_outlined, size: 18),
                    label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Profil'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field ini wajib diisi';
    }
    return null;
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _marketplaceService.fetchProfile();
      if (!mounted) return;
      final client = profile['client'] is Map
          ? Map<String, dynamic>.from(profile['client'] as Map)
          : <String, dynamic>{};
      final freelancer = profile['freelancer'] is Map
          ? Map<String, dynamic>.from(profile['freelancer'] as Map)
          : <String, dynamic>{};

      setState(() {
        _nameController.text = profile['name']?.toString() ??
            client['nama_perusahaan']?.toString() ??
            freelancer['nama_lengkap']?.toString() ??
            _nameController.text;
        _emailController.text =
            profile['email']?.toString() ?? _emailController.text;
        _phoneController.text = profile['phone']?.toString() ??
            client['no_telepon']?.toString() ??
            freelancer['no_telepon']?.toString() ??
            _phoneController.text;
        _locationController.text = _isClient
            ? (client['alamat']?.toString() ?? _locationController.text)
            : _locationController.text;
        _headlineController.text = _isClient
            ? (profile['company']?.toString() ??
                client['bidang_usaha']?.toString() ??
                _headlineController.text)
            : (profile['skill']?.toString() ??
                freelancer['keahlian']?.toString() ??
                _headlineController.text);
        _bioController.text = profile['bio']?.toString() ??
            freelancer['deskripsi']?.toString() ??
            _bioController.text;
        _primarySkillController.text = profile['skill']?.toString() ??
            freelancer['keahlian']?.toString() ??
            _primarySkillController.text;
        _portfolioController.text =
            freelancer['portfolio']?.toString() ?? _portfolioController.text;
        _rateController.text =
            _numberText(freelancer['harga_per_hari'], _rateController.text);
        _experienceController.text =
            freelancer['pengalaman_tahun']?.toString() ??
                _experienceController.text;
        _isLoadingProfile = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await _marketplaceService.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        skill: _isClient ? null : _primarySkillController.text.trim(),
        company: _isClient ? _headlineController.text.trim() : null,
        alamat: _isClient ? _locationController.text.trim() : null,
        portfolio: _isClient ? null : _portfolioController.text.trim(),
        hargaPerHari: _isClient ? null : _parseInt(_rateController.text),
        pengalamanTahun:
            _isClient ? null : _parseInt(_experienceController.text),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil disimpan ke Laravel.')),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  int? _parseInt(String? value) {
    if (value == null) return null;
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  String _numberText(dynamic value, String fallback) {
    if (value == null) return fallback;
    final parsed = double.tryParse(value.toString());
    if (parsed == null) return fallback;
    return parsed.round().toString();
  }
}

class _EditProfileHero extends StatelessWidget {
  final bool isClient;

  const _EditProfileHero({required this.isClient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AuthFlowPalette.backgroundGradient,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
            ),
            child: Icon(
              isClient ? Icons.apartment_rounded : Icons.person_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isClient ? 'Lengkapi profil client' : 'Perkuat profil kamu',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isClient
                      ? 'Profil yang jelas bikin freelancer cepat percaya.'
                      : 'Profil lengkap bikin peluang diterima makin tinggi.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionLabel({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AuthFlowPalette.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: AuthFlowPalette.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
