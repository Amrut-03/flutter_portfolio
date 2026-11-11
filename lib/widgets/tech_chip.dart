import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pressable.dart';

/// Small monospace pill used for tags / chips.
class TechChip extends StatelessWidget {
  const TechChip(this.label, {super.key, this.dotColor, this.onTap});

  final String label;
  final Color? dotColor;
  final VoidCallback? onTap;

  Widget _chip(bool highlighted) {
    final dot = dotColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: highlighted ? AppColors.cyan : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot != null) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dot,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: dot.withValues(alpha: 0.6), blurRadius: 6),
                ],
              ),
            ),
            const SizedBox(width: 7),
          ],
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.mono(11.5, letterSpacing: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return _chip(false);
    return Pressable(
      onTap: onTap,
      isLink: true,
      builder: (context, highlighted) => _chip(highlighted),
    );
  }
}
