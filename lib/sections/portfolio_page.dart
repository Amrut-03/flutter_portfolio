import 'package:flutter/material.dart';

import '../core/anchors.dart';
import '../core/scroll_util.dart';
import '../theme/app_theme.dart';
import 'navbar.dart';
import 'hero_section.dart';
import 'education_section.dart';
import 'skills_section.dart';
import 'projects_section.dart';
import 'certifications_section.dart';
import 'contact_section.dart';
import 'footer.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final Anchors _anchors = Anchors();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onNavigate(String id) {
    scrollToAnchor(_anchors, id, _scrollController);
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main scrolling content.
          SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                HeroSection(anchors: _anchors, controller: _scrollController),
                EducationSection(controller: _scrollController),
                SkillsSection(
                    anchors: _anchors, controller: _scrollController),
                ProjectsSection(
                    anchors: _anchors, controller: _scrollController),
                CertificationsSection(
                    anchors: _anchors, controller: _scrollController),
                ContactSection(
                    anchors: _anchors, controller: _scrollController),
                Footer(scrollToTop: _scrollToTop),
              ],
            ),
          ),
          // Sticky navbar overlay.
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