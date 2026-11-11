import 'package:flutter/material.dart';

import '../core/open.dart';
import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/hover_card.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';
import '../widgets/section_shell.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      heading: const SectionHeading(
        order: '05',
        label: 'Achievements',
        title: 'Achievements & Recognition',
        subtitle:
            'Open-source work, competitive programming, and other professional milestones.',
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 20.0;
          final columns = constraints.maxWidth > 800
              ? 3
              : constraints.maxWidth > 500
              ? 2
              : 1;
          final itemWidth =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (var i = 0; i < achievements.length; i++)
                SizedBox(
                  width: itemWidth,
                  child: ScrollReveal(
                    delay: Duration(milliseconds: 80 * i),
                    offsetY: 14,
                    child: _AchievementCard(item: achievements[i]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.item});

  final Achievement item;

  @override
  Widget build(BuildContext context) {
    final url = item.url;
    return HoverCard(
      padding: const EdgeInsets.all(20),
      onTap: url == null ? null : () => openUrl(url),
      isLink: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientIconBox(icon: item.icon, size: 46),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          if (url != null) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.open_in_new_rounded,
              size: 15,
              color: AppColors.textMuted,
            ),
          ],
        ],
      ),
    );
  }
}
