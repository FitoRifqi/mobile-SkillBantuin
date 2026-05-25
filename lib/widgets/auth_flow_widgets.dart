import 'package:flutter/material.dart';

class AuthFlowPalette {
  static const Color primary = Color(0xFF059669);
  static const Color secondary = Color(0xFF047857);
  static const Color accent = Color(0xFF34D399);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF047857),
      Color(0xFF2DD4BF),
    ],
    stops: [0.0, 0.58, 1.0],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      primary,
      accent,
    ],
  );
}

double authMaxWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1100) return 540;
  if (width >= 700) return 500;
  return 460;
}

double authHorizontalPadding(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1100) return 32;
  if (width >= 700) return 28;
  return 20;
}

double authVerticalSpacing(BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  if (height < 700) return 18;
  if (height < 820) return 24;
  return 32;
}

class AuthGradientBackground extends StatelessWidget {
  final Widget child;

  const AuthGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AuthFlowPalette.backgroundGradient,
      ),
      child: TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            minimumSize: const Size(44, 44),
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -80,
              right: -40,
              child: _GlowCircle(
                size: 220,
                color: Color(0x33FFFFFF),
              ),
            ),
            const Positioned(
              bottom: -120,
              left: -60,
              child: _GlowCircle(
                size: 280,
                color: Color(0x227DD3FC),
              ),
            ),
            const Positioned(
              top: 180,
              left: -30,
              child: _GlowCircle(
                size: 140,
                color: Color(0x18FFFFFF),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class AuthContentContainer extends StatelessWidget {
  final Widget child;
  final bool scrollable;

  const AuthContentContainer({
    super.key,
    required this.child,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: authMaxWidth(context),
            ),
            child: child,
          ),
        );

        final padding = EdgeInsets.symmetric(
          horizontal: authHorizontalPadding(context),
          vertical: 16,
        );

        if (scrollable) {
          return SingleChildScrollView(
            padding: padding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: content,
            ),
          );
        }

        return Padding(
          padding: padding,
          child: SizedBox(
            height: constraints.maxHeight - 32,
            width: double.infinity,
            child: content,
          ),
        );
      },
    );
  }
}

class AuthGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AuthGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.04),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}

class AuthBrandMark extends StatelessWidget {
  final double size;

  const AuthBrandMark({
    super.key,
    this.size = 88,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFDCFCE7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Icon(
        Icons.handshake_rounded,
        size: size * 0.48,
        color: AuthFlowPalette.primary,
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? trailing;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AuthFlowPalette.buttonGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.white70,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 10),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class AuthOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const AuthOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.28),
        ),
        minimumSize: const Size.fromHeight(56),
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
