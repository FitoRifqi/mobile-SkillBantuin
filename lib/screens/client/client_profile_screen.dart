import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/auth_flow_widgets.dart';
import '../role_selection_screen.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  static final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Profil Client'),
        actions: [
          IconButton(
            tooltip: 'Edit profil',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
        children: [
          const _ClientProfileHero(),
          const SizedBox(height: 16),
          const _ProfileCompletionCard(),
          const SizedBox(height: 16),
          const _ClientInsightGrid(),
          const SizedBox(height: 18),
          const _SectionTitle(
            title: 'Informasi Client',
            subtitle: 'Info yang dilihat freelancer.',
          ),
          const SizedBox(height: 10),
          const _InfoPanel(
            children: [
              _InfoTile(
                icon: Icons.business_center_outlined,
                title: 'Bidang',
                subtitle: 'Teknologi Informasi',
              ),
              _InfoTile(
                icon: Icons.location_on_outlined,
                title: 'Lokasi',
                subtitle: 'Jakarta, Indonesia',
              ),
              _InfoTile(
                icon: Icons.calendar_today_outlined,
                title: 'Bergabung',
                subtitle: 'Januari 2024',
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _SectionTitle(
            title: 'Pembayaran',
            subtitle: 'Metode pembayaran aktif.',
          ),
          const SizedBox(height: 10),
          const _InfoPanel(
            children: [
              _InfoTile(
                icon: Icons.credit_card_rounded,
                title: 'Visa',
                subtitle: '•••• 4242',
                trailing: _StatusPill(label: 'Utama'),
              ),
              _InfoTile(
                icon: Icons.account_balance_outlined,
                title: 'Bank BCA',
                subtitle: '1234567890',
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _SectionTitle(
            title: 'Keamanan & Preferensi',
            subtitle: 'Atur keamanan akun.',
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
                icon: Icons.phone_iphone_rounded,
                title: 'Nomor HP',
                subtitle: 'Perlu diperbarui',
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              _InfoTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifikasi',
                subtitle: 'Deadline dan penawaran aktif',
                trailing: Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 18),
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

class _ClientProfileHero extends StatelessWidget {
  const _ClientProfileHero();

  @override
  Widget build(BuildContext context) {
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
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(24),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.24)),
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'PT Maju Bersama',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'info@majubersama.com',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        height: 1.4,
                      ),
                    ),
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
              _HeroBadge(icon: Icons.star_rounded, label: '4.8 rating'),
              _HeroBadge(icon: Icons.task_alt_rounded, label: '12 proyek'),
              _HeroBadge(icon: Icons.flash_on_rounded, label: 'Fast response'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileCompletionCard extends StatelessWidget {
  const _ProfileCompletionCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoPanel(
      children: [
        _ProgressTile(
          title: 'Kelengkapan profil 88%',
          subtitle: 'Tambahkan nomor HP aktif.',
          progress: 0.88,
        ),
      ],
    );
  }
}

class _ClientInsightGrid extends StatelessWidget {
  const _ClientInsightGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '12',
            label: 'Proyek',
            icon: Icons.assignment_outlined,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: '9',
            label: 'Selesai',
            icon: Icons.done_all_rounded,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: '4.8',
            label: 'Rating',
            icon: Icons.star_rounded,
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
                  Icons.insights_rounded,
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

class _StatusPill extends StatelessWidget {
  final String label;

  const _StatusPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AuthFlowPalette.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AuthFlowPalette.primary,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
