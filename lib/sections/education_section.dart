import 'package:flutter/material.dart';

import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/hover_card.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';
import '../widgets/tech_chip.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key, required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final padding = contentPaddingOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 80, padding, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollReveal(
                controller: controller,
                child: const SectionHeading(
                  order: '01',
                  label: 'Education',
                  title: 'Education',
                ),
              ),
              const SizedBox(height: 44),
              for (var i = 0; i < educationItems.length; i++)
                ScrollReveal(
                  controller: controller,
                  delay: Duration(milliseconds: 120 * i),
                  child: _EducationCard(item: educationItems[i]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.item});

  final EducationItem item;

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

  final EducationItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.degree,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontFamily: AppText.displayFont),
              ),
            ),
            const SizedBox(width: 12),
            TechChip(item.tag, dotColor: AppColors.cyan),
          ],
        ),
        const SizedBox(height: 8),
        Text(item.institute, style: Theme.of(context).textTheme.bodyMedium),
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
      ],
    );
  }
}