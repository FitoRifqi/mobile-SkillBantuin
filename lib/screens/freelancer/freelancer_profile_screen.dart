import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../models/user_role.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../role_selection_screen.dart';
import '../shared/edit_profile_screen.dart';
import '../shared/notification_screen.dart';
import 'freelancer_earnings_screen.dart';

class FreelancerProfileScreen extends StatelessWidget {
  const FreelancerProfileScreen({super.key});

  static final AuthService _authService = AuthService();

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(
                    userRole: UserRole.freelancer,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
        children: [
          _FreelancerHero(),
          const SizedBox(height: 16),
          const _ReadinessCard(),
          const SizedBox(height: 16),
          const _FreelancerStats(),
          const SizedBox(height: 18),
          const _SectionTitle(
            title: 'Keahlian Utama',
            subtitle: 'Skill yang kamu tawarkan.',
          ),
          const SizedBox(height: 10),
          const _SkillPanel(
            skills: [
              'Flutter & Dart',
              'Laravel & PHP',
              'UI/UX Design',
              'Database Management',
              'API Integration',
              'Responsive Layout',
            ],
          ),
          const SizedBox(height: 18),
          const _SectionTitle(
            title: 'Portfolio Pilihan',
            subtitle: 'Karya terbaikmu.',
          ),
          const SizedBox(height: 10),
          const _InfoPanel(
            children: [
              _InfoTile(
                icon: Icons.phone_android_rounded,
                title: 'E-Commerce App',
                subtitle: 'Flutter, payment flow, dan dashboard admin',
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              _InfoTile(
                icon: Icons.web_asset_rounded,
                title: 'Company Profile Website',
                subtitle: 'Landing page responsif untuk UMKM',
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              _InfoTile(
                icon: Icons.design_services_outlined,
                title: 'Mobile Banking UI/UX',
                subtitle: 'Prototype flow transfer dan pembayaran',
                trailing: Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _SectionTitle(
            title: 'Pengaturan Akun',
            subtitle: 'Verifikasi dan pencairan dana.',
          ),
          const SizedBox(height: 10),
          const _InfoPanel(
            children: [
              _InfoTile(
                icon: Icons.verified_user_outlined,
                title: 'Verifikasi email',
                subtitle: 'Sudah aktif',
                trailing:
                    Icon(Icons.check_circle_rounded, color: Color(0xFF059669)),
              ),
              _InfoTile(
                icon: Icons.badge_outlined,
                title: 'Verifikasi KTP',
                subtitle: 'Siap untuk proyek bernilai tinggi',
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              _InfoTile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Metode penarikan dana',
                subtitle: 'Bank BCA •••• 7890',
                trailing: Icon(Icons.chevron_right_rounded),
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
  _FreelancerHero();

  final SessionService _sessionService = SessionService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser?>(
      future: _sessionService.getSession(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final displayName = user?.fullName.isNotEmpty == true
            ? user!.fullName
            : 'Freelancer'
                .toUpperCase();
        final subtitle = user?.username.isNotEmpty == true
            ? '@${user!.username}'
            : 'Full Stack Developer';

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
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroBadge(icon: Icons.star_rounded, label: '4.9 rating'),
              _HeroBadge(icon: Icons.work_rounded, label: '12 proyek'),
              _HeroBadge(icon: Icons.payments_rounded, label: 'Rp2,4 jt'),
            ],
          ),
        ],
      ),
    );
      },
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoPanel(
      children: [
        _ProgressTile(
          title: 'Profile strength 82%',
          subtitle: 'Tambahkan portfolio terbaru.',
          progress: 0.82,
        ),
      ],
    );
  }
}

class _FreelancerStats extends StatelessWidget {
  const _FreelancerStats();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '98%',
            label: 'Tepat waktu',
            icon: Icons.schedule_rounded,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: '7',
            label: 'Aktif',
            icon: Icons.assignment_turned_in_rounded,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: '1h',
            label: 'Respons',
            icon: Icons.bolt_rounded,
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

class _ProgressTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const _ProgressTile({
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AuthFlowPalette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AuthFlowPalette.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AuthFlowPalette.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AuthFlowPalette.primary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: AuthFlowPalette.textSecondary,
              height: 1.45,
            ),
          ),
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
