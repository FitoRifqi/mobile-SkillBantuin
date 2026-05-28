import 'package:flutter/material.dart';

import '../../models/user_role.dart';
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
  final _bankController = TextEditingController();
  final _accountController = TextEditingController();

  bool _offerNotifications = true;
  bool _chatNotifications = true;
  bool _deadlineNotifications = true;

  bool get _isClient => widget.userRole == UserRole.client;

  @override
  void initState() {
    super.initState();
    if (_isClient) {
      _nameController.text = 'PT Maju Bersama';
      _emailController.text = 'info@majubersama.com';
      _phoneController.text = '0812 3456 7890';
      _locationController.text = 'Jakarta, Indonesia';
      _headlineController.text = 'Teknologi Informasi';
      _bioController.text =
          'Membutuhkan bantuan cepat untuk kebutuhan desain, data, dan pengembangan aplikasi.';
      _bankController.text = 'Bank BCA';
      _accountController.text = '1234567890';
    } else {
      _nameController.text = 'Ahmad Rizki';
      _emailController.text = 'ahmad.rizki@email.com';
      _phoneController.text = '0813 4567 8901';
      _locationController.text = 'Bandung, Indonesia';
      _headlineController.text = 'Full Stack Developer';
      _bioController.text =
          'Freelancer Flutter dan Laravel dengan pengalaman membangun app, dashboard, dan payment flow.';
      _primarySkillController.text =
          'Flutter & Dart, Laravel & PHP, UI/UX Design, API Integration';
      _portfolioController.text =
          'E-Commerce App, Company Profile Website, Mobile Banking UI/UX';
      _bankController.text = 'Bank BCA';
      _accountController.text = '9876543210';
    }
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
    _bankController.dispose();
    _accountController.dispose();
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
      body: Form(
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
                    title: _isClient ? 'Informasi Client' : 'Informasi Publik',
                    subtitle: _isClient
                        ? 'Data ini membantu freelancer memahami kebutuhanmu.'
                        : 'Data ini muncul saat client melihat profilmu.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: _isClient ? 'Nama perusahaan/client' : 'Nama',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _headlineController,
                    decoration: InputDecoration(
                      labelText: _isClient ? 'Bidang' : 'Headline profesi',
                      prefixIcon: const Icon(Icons.business_center_outlined),
                    ),
                    validator: _requiredValidator,
                  ),
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
                    subtitle: 'Dipakai untuk verifikasi dan komunikasi akun.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!value.contains('@')) return 'Email belum valid';
                      return null;
                    },
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
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Lokasi',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    validator: _requiredValidator,
                  ),
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
                        prefixIcon: Icon(Icons.workspace_premium_outlined),
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
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(
                    title: _isClient ? 'Pembayaran' : 'Pencairan Dana',
                    subtitle: _isClient
                        ? 'Metode pembayaran default untuk Midtrans.'
                        : 'Rekening tujuan pencairan saldo freelancer.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bankController,
                    decoration: const InputDecoration(
                      labelText: 'Nama bank',
                      prefixIcon: Icon(Icons.account_balance_outlined),
                    ),
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _accountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _isClient
                          ? 'Nomor akun pembayaran'
                          : 'Nomor rekening',
                      prefixIcon: const Icon(Icons.credit_card_rounded),
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
                    title: 'Preferensi Notifikasi',
                    subtitle: 'Atur update penting yang ingin diterima.',
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _offerNotifications,
                    onChanged: (value) {
                      setState(() => _offerNotifications = value);
                    },
                    title:
                        Text(_isClient ? 'Penawaran baru' : 'Update penawaran'),
                    subtitle: const Text('Status offer dan negosiasi.'),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _chatNotifications,
                    onChanged: (value) {
                      setState(() => _chatNotifications = value);
                    },
                    title: const Text('Chat'),
                    subtitle: const Text('Pesan baru dari client/freelancer.'),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _deadlineNotifications,
                    onChanged: (value) {
                      setState(() => _deadlineNotifications = value);
                    },
                    title: const Text('Deadline & pembayaran'),
                    subtitle: const Text('Reminder tugas dan status payment.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Simpan Profil'),
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

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil tersimpan. Nanti data ini dikirim ke Laravel.'),
      ),
    );
    Navigator.pop(context);
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
