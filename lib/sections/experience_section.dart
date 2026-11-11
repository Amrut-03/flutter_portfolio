import 'package:flutter/material.dart';

import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/hover_card.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';
import '../widgets/section_shell.dart';
import '../widgets/tech_chip.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      heading: const SectionHeading(
        order: '02',
        label: 'Experience',
        title: 'Work Experience',
        subtitle:
            'Professional roles building production-ready Flutter applications across industries.',
      ),
      child: Column(
        children: [
          for (var i = 0; i < experienceItems.length; i++)
            ScrollReveal(
              delay: Duration(milliseconds: 120 * i),
              child: _ExperienceCard(item: experienceItems[i]),
            ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.item});

  final ExperienceItem item;

  @override
  Widget build(BuildContext context) {
    final mobile = deviceOf(context) == DeviceType.mobile;
    final content = _Content(item: item);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: HoverCard(
        padding: const EdgeInsets.all(24),
        child: mobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientIconBox(icon: item.icon),
                  const SizedBox(height: 18),
                  content,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientIconBox(icon: item.icon),
                  const SizedBox(width: 22),
                  Expanded(child: content),
                ],
              ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.item});

  final ExperienceItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(item.role, style: textTheme.headlineSmall),
            TechChip(item.mode, dotColor: AppColors.cyan),
          ],
        ),
        const SizedBox(height: 6),
        Text(item.company, style: textTheme.bodyMedium),
        const SizedBox(height: 12),
        PeriodLabel(item.period),
        // Earlier titles at the same company (promotion path).
        for (final previous in item.previousRoles) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.north_rounded,
                size: 13,
                color: AppColors.statusGreen,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Promoted from ${previous.role} · ${previous.period}',
                  style: AppText.mono(12, letterSpacing: 0.4),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        BulletList(item.bullets),
      ],
    );
  }
}
