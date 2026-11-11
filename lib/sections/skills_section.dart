import 'package:flutter/material.dart';

import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';
import '../widgets/section_shell.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: skillCategories.length,
    vsync: this,
  )..addListener(_onTabChanged);

  void _onTabChanged() {
    if (_tabController.index != _tabController.previousIndex) setState(() {});
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sidePanel = deviceOf(context) == DeviceType.desktop;

    final tabsColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _SkillsGrid(
            key: ValueKey(_tabController.index),
            category: skillCategories[_tabController.index],
          ),
        ),
      ],
    );

    return SectionShell(
      heading: const SectionHeading(
        order: '03',
        label: 'Skills',
        title: 'Tech Stack & Expertise',
        subtitle:
            'The tools and patterns I use to ship dependable Flutter apps end to end.',
      ),
      child: sidePanel
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: tabsColumn),
                const SizedBox(width: 36),
                const Expanded(flex: 3, child: _FocusPanel()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FocusPanel(),
                const SizedBox(height: 36),
                tabsColumn,
              ],
            ),
    );
  }
}

/// Core strengths with the evidence behind them (no self-rated percentages).
class _FocusPanel extends StatelessWidget {
  const _FocusPanel();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ScrollReveal(
      duration: const Duration(milliseconds: 900),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bolt_rounded, color: AppColors.cyan, size: 18),
                const SizedBox(width: 9),
                Text(
                  'CORE FOCUS',
                  style: AppText.mono(
                    12.5,
                    letterSpacing: 1.6,
                    color: AppColors.textPrimary,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            for (var i = 0; i < focusAreas.length; i++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      focusAreas[i].icon,
                      size: 16,
                      color: AppColors.cyan,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          focusAreas[i].name,
                          style: textTheme.titleMedium!.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 3),
                        Text(focusAreas[i].detail, style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              if (i < focusAreas.length - 1) const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  const _SkillsGrid({super.key, required this.category});

  final SkillCategory category;

  @override
  Widget build(BuildContext context) {
    final skills = category.skills;
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final itemWidth = constraints.maxWidth > 560
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
                  delay: Duration(milliseconds: 60 * i),
                  offsetY: 14,
                  child: _SkillCard(
                    skill: skills[i],
                    dotColor:
                        AppColors.dotPalette[i % AppColors.dotPalette.length],
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
                BoxShadow(
                  color: dotColor.withValues(alpha: 0.55),
                  blurRadius: 7,
                ),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Core',
                style: AppText.mono(9, color: Colors.white, letterSpacing: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
