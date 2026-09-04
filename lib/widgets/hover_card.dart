import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Rounded card with a soft border that gains a subtle glow + lift on hover.
class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.radius = 18,
    this.padding,
    this.glowStrength = 1.0,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double glowStrength;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final hasTap = widget.onTap != null;
    final body = hasTap
        ? Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(widget.radius),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                padding: widget.padding,
                child: widget.child,
              ),
            ),
          )
        : Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: widget.child,
          );

    return MouseRegion(
      cursor: hasTap ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: _hovered ? AppColors.cyan : AppColors.border,
            width: _hovered ? 1.2 : 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: AppColors.cyan.withValues(
                      alpha: 0.16 * widget.glowStrength,
                    ),
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
        child: body,
      ),
    );
  }
}