import 'dart:async';

import 'package:flutter/material.dart';

/// Fades + slides its child (or animated builder output) into view as the
/// section scrolls into the viewport.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.controller,
    this.child,
    this.builder,
    this.duration = const Duration(milliseconds: 750),
    this.delay = Duration.zero,
    this.offsetY = 28,
  }) : assert(child != null || builder != null,
            'Either [child] or [builder] must be provided');

  final ScrollController controller;
  final Widget? child;

  /// Alternative to [child]. Receives the reveal progress animation (0..1)
  /// so callers can drive their own sub-animations.
  final Widget Function(BuildContext context, Animation<double> progress)?
      builder;

  final Duration duration;
  final Duration delay;
  final double offsetY;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    widget.controller.addListener(_maybeTrigger);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeTrigger());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_maybeTrigger);
    _controller.dispose();
    super.dispose();
  }

  void _maybeTrigger() {
    if (_shown || !mounted) return;
    if (!widget.controller.hasClients) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    // Trigger as soon as the element's top edge enters the viewport (from the
    // bottom), so the reveal plays while the element scrolls into view rather
    // than finishing before the user can see it.
    if (top < screenHeight + 48) {
      _shown = true;
      widget.controller.removeListener(_maybeTrigger);
      unawaited(_play());
    }
  }

  Future<void> _play() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }
    if (mounted) _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final builder = widget.builder;
    if (builder != null) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, _) => builder(context, _animation),
      );
    }
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        final t = _animation.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * widget.offsetY),
            child: child,
          ),
        );
      },
    );
  }
}