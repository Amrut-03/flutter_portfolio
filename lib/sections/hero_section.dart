import 'package:flutter/material.dart';

import '../core/anchors.dart';
import '../core/open.dart';
import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/grad_text.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hover_card.dart';
import '../widgets/particle_background.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/tech_chip.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.anchors,
    required this.controller,
  });

  final Anchors anchors;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final device = deviceOf(context);
    final isDesktop = device == DeviceType.desktop;
    final padding = contentPaddingOf(context);
    final wideHeadline = isDesktop ? 46.0 : 38.0;
    final narrowHeadline = device == DeviceType.mobile ? 30.0 : 32.0;

    return Container(
      key: anchors.about,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.2, -0.6),
          radius: 1.15,
          colors: [Color(0x22FFFFFF), Colors.transparent],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ParticleBackground(
              maxIntensity: 0.42,
              controller: controller,
            ),
          ),          // Decorative glow blobs.
          Positioned(
            top: -140,
            right: -120,
            child: _GlowBlob(
              size: 420,
              colors: const [Color(0x333B82F6), Color(0x003B82F6)],
            ),
          ),
          Positioned(
            top: 320,
            left: -180,
            child: _GlowBlob(
              size: 380,
              colors: const [Color(0x228B5CF6), Color(0x008B5CF6)],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                padding, AppTheme.navBarHeight + 48, padding, 96),
            child: ScrollReveal(
              controller: controller,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxContentWidth),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Use the device breakpoint (>=1025 desktop) for the
                    // side-by-side layout so it appears at the right widths.
                    final isDesktop = deviceOf(context) == DeviceType.desktop;
                    final left = _LeftPane(
                      device: isDesktop ? DeviceType.desktop : device,
                      headlineSize: isDesktop ? wideHeadline : narrowHeadline,
                    );
                    if (!isDesktop) {
                      return Column(
                        children: [
                          left,
                          const SizedBox(height: 48),
                          const _TerminalCard(),
                          const SizedBox(height: 64),
                          const _ScrollHint(),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: left),
                            const SizedBox(width: 48,),

                            const Expanded(flex: 2, child: _TerminalCard()),
                          ],
                        ),
                        const SizedBox(height: 72),
                        const _ScrollHint(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeftPane extends StatelessWidget {
  const _LeftPane({required this.device, required this.headlineSize});

  final DeviceType device;
  final double headlineSize;

  @override
  Widget build(BuildContext context) {
    final desktop = device == DeviceType.desktop;
    return Column(
      crossAxisAlignment: desktop
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.center,
      children: [
        _ProfilePhoto(center: !desktop),
        const SizedBox(height: 28),
        _AboutBadge(center: !desktop),
        const SizedBox(height: 28),
        GradientText(
          'Building Scalable Cross-Platform Apps with Flutter',
          textAlign: desktop ? TextAlign.start : TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: headlineSize,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          'Specializing in Clean Architecture, BLoC state management, and Firebase-backed Flutter applications — from pixel-perfect UI to production REST/Firebase integration.',
          textAlign: desktop ? TextAlign.start : TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 28),
        Wrap(
          alignment: desktop
              ? WrapAlignment.start
              : WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            _ContactChip(
              icon: Icons.location_on_rounded,
              label: AppLinks.location,
            ),
            _ContactChip(
              icon: Icons.mail_rounded,
              label: AppLinks.email,
              onTap: () => openUrl(AppLinks.mailto),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // TODO: Links below are placeholders — swap them in portfolio_data.dart.
        _QuoteCard(center: !desktop),
        const SizedBox(height: 26),
        Wrap(
          alignment: desktop
              ? WrapAlignment.start
              : WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            GradientButton(
              label: 'GitHub',
              icon: Icons.code_rounded,
              outlined: true,
              compact: true,
              onPressed: () => openUrl(AppLinks.github),
            ),
            GradientButton(
              label: 'LinkedIn',
              icon: Icons.business_center_rounded,
              outlined: true,
              compact: true,
              onPressed: () => openUrl(AppLinks.linkedin),
            ),
            GradientButton(
              label: 'LeetCode',
              icon: Icons.terminal_rounded,
              outlined: true,
              compact: true,
              onPressed: () => openUrl(AppLinks.leetcode),
            ),
          ],
        ),
      ],
    );
  }
}

class _AboutBadge extends StatelessWidget {
  const _AboutBadge({required this.center});

  final bool center;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.12),
            blurRadius: 18,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.cyan,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.7),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'ABOUT ME',
            style: AppText.mono(11.5, letterSpacing: 2.4),
          ),
        ],
      ),
    );
    return center ? Center(child: chip) : chip;
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({required this.center});

  final bool center;

  static const double _size = 200;
  static const double _borderWidth = 3.5;

  @override
  Widget build(BuildContext context) {
    final photo = Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.3),
            blurRadius: 32,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.15),
            blurRadius: 48,
            spreadRadius: -8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(_borderWidth),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/images/profile.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _InitialsAvatar(),
        ),
      ),
    );
    return center ? Center(child: photo) : photo;
  }
}

