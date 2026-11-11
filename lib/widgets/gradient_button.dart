import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pressable.dart';

/// Gradient pill button with a soft outer glow; bordered when [outlined].
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.outlined = false,
    this.compact = false,
    this.loading = false,
    this.isLink = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool compact;

  /// Shows a spinner and ignores taps.
  final bool loading;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final fg = !enabled && !loading
        ? AppColors.textMuted
        : outlined
        ? AppColors.cyan
        : Colors.white;

    return Pressable(
      onTap: enabled ? onPressed : null,
      isLink: isLink,
      builder: (context, highlighted) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, highlighted ? -1.5 : 0, 0),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 18 : 24,
          vertical: compact ? 11 : 14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(compact ? 10 : 12),
          color: outlined
              ? AppColors.surfaceAlt
              : (enabled || loading ? null : AppColors.surface),
          gradient: !outlined && (enabled || loading)
              ? AppColors.primaryGradient
              : null,
          border: outlined
              ? Border.all(
                  color: highlighted ? Colors.white : AppColors.cyan,
                  width: 1.2,
                )
              : (highlighted
                    ? Border.all(color: Colors.white, width: 1.2)
                    : null),
          boxShadow: [
            if (enabled)
              BoxShadow(
                color: highlighted
                    ? AppColors.cyan.withValues(alpha: 0.35)
                    : AppColors.blue.withValues(alpha: 0.28),
                blurRadius: highlighted ? 22 : 18,
                spreadRadius: highlighted ? -4 : -6,
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading) ...[
              SizedBox.square(
                dimension: 15,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              ),
              const SizedBox(width: 10),
            ] else if (icon != null) ...[
              Icon(icon, size: 17, color: fg),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                style: AppText.mono(
                  compact ? 12.5 : 13.5,
                  color: fg,
                  letterSpacing: 0.8,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
