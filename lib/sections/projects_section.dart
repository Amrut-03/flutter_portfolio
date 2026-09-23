import 'package:flutter/material.dart';

import '../core/anchors.dart';
import '../core/open.dart';
import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hover_card.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';
import '../widgets/tech_chip.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({
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
      key: anchors.projects,
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
                  order: '04',
                  label: 'Projects',
                  title: 'Featured Work',
                ),
              ),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final spacing = 24.0;
                  final isWide = constraints.maxWidth > 700;
                  final itemWidth = isWide
                      ? (constraints.maxWidth - spacing) / 2
                      : constraints.maxWidth;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      for (final project in projects)
                        SizedBox(
                          width: itemWidth,
                          child: ScrollReveal(
                            controller: controller,
                            duration: const Duration(milliseconds: 800),
                            child: _ProjectCard(project: project),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project});

  final Project project;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final visibleBullets = _expanded ? p.bullets : p.bullets.take(2).toList();
    final canExpand = p.bullets.length > 2;

    return HoverCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + title header.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
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
                child: Icon(p.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontFamily: AppText.displayFont),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      p.subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tech tags.
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final tag in p.tags)
                TechChip(tag, dotColor: AppColors.dotPalette[tag.hashCode.abs() % AppColors.dotPalette.length]),
            ],
          ),
          const SizedBox(height: 18),
          // Bullets (collapsed = 2, expanded = all) with a See More / See
          // Less toggle link.
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < visibleBullets.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: i == visibleBullets.length - 1 ? 2 : 8),
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
                            visibleBullets[i],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (canExpand)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: InkWell(
                      onTap: _toggle,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _expanded ? 'See Less' : 'See More',
                            style: AppText.mono(12,
                                color: AppColors.cyan, weight: FontWeight.w600),
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
                  ),
              ],
            ),
          ),
        if (p.codeAvailable && p.githubUrl != null) ...[
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: GradientButton(
              label: 'View Code',
              icon: Icons.launch_rounded,
              compact: true,
              onPressed: () => openUrl(p.githubUrl!),
            ),
          ),
        ],
      ],
      ),
    );
  }
}