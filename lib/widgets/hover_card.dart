import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pressable.dart';

/// Rounded card with a soft border that gains a subtle glow + lift on hover
/// (or keyboard focus, when tappable).
class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.radius = 18,
    this.padding,
    this.isLink = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final bool isLink;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;

  Widget _card(bool highlighted) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, highlighted ? -3 : 0, 0),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(
          color: highlighted ? AppColors.cyan : AppColors.border,
          width: highlighted ? 1.2 : 1,
        ),
        boxShadow: highlighted
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.16),
                  blurRadius: 26,
                  spreadRadius: -6,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap != null) {
      return Pressable(
        onTap: widget.onTap,
        isLink: widget.isLink,
        builder: (context, highlighted) => _card(highlighted),
      );
    }
    // Non-interactive cards still lift on hover, but are not focusable.
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: _card(_hovered),
    );
  }
}
