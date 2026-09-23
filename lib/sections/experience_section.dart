import 'package:flutter/material.dart';

import '../core/anchors.dart';
import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/hover_card.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';
import '../widgets/tech_chip.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({
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
      key: anchors.experience,
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
                  order: '02',
                  label: 'Experience',
                  title: 'Work Experience',
                  subtitle:
                      'Professional roles building production-ready Flutter applications across industries.',
                ),
              ),
              const SizedBox(height: 32),
              for (var i = 0; i < experienceItems.length; i++)
                ScrollReveal(
                  controller: controller,
                  delay: Duration(milliseconds: 120 * i),
                  child: _ExperienceCard(item: experienceItems[i]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.item});

  final ExperienceItem item;

  @override
  Widget build(BuildContext context) {
    final device = deviceOf(context);
    final mobile = device == DeviceType.mobile;

    final header = mobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBox(icon: item.icon),
              const SizedBox(height: 18),
              _Content(item: item),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBox(icon: item.icon),
              const SizedBox(width: 22),
              Expanded(child: _Content(item: item)),
            ],
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: HoverCard(
        padding: const EdgeInsets.all(24),
        child: header,
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: -8,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.item});

  final ExperienceItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              item.role,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontFamily: AppText.displayFont),
            ),
            TechChip(item.mode, dotColor: AppColors.cyan),
          ],
        ),
        const SizedBox(height: 6),
        Text(item.company, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 13, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                item.period,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.mono(12, letterSpacing: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < item.bullets.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == item.bullets.length - 1 ? 0 : 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('▸ ',
                    style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 13,
                        fontFamily: AppText.monoFont,
                        height: 1.5)),
                Expanded(
                  child: Text(
                    item.bullets[i],
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}