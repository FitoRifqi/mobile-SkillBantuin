import 'package:flutter/material.dart';

import '../../models/freelancer_model.dart';
import '../../services/freelancer_service.dart';
import '../../utils/task_ui_utils.dart';

class HelperDetailScreen extends StatefulWidget {
  final FreelancerModel freelancer;

  const HelperDetailScreen({
    super.key,
    required this.freelancer,
  });

  @override
  State<HelperDetailScreen> createState() => _HelperDetailScreenState();
}

class _HelperDetailScreenState extends State<HelperDetailScreen> {
  final _freelancerService = FreelancerService();
  late FreelancerModel _freelancer;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _freelancer = widget.freelancer;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final detail = await _freelancerService
          .getFreelancerDetail(_freelancer.id.toString());
      if (!mounted) return;
      setState(() {
        _freelancer = detail;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Detail helper belum bisa dimuat dari server.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Helper')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_isLoading || _errorMessage != null) ...[
            _HelperStateCard(
              isLoading: _isLoading,
              message: _isLoading ? 'Memuat detail helper...' : _errorMessage!,
              onRetry: _errorMessage == null ? null : _loadDetail,
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white24,
                  child:
                      Icon(Icons.person_rounded, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 16),
                Text(
                  _freelancer.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _freelancer.skill,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.84),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Ringkasan Helper',
            children: [
              _InfoRow(label: 'Rating', value: _freelancer.rating.toString()),
              _InfoRow(
                label: 'Proyek selesai',
                value: '${_freelancer.completedProjects} proyek',
              ),
              _InfoRow(
                label: 'Mulai dari',
                value: formatRupiah(_freelancer.baseRate),
              ),
              _InfoRow(
                label: 'Waktu respon',
                value: _freelancer.responseTime.isEmpty
                    ? '< 1 jam'
                    : _freelancer.responseTime,
              ),
              if (_freelancer.email.isNotEmpty)
                _InfoRow(label: 'Email', value: _freelancer.email),
              if (_freelancer.phone.isNotEmpty)
                _InfoRow(label: 'Telepon', value: _freelancer.phone),
            ],
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Bio',
            children: [
              Text(
                _freelancer.bio.isEmpty
                    ? 'Helper ini belum menambahkan bio.'
                    : _freelancer.bio,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelperStateCard extends StatelessWidget {
  final bool isLoading;
  final String message;
  final VoidCallback? onRetry;

  const _HelperStateCard({
    required this.isLoading,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            )
          else
            const Icon(Icons.error_outline_rounded, color: Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 116,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
