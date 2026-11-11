import 'package:flutter/material.dart';

import 'models.dart';

export 'models.dart';

/// Central place for every link on the site.
abstract final class AppLinks {
  static const String siteUrl = 'https://amrut-portfolio-project.web.app';
  static const String resumeUrl = '$siteUrl/assets/assets/resume.pdf';

  static const String email = 'amrutkhochikar@gmail.com';
  static const String mailto = 'mailto:$email';
  static const String location = 'Kolhapur, Maharashtra, India';
  static const String github = 'https://github.com/Amrut-03';
  static const String linkedin = 'https://www.linkedin.com/in/amrut-khochikar/';
  static const String leetcode = 'https://leetcode.com/u/Amrut_03/';
  static const String bodyPartSelector =
      'https://pub.dev/packages/flutter_body_part_selector';
}

const List<EducationItem> educationItems = [
  EducationItem(
    degree: 'B.Tech — Computer Science and Engineering',
    institute:
        'Ashokrao Mane Group of Institutions, Vathar, Kolhapur, Maharashtra',
    period: 'Jul 2022 – Jun 2025',
    tag: 'CGPA 6.92',
    icon: Icons.school_rounded,
  ),
];

const List<FocusArea> focusAreas = [
  FocusArea(
    name: 'On-device AI in Flutter',
    detail:
        'Google Gemma 3n + TensorFlow Lite powering an offline assistant in ExpenseFlow',
    icon: Icons.auto_awesome_rounded,
  ),
  FocusArea(
    name: 'Clean Architecture',
    detail: 'Layered, testable apps with flutter_bloc, Riverpod and get_it',
    icon: Icons.account_tree_rounded,
  ),
  FocusArea(
    name: 'Offline-first + Firebase',
    detail:
        'Local-first storage with Hive, synced to Cloud Firestore in the background',
    icon: Icons.cloud_sync_rounded,
  ),
];

const List<SkillCategory> skillCategories = [
  SkillCategory(
    label: 'Mobile Development',
    icon: Icons.smartphone_rounded,
    skills: [
      Skill(name: 'Flutter', core: true),
      Skill(name: 'Dart', core: true),
      Skill(name: 'Java'),
      Skill(name: 'Material Design'),
      Skill(name: 'Responsive UI'),
      Skill(name: 'Flutter Animations'),
    ],
  ),
  SkillCategory(
    label: 'State Management & Architecture',
    icon: Icons.account_tree_rounded,
    skills: [
      Skill(name: 'Bloc (flutter_bloc)', core: true),
      Skill(name: 'Riverpod', core: true),
      Skill(name: 'Clean Architecture', core: true),
      Skill(name: 'Provider'),
      Skill(name: 'GetX'),
      Skill(name: 'MVVM'),
      Skill(name: 'get_it'),
      Skill(name: 'GoRouter'),
    ],
  ),
  SkillCategory(
    label: 'AI & Integrations',
    icon: Icons.auto_awesome_rounded,
    skills: [
      Skill(name: 'Google Gemma 3n', core: true),
      Skill(name: 'TensorFlow Lite', core: true),
      Skill(name: 'Google Maps'),
      Skill(name: 'Stripe Integration'),
      Skill(name: 'Local Push Notifications'),
    ],
  ),
  SkillCategory(
    label: 'Backend & APIs',
    icon: Icons.dns_rounded,
    skills: [
      Skill(name: 'RESTful APIs', core: true),
      Skill(name: 'Firebase', core: true),
      Skill(name: 'Cloud Firestore'),
      Skill(name: 'Firebase Realtime Database'),
      Skill(name: 'Node.js'),
      Skill(name: 'Express.js'),
    ],
  ),
  SkillCategory(
    label: 'Databases & Storage',
    icon: Icons.storage_rounded,
    skills: [
      Skill(name: 'Hive', core: true),
      Skill(name: 'SQL'),
      Skill(name: 'MongoDB'),
      Skill(name: 'Flutter Secure Storage'),
    ],
  ),
  SkillCategory(
    label: 'Tools',
    icon: Icons.handyman_rounded,
    skills: [
      Skill(name: 'Git'),
      Skill(name: 'GitHub'),
      Skill(name: 'FVM'),
      Skill(name: 'Jira'),
      Skill(name: 'Android Studio'),
      Skill(name: 'VS Code'),
      Skill(name: 'Postman'),
    ],
  ),
];

