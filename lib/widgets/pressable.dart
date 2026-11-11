import 'package:flutter/material.dart';

/// Accessible tap target: mouse cursor, hover, keyboard focus, Enter/Space
/// activation and button/link semantics. [builder] receives `true` while the
/// widget is hovered or keyboard-focused so callers can render one highlight.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.onTap,
    required this.builder,
    this.semanticLabel,
    this.isLink = false,
  });

  final VoidCallback? onTap;
  final Widget Function(BuildContext context, bool highlighted) builder;
  final String? semanticLabel;

  /// Announce as a link (opens a URL) rather than a button.
  final bool isLink;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return FocusableActionDetector(
      enabled: enabled,
      mouseCursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onShowHoverHighlight: (v) => setState(() => _hovered = v),
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: Semantics(
        button: !widget.isLink,
        link: widget.isLink,
        enabled: enabled,
        label: widget.semanticLabel,
        onTap: widget.onTap,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: widget.builder(context, enabled && (_hovered || _focused)),
        ),
      ),
    );
  }
}
