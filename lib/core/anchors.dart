import 'package:flutter/widgets.dart';

/// Every navigable section of the page, in display order.
enum SectionId {
  about('About'),
  experience('Experience'),
  skills('Skills'),
  projects('Projects'),
  achievements('Achievements'),
  contact('Contact');

  const SectionId(this.label);

  final String label;

  static SectionId? tryParse(String? id) {
    for (final value in values) {
      if (value.name == id) return value;
    }
    return null;
  }
}

/// Global keys used for anchor navigation between sections.
class Anchors {
  final Map<SectionId, GlobalKey> _keys = {
    for (final id in SectionId.values) id: GlobalKey(debugLabel: id.name),
  };

  GlobalKey operator [](SectionId id) => _keys[id]!;
}
