import 'package:flutter/material.dart';

import 'models.dart';

export 'models.dart';

/// Central place for every link on the site.
abstract final class AppLinks {
  static const String github = 'https://github.com/Aditya-8788';
  static const String linkedin = 'https://www.linkedin.com/in/aditya-khochikar/';
  static const String leetcode = 'https://leetcode.com/u/Aditya_khochikar115/';
  static const String resume = 'https://drive.google.com/file/d/1NHJ9j2NX149q7wpUQ_mqflebAIVXVlqM/view?usp=drivesdk';
  static const String mailto = 'mailto:adityakhochikar@gmail.com';
  static const String location = 'Kolhapur, Maharashtra, India';
  static const String email = 'adityakhochikar@gmail.com';
}

const List<EducationItem> educationItems = [
  EducationItem(
    degree: 'B.Tech — Computer Science and Engineering',
    institute: 'Ashokrao Mane Group of Institutions, Vathar Kolhapur, Maharashtra',
    period: 'July 2022 – June 2026',
    tag: 'CGPA 6.9',
    icon: Icons.school_rounded,
  ),
  EducationItem(
    degree: 'HSC (Science — PCM)',
    institute: 'Hanumantrao Chate Jr College of Science, Shahuwadi, Kolhapur',
    period: '2020 – 2022',
    tag: '71.33%',
    icon: Icons.science_rounded,
  ),
];

const List<TopSkill> topSkills = [
  TopSkill(name: 'BLoC State Management', fraction: 0.90),
  TopSkill(name: 'Clean Architecture', fraction: 0.88),
  TopSkill(name: 'Firebase Integration', fraction: 0.85),
];

const List<SkillCategory> skillCategories = [
  SkillCategory(
    label: 'Mobile Development',
    icon: Icons.smartphone_rounded,
    skills: [
      Skill(name: 'Flutter', core: true),
      Skill(name: 'Dart'),
      Skill(name: 'Material Design'),
      Skill(name: 'Responsive UI'),
      Skill(name: 'Flutter Animations'),
      Skill(name: 'Navigation'),
    ],
  ),
  SkillCategory(
    label: 'State Management & Architecture',
    icon: Icons.account_tree_rounded,
    skills: [
      Skill(name: 'BLoC', core: true),
      Skill(name: 'Clean Architecture', core: true),
      Skill(name: 'Repository Pattern'),
      Skill(name: 'Dependency Injection (GetIt)'),
      Skill(name: 'Feature-based Architecture'),
    ],
  ),
  SkillCategory(
    label: 'Backend & Tools',
    icon: Icons.terminal_rounded,
    skills: [
      Skill(name: 'Firebase Authentication', core: true),
      Skill(name: 'Cloud Firestore', core: true),
      Skill(name: 'REST API Integration'),
      Skill(name: 'JSON Parsing'),
      Skill(name: 'CRUD Operations'),
      Skill(name: 'Git'),
      Skill(name: 'GitHub'),
      Skill(name: 'VS Code'),
      Skill(name: 'IntelliJ'),
      Skill(name: 'Firebase Console'),
    ],
  ),
  SkillCategory(
    label: 'Languages',
    icon: Icons.code_rounded,
    skills: [
      Skill(name: 'Dart', core: true),
      Skill(name: 'Java'),
      Skill(name: 'JavaScript'),
      Skill(name: 'HTML'),
      Skill(name: 'CSS'),
    ],
  ),
];

