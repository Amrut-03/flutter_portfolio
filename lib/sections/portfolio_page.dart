import 'package:flutter/material.dart';

import '../core/anchors.dart';
import '../core/scroll_util.dart';
import '../theme/app_theme.dart';
import '../widgets/particle_background.dart';
import 'achievements_section.dart';
import 'contact_section.dart';
import 'education_section.dart';
import 'experience_section.dart';
import 'footer.dart';
import 'hero_section.dart';
import 'navbar.dart';
import 'projects_section.dart';
import 'skills_section.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key, this.initialSection});

  final SectionId? initialSection;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final Anchors _anchors = Anchors();

  @override
  void initState() {
    super.initState();
    // Deep links: /#projects opens scrolled to that section.
    final initial = widget.initialSection;
    if (initial != null && initial != SectionId.about) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _onNavigate(initial);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onNavigate(SectionId id) =>
      scrollToSection(context, _anchors, id, _scrollController);

  void _scrollToTop() => _onNavigate(SectionId.about);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned.fill(child: ParticleBackground()),
          // SelectionArea lets visitors select / copy any text (e.g. email).
          SelectionArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  HeroSection(
                    key: _anchors[SectionId.about],
                    onNavigate: _onNavigate,
                  ),
                  const EducationSection(),
                  ExperienceSection(key: _anchors[SectionId.experience]),
                  SkillsSection(key: _anchors[SectionId.skills]),
                  ProjectsSection(key: _anchors[SectionId.projects]),
                  AchievementsSection(key: _anchors[SectionId.achievements]),
                  ContactSection(key: _anchors[SectionId.contact]),
                  Footer(scrollToTop: _scrollToTop),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              controller: _scrollController,
              anchors: _anchors,
              onNavigate: _onNavigate,
            ),
          ),
        ],
      ),
    );
  }
}
