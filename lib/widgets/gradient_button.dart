import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Gradient pill button with a soft outer glow. Mirrors border when [outlined].
class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.outlined = false,
    this.compact = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool compact;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final radius = widget.compact ? 10.0 : 12.0;
    final horizontal = widget.compact ? 18.0 : 24.0;
    final vertical = widget.compact ? 11.0 : 14.0;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 17, color: _fgColor(enabled)),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: AppText.mono(
              widget.compact ? 12.5 : 13.5,
              color: _fgColor(enabled),
              letterSpacing: 0.8,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: enabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -1.5 : 0, 0),
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: _bgGradient(enabled),
            border: widget.outlined && enabled
                ? Border.all(color: AppColors.cyan, width: 1.2)
                : null,
            boxShadow: enabled && _hovered
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.35),
                      blurRadius: 22,
                      spreadRadius: -4,
                    ),
                  ]
                : enabled
                    ? [
                        BoxShadow(
                          color: AppColors.blue.withValues(alpha: 0.28),
                          blurRadius: 18,
                          spreadRadius: -6,
                        ),
                      ]
                    : null,
          ),
          child: content,
        ),
      ),
    );
  }

  Color _fgColor(bool enabled) {
    if (!enabled) return AppColors.textMuted;
    if (widget.outlined) return AppColors.cyan;
    return Colors.white;
  }

  Gradient? _bgGradient(bool enabled) {
    if (widget.outlined) {
      return LinearGradient(
        colors: [AppColors.surfaceAlt, AppColors.surfaceAlt],
      );
    }
    if (!enabled) {
      return LinearGradient(colors: [AppColors.surface, AppColors.surface]);
    }
    return AppColors.primaryGradient;
  }
}