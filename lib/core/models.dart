import 'package:flutter/material.dart';

class EducationItem {
  const EducationItem({
    required this.degree,
    required this.institute,
    required this.period,
    required this.tag,
    required this.icon,
  });

  final String degree;
  final String institute;
  final String period;
  final String tag;
  final IconData icon;
}

class SkillCategory {
  const SkillCategory({
    required this.label,
    required this.icon,
    required this.skills,
  });

  final String label;
  final IconData icon;
  final List<Skill> skills;
}

class Skill {
  const Skill({required this.name, this.core = false});

  final String name;
  final bool core;
}

class TopSkill {
  const TopSkill({required this.name, required this.fraction});

  final String name;
  final double fraction;
}

class Project {
  const Project({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tags,
    required this.bullets,
    required this.categories,
    this.githubUrl,
    this.codeAvailable = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> tags;
  final List<String> bullets;
  final List<String> categories;
  final String? githubUrl;
  final bool codeAvailable;
}

class Certification {
  const Certification({
    required this.title,
    required this.issuer,
    required this.icon,
  });

  final String title;
  final String issuer;
  final IconData icon;
}

class Achievement {
  const Achievement({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

class ContactLink {
  const ContactLink({
    required this.label,
    required this.value,
    required this.icon,
    this.url,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? url;
}

class CertificateGalleryItem {
  const CertificateGalleryItem({
    required this.imagePath,
    required this.title,
    required this.category,
  });

  final String imagePath;
  final String title;
  final String category;
}