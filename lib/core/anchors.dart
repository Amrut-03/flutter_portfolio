import 'package:flutter/material.dart';

/// Global keys used for anchor navigation between sections.
class Anchors {
  final GlobalKey about = GlobalKey();
  final GlobalKey experience = GlobalKey();
  final GlobalKey skills = GlobalKey();
  final GlobalKey projects = GlobalKey();
  final GlobalKey achievements = GlobalKey();
  final GlobalKey contact = GlobalKey();

  GlobalKey? keyFor(String id) => switch (id) {
        'about' => about,
        'experience' => experience,
        'skills' => skills,
        'projects' => projects,
        'achievements' => achievements,
        'contact' => contact,
        _ => null,
      };
}