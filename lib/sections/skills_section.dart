import 'package:flutter/material.dart';

import '../core/anchors.dart';
import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({
    super.key,
    required this.anchors,
    required this.controller,
  });

  final Anchors anchors;
  final ScrollController controller;

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: skillCategories.length, vsync: this);

  @override
  void initState() {
    super.initState();
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.index != _tabController.previousIndex) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = contentPaddingOf(context);
    final device = deviceOf(context);
    final sidePanel = device == DeviceType.desktop;

    final tabsColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              indicatorPadding: EdgeInsets.zero,
              indicator: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppText.mono(12.5, weight: FontWeight.w600),
              unselectedLabelStyle: AppText.mono(12.5),
              padding: const EdgeInsets.all(2),
              tabs: [
                for (final category in skillCategories)
                  Tab(
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(category.icon, size: 15),
                        const SizedBox(width: 7),
                        Text(category.label),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: _SkillsGrid(
            key: ValueKey(_tabController.index),
            category: skillCategories[_tabController.index],
            controller: widget.controller,
          ),
        ),
      ],
    );

    return Container(
      key: widget.anchors.skills,
      padding: EdgeInsets.fromLTRB(padding, 56, padding, 56),
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
                  label: 'Skills',
                  title: 'Tech Stack & Expertise',
                  subtitle:
                      'The tools and patterns I use to ship dependable Flutter apps end to end.',
                ),
              ),
              const SizedBox(height: 32),
              if (sidePanel)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: tabsColumn),
                    const SizedBox(width: 36),
                    Expanded(
                      flex: 3,
                      child: _TopSkillsPanel(controller: widget.controller),
                    ),
                  ],
                )
              else ...[
                _TopSkillsPanel(controller: widget.controller),
                const SizedBox(height: 36),
                tabsColumn,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TopSkillsPanel extends StatelessWidget {
  const _TopSkillsPanel({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      controller: controller,
      duration: const Duration(milliseconds: 900),
      builder: (context, reveal) {
        return AnimatedBuilder(
          animation: reveal,
          builder: (context, _) {
            final t = Curves.easeOutCubic.transform(reveal.value);
            return Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, (1 - t) * 26),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyan.withValues(alpha: 0.05),
                        blurRadius: 30,
                        spreadRadius: -10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.show_chart_rounded,
                              color: AppColors.cyan, size: 18),
                          SizedBox(width: 9),
                          Text(
                            'TOP SKILLS',
                            style: TextStyle(
                              fontFamily: AppText.monoFont,
                              fontSize: 12.5,
                              letterSpacing: 1.6,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      for (var i = 0; i < topSkills.length; i++) ...[
                        // Stagger each bar so they fill in sequence as the
                        // panel scrolls into view.
                        _SkillBar(
                          name: topSkills[i].name,
                          fraction: topSkills[i].fraction *
                              _stagger(t, i, 0.16),
                        ),
                        if (i < topSkills.length - 1)
                          const SizedBox(height: 18),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

double _stagger(double t, int index, double step) {
  final local = ((t - index * step) / (1 - index * step)).clamp(0.0, 1.0);
  return Curves.easeOutCubic.transform(local);
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({required this.name, required this.fraction});

  final String name;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final percent = (fraction * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 14,
                    ),
              ),
            ),
            Text(
              '$percent%',
              style: AppText.mono(12, color: AppColors.cyan),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 8,
            color: AppColors.surfaceAlt,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * fraction.clamp(0.0, 1.0);
                return Container(
                  width: width,
                  decoration: BoxDecoration(
                    gradient: AppColors.blueCyanGradient,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyan.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CoreTag extends StatelessWidget {
  const _CoreTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Core',
        style: AppText.mono(9, color: Colors.white, letterSpacing: 0.8),
      ),
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  const _SkillsGrid({
    super.key,
    required this.category,
    required this.controller,
  });

  final SkillCategory category;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final skills = category.skills;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 560;
        final spacing = 12.0;
        final itemWidth = isWide
            ? (constraints.maxWidth - spacing) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var i = 0; i < skills.length; i++)
              SizedBox(
                width: itemWidth,
                child: ScrollReveal(
                  controller: controller,
                  delay: Duration(milliseconds: 60 * i),
                  offsetY: 14,
                  child: _SkillCard(
                    skill: skills[i],
                    dotColor: AppColors.dotPalette[i % AppColors.dotPalette.length],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill, required this.dotColor});

  final Skill skill;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: dotColor.withValues(alpha: 0.55), blurRadius: 7),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              skill.name,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          if (skill.core) ...[
            const SizedBox(width: 8),
            const _CoreTag(),
          ],
        ],
      ),
    );
  }
}