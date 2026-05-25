import 'package:flutter/material.dart';

import 'auth_flow_widgets.dart';

class AppUi {
  static const Color pageBackground = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);
  static const double radius = 20;
  static const double sectionGap = 18;
  static const double cardGap = 12;
  static const EdgeInsets pagePadding = EdgeInsets.fromLTRB(16, 12, 16, 28);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);

  static List<BoxShadow> softShadow([double alpha = 0.04]) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: alpha),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ];
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = AppUi.cardPadding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppUi.radius),
        border: Border.all(color: AppUi.border.withValues(alpha: 0.65)),
        boxShadow: AppUi.softShadow(),
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppUi.radius),
        child: card,
      ),
    );
  }
}

class AppInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const AppInfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.color = AuthFlowPalette.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const AppSectionTitle({
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
                  color: AuthFlowPalette.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
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
          ),
        ),
        if (actionLabel != null && onActionTap != null) ...[
          const SizedBox(width: 10),
          TextButton(
            onPressed: onActionTap,
            child: Text(actionLabel!),
          ),
        ],
      ],
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AuthFlowPalette.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: AuthFlowPalette.primary),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AuthFlowPalette.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AuthFlowPalette.textSecondary,
              height: 1.45,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
