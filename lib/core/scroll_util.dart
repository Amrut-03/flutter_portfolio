import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'anchors.dart';
import 'platform/browser.dart';

/// Smooth-scrolls [controller] so the section [id] sits just below the
/// sticky navbar, and mirrors it into the URL fragment (`#projects`).
void scrollToSection(
  BuildContext context,
  Anchors anchors,
  SectionId id,
  ScrollController controller,
) {
  final box = anchors[id].currentContext?.findRenderObject() as RenderBox?;
  if (box == null || !box.attached || !controller.hasClients) return;
  final pos = box.localToGlobal(Offset.zero).dy;
  final target = (controller.offset + pos - AppTheme.navBarHeight - 10).clamp(
    0.0,
    controller.position.maxScrollExtent,
  );
  if (reduceMotionOf(context)) {
    controller.jumpTo(target);
  } else {
    controller.animateTo(
      target,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
  Browser.replaceFragment(id == SectionId.about ? null : id.name);
}
