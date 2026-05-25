import 'package:flutter/material.dart';

import 'app_ui.dart';
import 'auth_flow_widgets.dart';

class DashboardScaffold extends StatelessWidget {
  final Widget body;

  const DashboardScaffold({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUi.pageBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: AppUi.pagePadding,
              sliver: SliverToBoxAdapter(child: body),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHeroCard extends StatelessWidget {
  final String greeting;
  final String title;
  final String description;
  final String primaryActionLabel;
  final IconData primaryActionIcon;
  final VoidCallback onPrimaryAction;
  final List<DashboardQuickAction> quickActions;
  final Widget trailing;

  const DashboardHeroCard({
    super.key,
    required this.greeting,
    required this.title,
    required this.description,
    required this.primaryActionLabel,
    required this.primaryActionIcon,
    required this.onPrimaryAction,
    required this.quickActions,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;

        return Container(
          padding: EdgeInsets.all(compact ? 20 : 24),
          decoration: BoxDecoration(
            gradient: AuthFlowPalette.backgroundGradient,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF047857).withValues(alpha: 0.22),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (compact) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroCopy(
                      greeting: greeting,
                      title: title,
                      description: description,
                    ),
                    const SizedBox(height: 18),
                    trailing,
                  ],
                ),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _HeroCopy(
                        greeting: greeting,
                        title: title,
                        description: description,
                      ),
                    ),
                    const SizedBox(width: 16),
                    trailing,
                  ],
                ),
              ],
              const SizedBox(height: 22),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: onPrimaryAction,
                    icon: Icon(primaryActionIcon, size: 18),
                    label: Text(primaryActionLabel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AuthFlowPalette.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      minimumSize: const Size(132, 48),
                    ),
                  ),
                  ...quickActions.map(
                    (action) => OutlinedButton.icon(
                      onPressed: action.onTap,
                      icon: Icon(action.icon, size: 18),
                      label: Text(action.label),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.28),
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        minimumSize: const Size(112, 48),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroCopy extends StatelessWidget {
  final String greeting;
  final String title;
  final String description;

  const _HeroCopy({
    required this.greeting,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.78),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            height: 1.15,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.82),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class DashboardQuickAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardQuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

class DashboardSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const DashboardSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AuthFlowPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AuthFlowPalette.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              foregroundColor: AuthFlowPalette.primary,
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class DashboardMetricGrid extends StatelessWidget {
  final List<DashboardMetricData> metrics;

  const DashboardMetricGrid({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 900 ? 4 : (width >= 560 ? 2 : 1);
        const spacing = 12.0;
        final itemWidth = columns == 1
            ? width
            : (width - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: metrics
              .map(
                (metric) => SizedBox(
                  width: itemWidth,
                  child: _MetricCard(metric: metric),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final DashboardMetricData metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: metric.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(metric.icon, color: metric.color),
          ),
          const SizedBox(height: 18),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AuthFlowPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.label,
            style: const TextStyle(
              color: AuthFlowPalette.textSecondary,
            ),
          ),
          if (metric.helperText != null) ...[
            const SizedBox(height: 6),
            Text(
              metric.helperText!,
              style: TextStyle(
                fontSize: 12,
                color: metric.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DashboardMetricData {
  final String label;
  final String value;
  final String? helperText;
  final IconData icon;
  final Color color;

  const DashboardMetricData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.helperText,
  });
}

class DashboardPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const DashboardPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
