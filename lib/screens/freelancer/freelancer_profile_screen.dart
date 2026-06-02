import 'package:flutter/material.dart';

import '../../models/user_role.dart';
import '../../services/auth_service.dart';
import '../../services/marketplace_service.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../role_selection_screen.dart';
import '../shared/edit_profile_screen.dart';
import '../shared/notification_screen.dart';
import 'freelancer_earnings_screen.dart';

class FreelancerProfileScreen extends StatefulWidget {
  const FreelancerProfileScreen({super.key});

  @override
  State<FreelancerProfileScreen> createState() =>
      _FreelancerProfileScreenState();
}

class _FreelancerProfileScreenState extends State<FreelancerProfileScreen> {
  static final AuthService _authService = AuthService();
  final MarketplaceService _marketplaceService = MarketplaceService();
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _marketplaceService.fetchProfile();
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = _marketplaceService.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Profil Freelancer'),
        actions: [
          IconButton(
            tooltip: 'Notifikasi',
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(
                    userRole: UserRole.freelancer,
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Edit profil',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(
                    userRole: UserRole.freelancer,
                  ),
                ),
              );
              if (mounted) _refreshProfile();
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data ?? const <String, dynamic>{};
          final freelancer = profile['freelancer'] is Map
              ? Map<String, dynamic>.from(profile['freelancer'] as Map)
              : const <String, dynamic>{};
          final skills = _splitItems(
            profile['skill']?.toString() ?? freelancer['keahlian']?.toString(),
            fallback: ['Umum'],
          );
          final portfolios = _splitItems(
            freelancer['portfolio']?.toString(),
            fallback: ['Portfolio belum diisi'],
          );

          return RefreshIndicator(
            onRefresh: () async => _refreshProfile(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
              children: [
                _FreelancerHero(profile: profile),
                const SizedBox(height: 16),
                _FreelancerStats(
                  rating: _text(freelancer['rating'], '0'),
                  experience:
                      '${_text(freelancer['pengalaman_tahun'], '0')} th',
                  rate: _rupiah(freelancer['harga_per_hari']),
                ),
                const SizedBox(height: 18),
                const _SectionTitle(
                  title: 'Keahlian Utama',
                  subtitle: 'Skill yang kamu tawarkan.',
                ),
                const SizedBox(height: 10),
                _SkillPanel(skills: skills),
                const SizedBox(height: 18),
                const _SectionTitle(
                  title: 'Portfolio Pilihan',
                  subtitle: 'Data portfolio dari profil Laravel.',
                ),
                const SizedBox(height: 10),
                _InfoPanel(
                  children: portfolios
                      .map(
                        (item) => _InfoTile(
                          icon: Icons.folder_copy_outlined,
                          title: item,
                          subtitle: _text(
                            profile['bio'],
                            _text(freelancer['deskripsi'], '-'),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 18),
                const _SectionTitle(
                  title: 'Informasi Akun',
                  subtitle: 'Data yang tersimpan di Laravel.',
                ),
                const SizedBox(height: 10),
                _InfoPanel(
                  children: [
                    _InfoTile(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: _text(profile['email'], '-'),
                    ),
                    _InfoTile(
                      icon: Icons.phone_iphone_rounded,
                      title: 'Nomor HP',
                      subtitle: _text(
                        profile['phone'],
                        _text(freelancer['no_telepon'], '-'),
                      ),
                    ),
                    _InfoTile(
                      icon: Icons.notes_outlined,
                      title: 'Deskripsi',
                      subtitle: _text(
                        profile['bio'],
                        _text(freelancer['deskripsi'], '-'),
                      ),
                    ),
                    _InfoTile(
                      icon: Icons.verified_user_outlined,
                      title: 'Status',
                      subtitle: _text(freelancer['status'], '-'),
                      trailing: const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FreelancerEarningsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.savings_rounded),
                  label: const Text('Lihat Pendapatan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AuthFlowPalette.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _handleLogout(context),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _text(dynamic value, String fallback) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty || text == '-') return fallback;
    return text;
  }

  static List<String> _splitItems(String? raw,
      {required List<String> fallback}) {
    final items = (raw ?? '')
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    return items.isEmpty ? fallback : items;
  }

  static String _rupiah(dynamic value) {
    final amount = double.tryParse(value?.toString() ?? '')?.round() ?? 0;
    if (amount == 0) return 'Rp0';
    final text = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp$buffer';
  }

  static Future<void> _handleLogout(BuildContext context) async {
    await _authService.logout();
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  }
}

class _FreelancerHero extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _FreelancerHero({required this.profile});

  @override
  Widget build(BuildContext context) {
    final freelancer = profile['freelancer'] is Map
        ? Map<String, dynamic>.from(profile['freelancer'] as Map)
        : const <String, dynamic>{};
    final displayName = profile['name']?.toString() ??
        freelancer['nama_lengkap']?.toString() ??
        'Freelancer';
    final subtitle = profile['skill']?.toString() ??
        freelancer['keahlian']?.toString() ??
        'Umum';
    final rating = freelancer['rating']?.toString() ?? '0';
    final experience = freelancer['pengalaman_tahun']?.toString() ?? '0';
    final rate = _FreelancerProfileScreenState._rupiah(
      freelancer['harga_per_hari'],
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AuthFlowPalette.backgroundGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AuthFlowPalette.primary.withValues(alpha: 0.22),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.24)),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const _OnlinePill(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroBadge(icon: Icons.star_rounded, label: '$rating rating'),
              _HeroBadge(icon: Icons.work_rounded, label: '$experience tahun'),
              _HeroBadge(icon: Icons.payments_rounded, label: rate),
            ],
          ),
        ],
      ),
    );
  }
}

class _FreelancerStats extends StatelessWidget {
  final String rating;
  final String experience;
  final String rate;

  const _FreelancerStats({
    required this.rating,
    required this.experience,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: rating,
            label: 'Rating',
            icon: Icons.star_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: experience,
            label: 'Pengalaman',
            icon: Icons.timeline_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: rate,
            label: 'Per hari',
            icon: Icons.payments_rounded,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
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
            fontWeight: FontWeight.w800,
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

class _SkillPanel extends StatelessWidget {
  final List<String> skills;

  const _SkillPanel({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: skills
            .map(
              (skill) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: AuthFlowPalette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    color: AuthFlowPalette.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final List<Widget> children;

  const _InfoPanel({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AuthFlowPalette.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AuthFlowPalette.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AuthFlowPalette.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AuthFlowPalette.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AuthFlowPalette.primary, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AuthFlowPalette.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AuthFlowPalette.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnlinePill extends StatelessWidget {
  const _OnlinePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: Color(0xFF86EFAC), size: 9),
          SizedBox(width: 7),
          Text(
            'Siap menerima proyek',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
