import 'package:flutter/material.dart';

import 'models.dart';

export 'models.dart';

/// Central place for every link on the site.
abstract final class AppLinks {
  static const String mailto = 'mailto:amrutkhochikar@gmail.com';
  static const String tel = 'tel:+919172518904';
  static const String location = 'Kolhapur, Maharashtra, India';
  static const String email = 'amrutkhochikar@gmail.com';
  static const String phone = '+91 91725 18904';
  static const String github = 'https://github.com/Amrut-03';
  static const String linkedin = 'https://www.linkedin.com/in/amrut-khochikar/';
}

const List<EducationItem> educationItems = [
  EducationItem(
    degree: 'B.Tech — Computer Science and Engineering',
    institute: 'Ashokrao Mane Group of Institutions, Vathar, Kolhapur, Maharashtra',
    period: 'Jul 2022 – Jun 2025',
    tag: 'CGPA 6.92',
    icon: Icons.school_rounded,
  ),
];

const List<TopSkill> topSkills = [
  TopSkill(name: 'GetX State Management', fraction: 0.92),
  TopSkill(name: 'Clean Architecture', fraction: 0.88),
  TopSkill(name: 'Firebase Integration', fraction: 0.85),
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
      Skill(name: 'GetX', core: true),
      Skill(name: 'Bloc', core: true),
      Skill(name: 'Riverpod'),
      Skill(name: 'Clean Architecture', core: true),
      Skill(name: 'MVC'),
      Skill(name: 'GoRouter'),
      Skill(name: 'GetIt'),
    ],
  ),
  SkillCategory(
    label: 'Backend & APIs',
    icon: Icons.dns_rounded,
    skills: [
      Skill(name: 'RESTful APIs', core: true),
      Skill(name: 'Node.js'),
      Skill(name: 'Express.js'),
      Skill(name: 'Firebase Realtime Database'),
      Skill(name: 'Cloud Firestore', core: true),
    ],
  ),
  SkillCategory(
    label: 'Databases & Storage',
    icon: Icons.storage_rounded,
    skills: [
      Skill(name: 'Hive', core: true),
      Skill(name: 'MongoDB'),
      Skill(name: 'Flutter Secure Storage'),
      Skill(name: 'Local Push Notifications'),
    ],
  ),
  SkillCategory(
    label: 'Other Technologies',
    icon: Icons.memory_rounded,
    skills: [
      Skill(name: 'TensorFlow Lite'),
      Skill(name: 'Google Gemma'),
      Skill(name: 'Firebase'),
      Skill(name: 'Google Maps'),
      Skill(name: 'Stripe Integration'),
    ],
  ),
  SkillCategory(
    label: 'Tools',
    icon: Icons.handyman_rounded,
    skills: [
      Skill(name: 'Git'),
      Skill(name: 'GitHub'),
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
    subtitle: 'Offline-first expense tracker with on-device AI',
    icon: Icons.account_balance_wallet_rounded,
    githubUrl: 'https://github.com/Amrut-03/expense_flow_app',
    codeAvailable: true,
    tags: [
      'Flutter',
      'Dart',
      'Clean Architecture',
      'Bloc',
      'Hive',
      'Firebase',
      'Cloud Firestore',
      'GetIt',
      'GoRouter',
      'TensorFlow Lite',
      'Google Gemma',
    ],
    bullets: [
      'Offline-first expense tracking focused on privacy, local data storage, synchronization, and intelligent spending analysis',
      'Integrated an on-device AI assistant using Google Gemma + TensorFlow Lite for conversational spending analysis',
      'Private, offline financial insights stored locally with Hive — syncs to Cloud Firestore in the background when connectivity returns',
      'Built with Clean Architecture, GetIt for dependency injection, Bloc for state management, and GoRouter for navigation',
    ],
    categories: ['Flutter & Firebase', 'Architecture-focused'],
  ),
  Project(
    title: 'BeFit',
    subtitle: 'Fitness tracking application',
    icon: Icons.fitness_center_rounded,
    githubUrl: 'https://github.com/Amrut-03/befit_fitness_1.0',
    codeAvailable: true,
    tags: [
      'Flutter',
      'Dart',
      'Clean Architecture',
      'Bloc',
      'Firebase',
      'FL Charts',
      'Pedometer',
    ],
    bullets: [
      'Flutter fitness tracking app for activity tracking and visualization with a responsive mobile experience',
      'Real-time step tracking using the pedometer package',
      'Firebase integration for storage alongside fitness API integration',
      'Visualizes fitness data with charts for clear activity insights',
      'Built with Clean Architecture and Bloc state management',
    ],
    categories: ['Flutter & Firebase'],
  ),
];

const List<Achievement> achievements = [
  Achievement(
    title: 'Published a reusable and customizable Flutter UI package, Flutter Body Part Selector, on pub.dev',
    icon: Icons.widgets_rounded,
  ),
  Achievement(
    title: 'Solved 250+ coding challenges on LeetCode, demonstrating strong foundations in data structures and algorithms',
    icon: Icons.emoji_events_rounded,
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
    period: 'Apr 2025 – Apr 2026',
    mode: 'Hybrid / Remote',
    icon: Icons.work_rounded,
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
    role: 'Mobile Application Developer Intern',
    company: 'Digital Development Leadership Group',
    period: 'Feb 2024 – Mar 2024',
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
    label: 'Phone',
    value: AppLinks.phone,
    icon: Icons.phone_rounded,
    url: AppLinks.tel,
  ),
  ContactLink(
    label: 'Location',
    value: AppLinks.location,
    icon: Icons.location_on_rounded,
  ),
  ContactLink(
    label: 'GitHub',
    value: 'github.com/Amrut-03',
    icon: Icons.code_rounded,
    url: AppLinks.github,
  ),
  ContactLink(
    label: 'LinkedIn',
    value: 'linkedin.com/in/amrut-khochikar',
    icon: Icons.work_outline_rounded,
    url: AppLinks.linkedin,
  ),
];