const List<Project> projects = [
  Project(
    title: 'ExpenseFlow',
    subtitle: 'Offline-first expense tracker with an on-device AI assistant',
    icon: Icons.account_balance_wallet_rounded,
    badge: 'AI',
    links: [
      ProjectLink(
        label: 'View Code',
        url: 'https://github.com/Amrut-03/expense_flow_app',
        icon: Icons.code_rounded,
      ),
    ],
    tags: [
      'Flutter',
      'Gemma 3n',
      'TensorFlow Lite',
      'Clean Architecture',
      'Bloc',
      'Hive',
      'Cloud Firestore',
      'get_it',
      'GoRouter',
    ],
    bullets: [
      'On-device AI assistant built on Google Gemma 3n + TensorFlow Lite that gives budgeting and saving tips — no data leaves the phone',
      'Offline-first: expenses are stored locally with Hive and synced to Cloud Firestore in the background when connectivity returns',
      'Conversational spending analysis focused on privacy and local data storage',
      'Built with Clean Architecture, get_it for dependency injection, Bloc for state management, and GoRouter for navigation',
    ],
  ),
  Project(
    title: 'flutter_body_part_selector',
    subtitle: 'Open-source Flutter package on pub.dev',
    icon: Icons.accessibility_new_rounded,
    badge: 'Open source',
    links: [
      ProjectLink(
        label: 'pub.dev',
        url: AppLinks.bodyPartSelector,
        icon: Icons.inventory_2_rounded,
      ),
    ],
    tags: ['Flutter', 'Dart', 'Custom Widgets', 'pub.dev'],
    bullets: [
      'Reusable, customizable widget that renders a tappable muscle / body-part diagram',
      'Originally built for the BeFit fitness app, then extracted and published as a standalone package',
      'Lets fitness apps select target muscle groups with a single, themeable widget',
    ],
  ),
  Project(
    title: 'BeFit',
    subtitle: 'Fitness tracking application',
    icon: Icons.fitness_center_rounded,
    links: [
      ProjectLink(
        label: 'View Code',
        url: 'https://github.com/Amrut-03/befit_fitness_1.0',
        icon: Icons.code_rounded,
      ),
    ],
    tags: [
      'Flutter',
      'Clean Architecture',
      'Bloc',
      'Firebase',
      'FL Charts',
      'Pedometer',
    ],
    bullets: [
      'Flutter fitness tracking app for activity tracking and visualization with a responsive mobile experience',
      'Real-time step tracking using the pedometer package',
      'Muscle-group selection powered by my own flutter_body_part_selector package',
      'Firebase integration for storage alongside fitness API integration',
      'Visualizes fitness data with charts for clear activity insights',
    ],
  ),
];

const List<Achievement> achievements = [
  Achievement(
    title:
        'Published a reusable and customizable Flutter UI package, flutter_body_part_selector, on pub.dev',
    icon: Icons.widgets_rounded,
    url: AppLinks.bodyPartSelector,
  ),
  Achievement(
    title:
        'Solved 250+ coding challenges on LeetCode, demonstrating strong foundations in data structures and algorithms',
    icon: Icons.emoji_events_rounded,
    url: AppLinks.leetcode,
  ),
  Achievement(
    title: 'Secured 3rd rank among 200+ participants in Algo Expert (Reflex)',
    icon: Icons.military_tech_rounded,
  ),
];

const List<ExperienceItem> experienceItems = [
  ExperienceItem(
    role: 'Software Engineer',
    company: 'Mitt Arv Technologies Pvt. Ltd.',
    period: 'Oct 2025 – Apr 2026',
    mode: 'Hybrid / Remote',
    icon: Icons.work_rounded,
    previousRoles: [
      PreviousRole(
        role: 'Software Engineer Intern',
        period: 'Apr 2025 – Sep 2025',
      ),
    ],
    bullets: [
      'Engineered cross-platform mobile applications using Flutter, improving application UI/UX and performance by approximately 30%',
      'Resolved complex GetX state-management issues and introduced modular, maintainable application architecture',
      'Optimized RESTful API consumption and data handling for reliable backend communication',
      'Delivered production-ready features following clean coding practices, helping reduce post-release defects',
    ],
  ),
  ExperienceItem(
    role: 'Flutter Developer Intern',
    company: 'Cryptographic Solutions',
    period: 'Jul 2024 – Sep 2024',
    mode: 'Remote',
    icon: Icons.rocket_launch_rounded,
    bullets: [
      'Built a Flutter-based car wash mobile application from scratch',
      'Implemented Riverpod state management and integrated REST APIs for backend communication',
      'Conducted debugging, code reviews, and functional testing, improving application stability and reducing runtime issues',
    ],
  ),
  ExperienceItem(
    role: 'Mobile App Developer Intern',
    company: 'Digital Development and Leadership Group (DDLG)',
    period: 'Mar 2024 – Apr 2024',
    mode: 'Remote',
    icon: Icons.near_me_rounded,
    bullets: [
      'Contributed to a Flutter-based ride-services application with real-time ride workflows and user operations',
      'Integrated Firebase services and enhanced the Google Maps UI by approximately 50%',
      'Contributed to Stripe payment gateway integration',
    ],
  ),
];

const List<ContactLink> contactLinks = [
  ContactLink(
    label: 'Email',
    value: AppLinks.email,
    icon: Icons.mail_rounded,
    url: AppLinks.mailto,
  ),
  ContactLink(
    label: 'LinkedIn',
    value: 'linkedin.com/in/amrut-khochikar',
    icon: Icons.work_outline_rounded,
    url: AppLinks.linkedin,
  ),
  ContactLink(
    label: 'GitHub',
    value: 'github.com/Amrut-03',
    icon: Icons.code_rounded,
    url: AppLinks.github,
  ),
  ContactLink(
    label: 'LeetCode',
    value: 'leetcode.com/u/Amrut_03',
    icon: Icons.terminal_rounded,
    url: AppLinks.leetcode,
  ),
  ContactLink(
    label: 'Location',
    value: AppLinks.location,
    icon: Icons.location_on_rounded,
  ),
];
