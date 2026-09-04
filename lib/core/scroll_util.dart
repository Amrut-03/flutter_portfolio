import 'package:flutter/material.dart';

import 'anchors.dart';
import '../theme/app_theme.dart';

/// Smooth-scrolls the [controller] so that the section identified by [id]
/// sits just below the sticky navbar.
void scrollToAnchor(
  Anchors anchors,
  String id,
  ScrollController controller,
) {
  final key = anchors.keyFor(id);
  if (key == null) return;
  final ctx = key.currentContext;
  if (ctx == null) return;
  final box = ctx.findRenderObject() as RenderBox?;
  if (box == null || !box.attached) return;
  final pos = box.localToGlobal(Offset.zero).dy;
  final target =
      (controller.offset + pos - AppTheme.navBarHeight - 10).clamp(
    0.0,
    controller.position.maxScrollExtent,
  );
  controller.animateTo(
    target,
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeOutCubic,
  );
}