import 'package:flutter/material.dart';

import '../core/open.dart';
import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hover_card.dart';
import '../widgets/pressable.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';
import '../widgets/section_shell.dart';
import '../widgets/tech_chip.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      heading: const SectionHeading(
        order: '04',
        label: 'Projects',
        title: 'Featured Work',
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 24.0;
          final isWide = constraints.maxWidth > 700;
          final half = isWide
              ? (constraints.maxWidth - spacing) / 2
              : constraints.maxWidth;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (var i = 0; i < projects.length; i++)
                SizedBox(
                  // The first (featured) project spans the full row.
                  width: i == 0 ? constraints.maxWidth : half,
                  child: ScrollReveal(
                    duration: const Duration(milliseconds: 800),
                    child: _ProjectCard(project: projects[i]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Stable colour per tag (String.hashCode differs between VM, JS and Wasm).
Color _tagColor(String tag) {
  final sum = tag.codeUnits.fold<int>(0, (a, b) => a + b);
  return AppColors.dotPalette[sum % AppColors.dotPalette.length];
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project});

  final Project project;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  static const _collapsedBullets = 2;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final canExpand = p.bullets.length > _collapsedBullets;
    final visible = _expanded
        ? p.bullets
        : p.bullets.take(_collapsedBullets).toList();
    final textTheme = Theme.of(context).textTheme;

    return HoverCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientIconBox(icon: p.icon, size: 48),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(p.title, style: textTheme.headlineSmall),
                        if (p.badge != null)
                          TechChip(p.badge!, dotColor: AppColors.statusGreen),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(p.subtitle, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final tag in p.tags) TechChip(tag, dotColor: _tagColor(tag)),
            ],
          ),
          const SizedBox(height: 18),
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: BulletList(visible),
          ),
          if (canExpand) ...[
            const SizedBox(height: 10),
            Pressable(
              onTap: () => setState(() => _expanded = !_expanded),
              builder: (context, highlighted) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _expanded ? 'See Less' : 'See More',
                    style:
                        AppText.mono(
                          12,
                          color: AppColors.cyan,
                          weight: FontWeight.w600,
                        ).copyWith(
                          decoration: highlighted
                              ? TextDecoration.underline
                              : null,
                          decorationColor: AppColors.cyan,
                        ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 18,
                    color: AppColors.cyan,
                  ),
                ],
              ),
            ),
          ],
          if (p.links.isNotEmpty) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final link in p.links)
                  GradientButton(
                    label: link.label,
                    icon: link.icon,
                    compact: true,
                    isLink: true,
                    onPressed: () => openUrl(link.url),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
