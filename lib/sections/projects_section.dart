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

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({
    super.key,
    required this.anchors,
    required this.controller,
  });

  final Anchors anchors;
  final ScrollController controller;

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _filter = 'All';

  List<Project> get _filtered {
    if (_filter == 'All') return projects;
    return projects.where((p) => p.categories.contains(_filter)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final padding = contentPaddingOf(context);

    return Container(
      key: widget.anchors.projects,
      padding: EdgeInsets.fromLTRB(padding, 96, padding, 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollReveal(
                controller: widget.controller,
                child: const SectionHeading(
                  order: '03',
                  label: 'Projects',
                  title: 'Featured Work',
                ),
              ),
              const SizedBox(height: 40),
              _FilterRow(
                filters: const ['All', 'Flutter & Firebase', 'Architecture-focused'],
                selected: _filter,
                onTap: (f) => setState(() => _filter = f),
                controller: widget.controller,
              ),
              const SizedBox(height: 36),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 360),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: KeyedSubtree(
                  key: ValueKey(_filter),
                  child: LayoutBuilder(
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
                          for (final project in _filtered)
                            SizedBox(
                              width: itemWidth,
                              child: ScrollReveal(
                                controller: widget.controller,
                                duration: const Duration(milliseconds: 800),
                                child: _ProjectCard(project: project),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filters,
    required this.selected,
    required this.onTap,
    required this.controller,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onTap;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      controller: controller,
      offsetY: 18,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final f in filters)
            _FilterChip(
              label: f,
              selected: selected == f,
              onTap: () => onTap(f),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.selected ? null : (_hovered ? AppColors.surfaceAlt : AppColors.surface);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _hovered && !widget.selected ? -1 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: bgColor,
            gradient:
                widget.selected ? AppColors.primaryGradient : null,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.selected ? Colors.transparent : AppColors.border,
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: -6,
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: AppText.mono(
              12.5,
              color: widget.selected ? Colors.white : AppColors.textSecondary,
              weight: FontWeight.w600,
            ),
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
    final hasCode = p.codeAvailable && p.githubUrl != null;
    // Collapsed: show 2 bullets only. Expanded: show the full list.
    final visibleBullets =
        _expanded ? p.bullets : p.bullets.take(2).toList();
    final canExpand = p.bullets.length > 2;

    return HoverCard(
      onTap: _toggle,
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
          // Bullets (collapsed = 2, expanded = all).
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
                if (canExpand && !_expanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: InkWell(
                      onTap: _toggle,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Show ${p.bullets.length - 2} more',
                            style: AppText.mono(12,
                                color: AppColors.cyan, weight: FontWeight.w600),
                          ),
                          const SizedBox(width: 5),
                          Icon(Icons.expand_more_rounded,
                              size: 18, color: AppColors.cyan),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Primary button: opens the repo when code is available, otherwise
          // toggles the expand/collapse detail view.
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              label: _buttonLabel(p, canExpand),
              icon: _buttonIcon(p),
              outlined: true,
              compact: true,
              onPressed: hasCode
                  ? () => openUrl(p.githubUrl!)
                  : _toggle,
            ),
          ),
        ],
      ),
    );
  }

  String _buttonLabel(Project p, bool canExpand) {
    if (p.codeAvailable) return 'View Code';
    if (_expanded) return 'Collapse';
    return canExpand ? 'Expand Details' : 'Details';
  }

  IconData _buttonIcon(Project p) {
    if (p.codeAvailable) return Icons.code_rounded;
    return _expanded
        ? Icons.expand_less_rounded
        : Icons.expand_more_rounded;
  }
}