const List<Project> projects = [
  Project(
    title: 'Food Delivery App',
    subtitle: 'Role-based multi-vendor Flutter application',
    icon: Icons.fastfood_rounded,
    tags: [
      'Flutter',
      'Dart',
      'BLoC',
      'Clean Architecture',
      'Firebase Auth',
      'Cloud Firestore',
    ],
    bullets: [
      'Built a role-based app supporting Customer & Hotel Owner profiles in a single Flutter application',
      'Firebase Authentication with Email/Password login and secure role-based navigation',
      'Cloud Firestore integration for real-time user profiles, hotel info, and food data',
      'Full CRUD operations for hotel owners to manage food listings',
      'Displayed detailed food info: price, category, calories, protein, carbs, fat',
      'Applied BLoC, Clean Architecture, Repository Pattern, and Dependency Injection',
      'Responsive UI with reusable widgets, animations, and modern Material Design',
    ],
    categories: ['Flutter & Firebase', 'Architecture-focused'],
    githubUrl: 'https://github.com/Aditya-8788/food-list-app',
    codeAvailable: true,
  ),
  Project(
    title: 'Tele-Health Doctor & Patient App',
    subtitle: 'Cross-platform telehealth & video consultation',
    icon: Icons.personal_video_rounded,
    tags: [
      'Flutter',
      'Dart',
      'Firebase',
      'BLoC',
      'WebRTC',
    ],
    bullets: [
      'Cross-platform telehealth app with role-based authentication, appointment management, clinical notes, and real-time video consultation',
      'Firebase Authentication (Email/Password + Google Sign-In), session persistence, form validation',
      'Cloud Firestore for real-time appointment, patient, notes, and call-session data (create/update/delete/status)',
      'Real-time WebRTC video calling: SDP offer/answer exchange, ICE candidate signaling, STUN config, call controls, call history',
      'BLoC + Clean Architecture (presentation/domain/data layers), repository pattern, use cases, dependency injection',
      'Used Dartz functional error handling, GetIt DI, Equatable, SharedPreferences, UUID',
    ],
    categories: ['Flutter & Firebase', 'Architecture-focused'],
    githubUrl: 'https://github.com/Aditya-8788/tele_health_doctor',
    codeAvailable: true,
  ),
  Project(
    title: 'Gym Exercise Guide App',
    subtitle: 'Fitness app with REST-backed exercise catalog',
    icon: Icons.fitness_center_rounded,
    tags: [
      'Flutter',
      'Dart',
      'BLoC',
      'Clean Architecture',
      'Firebase',
      'REST API',
    ],
    bullets: [
      'Fitness application using Clean Architecture & BLoC for scalable state management',
      'Firebase Authentication (Email/Password & Google Sign-In)',
      'Consumed exercise data from a REST API with async loading, loading/error states',
      'Responsive UI with reusable widgets, smooth navigation, Flutter animations',
      'Feature-based architecture with Repository Pattern & Dependency Injection',
    ],
    categories: ['Flutter & Firebase', 'Architecture-focused'],
    githubUrl: 'https://github.com/Aditya-8788/gym',
    codeAvailable: true,
  ),
  Project(
    title: 'Order Tracker App',
    subtitle: 'Real-time order status tracking via REST APIs',
    icon: Icons.local_shipping_rounded,
    tags: [
      'Flutter',
      'Dart',
      'BLoC',
      'Clean Architecture',
      'REST API',
      'dartz',
    ],
    bullets: [
      'Order tracking app retrieving and displaying real-time order info via REST APIs',
      'BLoC state management for loading, success, error, and refresh states',
      'Clean Architecture with separate Presentation, Domain, and Data layers',
      'REST API integration via HTTP package, repository and use-case patterns',
      'Dartz/Either for functional error handling and API failure management',
      'Pull-to-refresh functionality',
    ],
    categories: ['Architecture-focused'],
    githubUrl: 'https://github.com/Aditya-8788/order-tracker-app',
    codeAvailable: true,
  ),
];

const List<Certification> certifications = [
  Certification(
    title: 'PHP and MySQL Training',
    issuer: 'Ashokrao Mane Group of Institutions, Kolhapur',
    icon: Icons.storage_rounded,
  ),
  Certification(
    title: 'Data Structures and Algorithms using Java',
    issuer: 'NPTEL',
    icon: Icons.account_tree_rounded,
  ),
];

const List<Achievement> achievements = [
  Achievement(
    title: 'Solved 90+ DSA problems on LeetCode and GFG; ranked Top 100 out of 1800+ students at DBATU, Lonere',
    icon: Icons.emoji_events_rounded,
  ),
  Achievement(
    title: '3rd Place — Code Carnival Secure Coding Competition (REFLEX 2K25), Ashokrao Mane Group of Institutions',
    icon: Icons.military_tech_rounded,
  ),
  Achievement(
    title: 'Participated in CodeKaze June \'23 (Round 1), organized by Coding Ninjas',
    icon: Icons.code_rounded,
  ),
  Achievement(
    title: 'Participated in CodeVenture coding competition',
    icon: Icons.terminal_rounded,
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
    value: 'linkedin.com/in/aditya-khochikar',
    icon: Icons.business_center_rounded,
    url: AppLinks.linkedin,
  ),
  ContactLink(
    label: 'GitHub',
    value: 'github.com/Aditya-8788',
    icon: Icons.code_rounded,
    url: AppLinks.github,
  ),
  ContactLink(
    label: 'LeetCode',
    value: 'leetcode.com/u/Aditya_khochikar115',
    icon: Icons.terminal_rounded,
    url: AppLinks.leetcode,
  ),
  ContactLink(
    label: 'Location',
    value: AppLinks.location,
    icon: Icons.location_on_rounded,
  ),
];

const List<CertificateGalleryItem> certificateGallery = [
  CertificateGalleryItem(
    imagePath: 'assets/images/certificates/php_mysql_training.jpg',
    title: 'PHP and MySQL Training',
    category: 'Course Completion',
  ),
  CertificateGalleryItem(
    imagePath: 'assets/images/certificates/nptel_dsa_java.jpg',
    title: 'Data Structures and Algorithms using Java (NPTEL)',
    category: 'Course Completion',
  ),
  CertificateGalleryItem(
    imagePath: 'assets/images/certificates/code_carnival_3rd_place.jpg',
    title: '3rd Place — Code Carnival (REFLEX 2K25)',
    category: 'Achievement',
  ),
  CertificateGalleryItem(
    imagePath: 'assets/images/certificates/techfest.jpg',
    title: 'TechFest',
    category: 'Achievement',
  ),
  CertificateGalleryItem(
    imagePath: 'assets/images/certificates/codeventure.jpg',
    title: 'CodeVenture Coding Competition',
    category: 'Achievement',
  ),
];