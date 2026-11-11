import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Subtle drifting dot / constellation background. Purely decorative.
///
/// The dot grid is generated once per size (not per frame) and the painter
/// repaints straight from the animation, so ticks never rebuild widgets.
/// Browsers stop animation frames in hidden tabs, so no extra pausing is
/// needed. With reduced motion the field is drawn once, static.
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({
    super.key,
    this.seed = 7,
    this.spacing = 62,
    this.maxIntensity = 0.35,
  });

  final int seed;
  final double spacing;
  final double maxIntensity;

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 46),
  );
  final _ParticleField _field = _ParticleField();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotionOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fewer dots on small screens, and no connecting lines there.
    final width = MediaQuery.sizeOf(context).width;
    final spacing = (widget.spacing + (width < 480 ? 34 : 0)).clamp(
      34.0,
      140.0,
    );
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            animation: _controller,
            field: _field,
            seed: widget.seed,
            spacing: spacing,
            maxIntensity: widget.maxIntensity,
            drawLinks: width >= 640,
          ),
        ),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.amplitude,
    required this.phase,
    required this.speed,
    required this.radius,
    required this.opacity,
    required this.accent,
  });

  final double x;
  final double y;
  final double amplitude;
  final double phase;
  final double speed;
  final double radius;
  final double opacity;
  final bool accent;
}

/// Cached particle layout, owned by the State so it survives repaints.
class _ParticleField {
  List<_Particle> dots = const [];
  List<(int, int)> links = const [];
  List<Offset> positions = const [];
  Object? _cacheKey;

  void ensure({
    required Size size,
    required int seed,
    required double spacing,
    required double maxIntensity,
    required bool drawLinks,
  }) {
    final key = (
      (size.width / 32).round(),
      (size.height / 32).round(),
      seed,
      spacing,
      maxIntensity,
      drawLinks,
    );
    if (key == _cacheKey) return;
    _cacheKey = key;

    var state = seed;
    double rand() {
      state = (state * 1103515245 + 12345) & 0x7fffffff;
      return state / 0x7fffffff;
    }

    final cols = (size.width / spacing).ceil();
    final rows = (size.height / spacing).ceil();
    final intensity = maxIntensity.clamp(0.05, 1.0);
    dots = [
      for (var row = 0; row < rows; row++)
        for (var col = 0; col < cols; col++)
          () {
            final x = col * spacing + (rand() - 0.5) * spacing * 0.85;
            final y = row * spacing + (rand() - 0.5) * spacing * 0.85;
            final accent = rand() < 0.16;
            return _Particle(
              x: x,
              y: y,
              amplitude: 3 + rand() * 5,
              phase: rand() * 2 * math.pi,
              speed: 0.35 + rand() * 0.85,
              radius: accent ? 1.1 + rand() * 0.8 : 0.7 + rand() * 0.8,
              opacity: (0.08 + rand() * 0.22) * intensity,
              accent: accent,
            );
          }(),
    ];
    positions = List<Offset>.filled(dots.length, Offset.zero);

    links = [];
    if (!drawLinks) return;
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final i = row * cols + col;
        if (col + 1 < cols) links.add((i, i + 1));
        if (row + 1 < rows) links.add((i, i + cols));
        if (row + 1 < rows && col + 1 < cols) links.add((i, i + cols + 1));
        if (row + 1 < rows && col - 1 >= 0) links.add((i, i + cols - 1));
      }
    }
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.animation,
    required this.field,
    required this.seed,
    required this.spacing,
    required this.maxIntensity,
    required this.drawLinks,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final _ParticleField field;
  final int seed;
  final double spacing;
  final double maxIntensity;
  final bool drawLinks;

  static const Color _dotColor = Color(0xFFE4DAFF);
  static const Color _accentColor = Color(0xFFC084FC);
  static const Color _lineColor = Color(0xFF8B5CF6);

  final Paint _linkPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.7;
  final Paint _glowPaint = Paint();
  final Paint _dotPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    field.ensure(
      size: size,
      seed: seed,
      spacing: spacing,
      maxIntensity: maxIntensity,
      drawLinks: drawLinks,
    );
    final dots = field.dots;
    final positions = field.positions;
    final t = animation.value * 2 * math.pi;

    for (var i = 0; i < dots.length; i++) {
      final d = dots[i];
      positions[i] = Offset(
        d.x + math.sin(t * d.speed + d.phase) * d.amplitude,
        d.y + math.cos(t * d.speed * 0.8 + d.phase) * d.amplitude,
      );
    }

    if (field.links.isNotEmpty) {
      _linkPaint.color = _lineColor.withValues(alpha: 0.05 * maxIntensity);
      for (final (a, b) in field.links) {
        canvas.drawLine(positions[a], positions[b], _linkPaint);
      }
    }

    for (var i = 0; i < dots.length; i++) {
      final d = dots[i];
      final pos = positions[i];
      if (pos.dx < -20 ||
          pos.dy < -20 ||
          pos.dx > size.width + 20 ||
          pos.dy > size.height + 20) {
        continue;
      }
      if (d.accent) {
        _glowPaint.color = _accentColor.withValues(
          alpha: (0.10 * d.opacity).clamp(0.0, 0.18),
        );
        canvas.drawCircle(pos, d.radius * 4, _glowPaint);
      }
      _dotPaint.color = (d.accent ? _accentColor : _dotColor).withValues(
        alpha: d.opacity,
      );
      canvas.drawCircle(pos, d.radius, _dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) =>
      old.field != field ||
      old.seed != seed ||
      old.spacing != spacing ||
      old.maxIntensity != maxIntensity ||
      old.drawLinks != drawLinks;
}
