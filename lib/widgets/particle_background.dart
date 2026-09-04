import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Subtle drifting dot / constellation background. Purely decorative.
///
/// Performance on mobile:
///  - The animation is paused whenever this widget scrolls out of the
///    viewport (via [controller]), so it never repaints while off-screen.
///  - Links between dots are only drawn on wide screens; small screens get a
///    lighter dot density so the continuous drift stays cheap.
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({
    super.key,
    this.seed = 7,
    this.spacing = 62,
    this.maxIntensity = 0.35,
    this.controller,
  });

  final int seed;
  final double spacing;
  final double maxIntensity;
  final ScrollController? controller;

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _visible = true;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 46),
    );
    if (_visible) _controller.repeat();

    widget.controller?.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateVisibility();
      _checking = false;
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_checking) return;
    _checking = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateVisibility();
      _checking = false;
    });
  }

  void _updateVisibility() {
    if (!mounted) return;
    if (widget.controller == null || !widget.controller!.hasClients) return;
    final render = context.findRenderObject();
    if (render is! RenderBox || !render.attached) return;
    final top = render.localToGlobal(Offset.zero).dy;
    final height = render.size.height;
    final viewport = MediaQuery.sizeOf(context).height;
    final willPaint = top < viewport && top + height > 0;
    if (willPaint == _visible) return;
    setState(() => _visible = willPaint);
    if (willPaint) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Draw fewer dots on small screens and skip the connecting lines there.
    final width = MediaQuery.sizeOf(context).width;
    final drawLinks = width >= 640;
    final spacing = widget.spacing + (width < 480 ? 34 : 0);
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _ParticlePainter(
              progress: _controller.value,
              seed: widget.seed,
              spacing: spacing.clamp(34, 140),
              maxIntensity: widget.maxIntensity,
              drawLinks: drawLinks,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _Particle {
  _Particle({
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

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.progress,
    required this.seed,
    required this.spacing,
    required this.maxIntensity,
    this.drawLinks = true,
  });

  final double progress;
  final int seed;
  final double spacing;
  final double maxIntensity;
  final bool drawLinks;

  static const Color _dotColor = Color(0xFFBFE3FF);
  static const Color _accentColor = Color(0xFF22D3EE);
  static const Color _lineColor = Color(0xFF3B82F6);

  List<_Particle>? _cached;
  List<(int, int)>? _links;
  int _cacheW = 0;
  int _cacheH = 0;

  late int _state = seed;

  double _rand() {
    _state = (_state * 1103515245 + 12345) & 0x7fffffff;
    return _state / 0x7fffffff;
  }

  void _ensureDots(double width, double height) {
    final w = (width / 32).round() * 32;
    final h = (height / 32).round() * 32;
    if (_cached != null && _cacheW == w && _cacheH == h) return;
    _cacheW = w;
    _cacheH = h;
    _cached = [];
    _links = [];
    _state = seed;

    final cols = (width / spacing).ceil();
    final rows = (height / spacing).ceil();

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final cellX = col * spacing + (_rand() - 0.5) * spacing * 0.85;
        final cellY = row * spacing + (_rand() - 0.5) * spacing * 0.85;
        final accent = _rand() < 0.16;
        _cached!.add(
          _Particle(
            x: cellX,
            y: cellY,
            amplitude: 3 + _rand() * 5,
            phase: _rand() * 6.283,
            speed: 0.35 + _rand() * 0.85,
            radius: accent ? 1.1 + _rand() * 0.8 : 0.7 + _rand() * 0.8,
            opacity: (0.08 + _rand() * 0.22) * maxIntensity.clamp(0.05, 1.0),
            accent: accent,
          ),
        );
      }
    }

    // Links between horizontal / vertical / diagonal neighbours.
    if (drawLinks) {
      for (var row = 0; row < rows; row++) {
        for (var col = 0; col < cols; col++) {
          final i = row * cols + col;
          if (col + 1 < cols) _links!.add((i, i + 1));
          if (row + 1 < rows) _links!.add((i, i + cols));
          if (row + 1 < rows && col + 1 < cols) {
            _links!.add((i, i + cols + 1));
          }
          if (row + 1 < rows && col - 1 >= 0) _links!.add((i, i + cols - 1));
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    _ensureDots(size.width, size.height);
    final dots = _cached!;
    final links = _links!;
    final t = progress * 6.283;

    final positions = List<Offset>.filled(dots.length, Offset.zero);
    for (var i = 0; i < dots.length; i++) {
      final d = dots[i];
      positions[i] = Offset(
        d.x + math.sin(t * d.speed + d.phase) * d.amplitude,
        d.y + math.cos(t * d.speed * 0.8 + d.phase) * d.amplitude,
      );
    }

    if (drawLinks && links.isNotEmpty) {
      final linkPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.7
        ..color = _lineColor.withValues(alpha: 0.05 * maxIntensity);
      for (final (a, b) in links) {
        canvas.drawLine(positions[a], positions[b], linkPaint);
      }
    }

    final glowPaint = Paint();
    final dotPaint = Paint();
    for (var i = 0; i < dots.length; i++) {
      final d = dots[i];
      final pos = positions[i];
      if (pos.dx < -20 || pos.dy < -20 || pos.dx > size.width + 20 ||
          pos.dy > size.height + 20) {
        continue;
      }
      if (d.accent) {
        glowPaint.color =
            _accentColor.withValues(alpha: (0.10 * d.opacity).clamp(0.0, 0.18));
        canvas.drawCircle(pos, d.radius * 4, glowPaint);
      }
      dotPaint.color =
          (d.accent ? _accentColor : _dotColor).withValues(alpha: d.opacity);
      canvas.drawCircle(pos, d.radius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.seed != seed ||
      oldDelegate.spacing != spacing ||
      oldDelegate.maxIntensity != maxIntensity ||
      oldDelegate.drawLinks != drawLinks;
}