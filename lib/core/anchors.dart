import 'package:flutter/material.dart';

/// Global keys used for anchor navigation between sections.
class Anchors {
  final GlobalKey about = GlobalKey();
  final GlobalKey skills = GlobalKey();
  final GlobalKey projects = GlobalKey();
  final GlobalKey certifications = GlobalKey();
  final GlobalKey contact = GlobalKey();

  GlobalKey? keyFor(String id) => switch (id) {
        'about' => about,
        'skills' => skills,
        'projects' => projects,
        'certifications' => certifications,
        'contact' => contact,
        _ => null,
      };
}