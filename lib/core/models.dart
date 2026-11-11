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

/// A headline strength, backed by evidence instead of a made-up percentage.
class FocusArea {
  const FocusArea({
    required this.name,
    required this.detail,
    required this.icon,
  });

  final String name;
  final String detail;
  final IconData icon;
}

class ProjectLink {
  const ProjectLink({
    required this.label,
    required this.url,
    required this.icon,
  });

  final String label;
  final String url;
  final IconData icon;
}

class Project {
  const Project({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tags,
    required this.bullets,
    this.links = const [],
    this.badge,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> tags;
  final List<String> bullets;
  final List<ProjectLink> links;

  /// Optional highlight shown next to the title (e.g. "Open source").
  final String? badge;
}

/// An earlier title held at the same company (e.g. intern before promotion).
class PreviousRole {
  const PreviousRole({required this.role, required this.period});

  final String role;
  final String period;
}

class ExperienceItem {
  const ExperienceItem({
    required this.role,
    required this.company,
    required this.period,
    required this.mode,
    required this.bullets,
    required this.icon,
    this.previousRoles = const [],
  });

  final String role;
  final String company;
  final String period;
  final String mode;
  final List<String> bullets;
  final IconData icon;
  final List<PreviousRole> previousRoles;
}

class Achievement {
  const Achievement({required this.title, required this.icon, this.url});

  final String title;
  final IconData icon;
  final String? url;
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
