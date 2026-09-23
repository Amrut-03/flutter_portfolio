import 'package:flutter/material.dart';

import '../core/anchors.dart';
import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/hover_card.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({
    super.key,
    required this.anchors,
    required this.controller,
  });

  final Anchors anchors;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final padding = contentPaddingOf(context);

    return Container(
      key: anchors.achievements,
      padding: EdgeInsets.fromLTRB(padding, 56, padding, 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollReveal(
                controller: controller,
                child: const SectionHeading(
                  order: '05',
                  label: 'Achievements',
                  title: 'Achievements & Recognition',
                  subtitle:
                      'Open-source work, competitive programming, and other professional milestones.',
                ),
              ),
              const SizedBox(height: 32),
              _AchievementGrid(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementGrid extends StatelessWidget {
  const _AchievementGrid({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 20.0;
        final crossAxisCount = constraints.maxWidth > 800
            ? 3
            : constraints.maxWidth > 500
                ? 2
                : 1;
        final itemWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var i = 0; i < achievements.length; i++)
              SizedBox(
                width: itemWidth,
                child: ScrollReveal(
                  controller: controller,
                  delay: Duration(milliseconds: 80 * i),
                  offsetY: 14,
                  child: _AchievementCard(item: achievements[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.item});

  final Achievement item;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.25),
                  blurRadius: 18,
                  spreadRadius: -8,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(item.icon, color: Colors.white, size: 22),
          ),
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
        ],
      ),
    );
  }
}