class _InitialsAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
      ),
      alignment: Alignment.center,
      child: Text(
        'AK',
        style: TextStyle(
          color: Colors.white,
          fontSize: _ProfilePhoto._size * 0.3,
          fontWeight: FontWeight.w700,
          fontFamily: AppText.displayFont,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TechChip(
      label,
      onTap: onTap,
      dotColor: onTap != null ? AppColors.cyan : null,
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.center});

  final bool center;

  @override
  Widget build(BuildContext context) {
    final constraints = center ? const BoxConstraints(maxWidth: 760) : null;
    return ConstrainedBox(
      constraints:
          constraints ?? const BoxConstraints(maxWidth: 780),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: const Text(
                '❝',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  height: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Computer Science graduate (B.Tech, CGPA 6.9) with hands-on experience building production-grade Flutter applications using Clean Architecture, BLoC state management, and Firebase — from UI to backend integration.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.textPrimary,
                      fontFamily: AppText.displayFont,
                      fontWeight: FontWeight.w500,
                      height: 1.55,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TerminalCard extends StatelessWidget {
  const _TerminalCard();

  static const _lines = [
    r'aditya@flutter:~$ whoami',
    'aditya-khochikar · Flutter Developer',
    r'aditya@flutter:~$ ls ./architecture',
    'clean/  bloc/  repositories/  features/',
    r'aditya@flutter:~$ cat firebase.txt',
    'auth · cloud_firestore · realtime',
    r'aditya@flutter:~$ status',
    'Open to opportunities ✓',
  ];

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      radius: 18,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                for (final color
                    in const [Color(0xFFF87171), Color(0xFFFBBF24), Color(0xFF34D399)])
                  Container(
                    width: 11,
                    height: 11,
                    margin: const EdgeInsets.only(right: 7),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'shell — ~/portfolio',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.mono(11.5, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _lines.length; i++) ...[
                  _TerminalLine(
                    text: _lines[i],
                    isPrompt: i.isEven,
                  ),
                  if (i < _lines.length - 1) const SizedBox(height: 9),
                ],
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.cyan.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded,
                          size: 15, color: AppColors.cyan),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Clean Architecture · BLoC · Firebase',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                            fontFamily: AppText.monoFont,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalLine extends StatelessWidget {
  const _TerminalLine({required this.text, required this.isPrompt});

  final String text;
  final bool isPrompt;

  @override
  Widget build(BuildContext context) {
    final promptColor = isPrompt ? AppColors.cyan : AppColors.textSecondary;
    return RichText(
      text: TextSpan(
        style: AppText.mono(12, color: AppColors.textSecondary, height: 1.5),
        children: isPrompt
            ? [
                TextSpan(
                  text: '❯ ',
                  style: AppText.mono(12,
                      color: AppColors.cyan, weight: FontWeight.w700),
                ),
                TextSpan(text: text.substring(text.indexOf(r'$') + 1)),
              ]
            : [
                TextSpan(text: text, style: TextStyle(color: promptColor)),
              ],
      ),
    );
  }
}

class _ScrollHint extends StatelessWidget {
  const _ScrollHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 26,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.textMuted.withValues(alpha: 0.6)),
            ),
            padding: const EdgeInsets.only(top: 6),
            child: const Align(
              alignment: Alignment.topCenter,
              child: _ScrollDot(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'SCROLL',
            style: AppText.mono(10, color: AppColors.textMuted, letterSpacing: 3),
          ),
        ],
      ),
    );
  }
}

class _ScrollDot extends StatefulWidget {
  const _ScrollDot();

  @override
  State<_ScrollDot> createState() => _ScrollDotState();
}

class _ScrollDotState extends State<_ScrollDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, 4 + _controller.value * 14),
        child: Opacity(
          opacity: 1 - _controller.value,
          child: Container(
            width: 4,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.cyan,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}