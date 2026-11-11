import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'scroll_reveal.dart';
import 'section_heading.dart';

/// Shared layout for every page section: responsive side padding, max content
/// width, and an animated [SectionHeading] above [child].
class SectionShell extends StatelessWidget {
  const SectionShell({
    super.key,
    required this.heading,
    required this.child,
    this.top = 56,
    this.bottom = 56,
  });

  final SectionHeading heading;
  final Widget child;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final padding = contentPaddingOf(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, top, padding, bottom),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollReveal(child: heading),
              const SizedBox(height: 32),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded gradient square holding a white icon.
class GradientIconBox extends StatelessWidget {
  const GradientIconBox({super.key, required this.icon, this.size = 56});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.27),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.28),
            blurRadius: 20,
            spreadRadius: -8,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: size * 0.47),
    );
  }
}

/// Vertical list of "▸ text" rows.
class BulletList extends StatelessWidget {
  const BulletList(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall!.copyWith(
      color: AppColors.textSecondary,
      height: 1.5,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Text(
                    '▸ ',
                    style: AppText.mono(13, color: AppColors.cyan, height: 1.5),
                  ),
                ),
                Expanded(child: Text(items[i], style: style)),
              ],
            ),
          ),
      ],
    );
  }
}

/// Small calendar icon + period text.
class PeriodLabel extends StatelessWidget {
  const PeriodLabel(this.period, {super.key});

  final String period;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today_rounded,
          size: 13,
          color: AppColors.textMuted,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            period,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.mono(12, letterSpacing: 0.6),
          ),
        ),
      ],
    );
  }
}
