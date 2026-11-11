import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Fades + slides its child into view the first time it scrolls into the
/// viewport. Finds the enclosing [Scrollable] itself, so callers don't have to
/// pass a controller around. Respects the reduced-motion preference.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    this.child,
    this.builder,
    this.duration = const Duration(milliseconds: 750),
    this.delay = Duration.zero,
    this.offsetY = 28,
  }) : assert(
         child != null || builder != null,
         'Either [child] or [builder] must be provided',
       );

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
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  ScrollPosition? _position;
  bool _shown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotionOf(context)) {
      _shown = true;
      _controller.value = 1;
    }
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_maybeTrigger);
      _position = position;
      if (!_shown) _position?.addListener(_maybeTrigger);
    }
    if (!_shown) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeTrigger());
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_maybeTrigger);
    _controller.dispose();
    super.dispose();
  }

  void _maybeTrigger() {
    if (_shown || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    // Start as soon as the top edge enters the viewport so the reveal plays
    // while the element scrolls in rather than finishing off-screen.
    if (top < MediaQuery.sizeOf(context).height + 48) {
      _shown = true;
      _position?.removeListener(_maybeTrigger);
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
    if (builder != null) return builder(context, _animation);
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
