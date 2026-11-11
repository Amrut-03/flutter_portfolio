import 'package:flutter/material.dart';

import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/hover_card.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';
import '../widgets/section_shell.dart';
import '../widgets/tech_chip.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      top: 48,
      bottom: 32,
      heading: const SectionHeading(
        order: '01',
        label: 'Education',
        title: 'Education',
      ),
      child: Column(
        children: [
          for (var i = 0; i < educationItems.length; i++)
            ScrollReveal(
              delay: Duration(milliseconds: 120 * i),
              child: _EducationCard(item: educationItems[i]),
            ),
        ],
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.item});

  final EducationItem item;

  @override
  Widget build(BuildContext context) {
    final mobile = deviceOf(context) == DeviceType.mobile;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(item.degree, style: Theme.of(context).textTheme.headlineSmall),
            TechChip(item.tag, dotColor: AppColors.cyan),
          ],
        ),
        const SizedBox(height: 8),
        Text(item.institute, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        PeriodLabel(item.period),
      ],
    );

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
