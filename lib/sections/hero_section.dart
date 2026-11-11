import 'package:flutter/material.dart';

import '../core/anchors.dart';
import '../core/open.dart';
import '../core/platform/browser.dart';
import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/grad_text.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hover_card.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/tech_chip.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onNavigate});

  final ValueChanged<SectionId> onNavigate;

  @override
  Widget build(BuildContext context) {
    final device = deviceOf(context);
    final isDesktop = device == DeviceType.desktop;
    final padding = contentPaddingOf(context);
    final left = _LeftPane(
      desktop: isDesktop,
      headlineSize: switch (device) {
        DeviceType.desktop => 46,
        DeviceType.tablet => 34,
        DeviceType.mobile => 30,
      },
      onNavigate: onNavigate,
    );

    return Container(
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
          const Positioned(
            top: -140,
            right: -120,
            child: _GlowBlob(
              size: 420,
              colors: [Color(0x338B5CF6), Color(0x008B5CF6)],
            ),
          ),
          const Positioned(
            top: 320,
            left: -180,
            child: _GlowBlob(
              size: 380,
              colors: [Color(0x22E879F9), Color(0x00E879F9)],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              padding,
              AppTheme.navBarHeight + 48,
              padding,
              96,
            ),
            child: Center(
              child: ScrollReveal(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: maxContentWidth),
                  child: Column(
                    children: [
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: left),
                            const SizedBox(width: 36),
                            const Expanded(flex: 3, child: _TerminalCard()),
                          ],
                        )
                      else ...[
                        left,
                        const SizedBox(height: 36),
                        const _TerminalCard(),
                      ],
                      SizedBox(height: isDesktop ? 56 : 48),
                      const _ScrollHint(),
                    ],
                  ),
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
  const _LeftPane({
    required this.desktop,
    required this.headlineSize,
    required this.onNavigate,
  });

  final bool desktop;
  final double headlineSize;
  final ValueChanged<SectionId> onNavigate;

  @override
  Widget build(BuildContext context) {
    // Desktop: everything start-aligned next to the terminal card.
    // Mobile / tablet: everything centred in a single column.
    final textAlign = desktop ? TextAlign.start : TextAlign.center;
    final wrapAlign = desktop ? WrapAlignment.start : WrapAlignment.center;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: desktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        const _ProfilePhoto(),
        const SizedBox(height: 28),
        const _StatusBadge(),
        const SizedBox(height: 24),
        Semantics(
          header: true,
          child: GradientText(
            'Building AI-Powered Mobile Apps with Flutter',
            textAlign: textAlign,
            style: textTheme.displayLarge!.copyWith(fontSize: headlineSize),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "I'm Amrut, a Flutter developer in Bengaluru. I build production apps with "
          'Clean Architecture, Bloc and Riverpod, and Firebase, with a focus on '
          'offline-first design and on-device AI using Google Gemma 3n and TensorFlow Lite.',
          textAlign: textAlign,
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 28),
        Wrap(
          alignment: wrapAlign,
          spacing: 10,
          runSpacing: 10,
          children: [
            const TechChip(AppLinks.location),
            TechChip(
              AppLinks.email,
              dotColor: AppColors.cyan,
              onTap: () => openUrl(AppLinks.mailto),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _LatestWorkCard(onTap: () => onNavigate(SectionId.projects)),
        const SizedBox(height: 26),
        Wrap(
          alignment: wrapAlign,
          spacing: 10,
          runSpacing: 10,
          children: [
            GradientButton(
              label: 'Email Me',
              icon: Icons.mail_rounded,
              isLink: true,
              onPressed: () => openUrl(AppLinks.mailto),
            ),
            const GradientButton(
              label: 'Resume',
              icon: Icons.download_rounded,
              outlined: true,
              compact: true,
              onPressed: Browser.downloadResume,
            ),
            GradientButton(
              label: 'View Projects',
              icon: Icons.arrow_downward_rounded,
              outlined: true,
              compact: true,
              onPressed: () => onNavigate(SectionId.projects),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.statusGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.statusGreen.withValues(alpha: 0.7),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'OPEN TO OPPORTUNITIES',
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: AppText.mono(11.5, letterSpacing: 1.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto();

  static const double size = 200;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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
      padding: const EdgeInsets.all(3.5),
      child: ClipOval(
        child: Image.asset(
          'assets/images/profile.jpeg',
          fit: BoxFit.cover,
          semanticLabel: 'Photo of Amrut Khochikar',
          errorBuilder: (_, _, _) => const _InitialsAvatar(),
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(
        child: Text(
          'AK',
          style: AppText.display(
            _ProfilePhoto.size * 0.3,
            color: Colors.white,
          ).copyWith(letterSpacing: 2),
        ),
      ),
    );
  }
}

/// Highlights the most recent project and jumps to the projects section.
class _LatestWorkCard extends StatelessWidget {
  const _LatestWorkCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: HoverCard(
        radius: 16,
        padding: const EdgeInsets.all(18),
        onTap: onTap,
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
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LATEST WORK',
                    style: AppText.mono(
                      11,
                      color: AppColors.cyan,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'ExpenseFlow: an offline-first expense app whose on-device AI assistant '
                    '(Gemma 3n + TensorFlow Lite) gives private budgeting and saving tips.',
                    style: textTheme.bodyMedium!.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: AppColors.textMuted,
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
    (r'whoami', 'amrut-khochikar · Flutter Developer'),
    (r'ls ./architecture', 'clean/  bloc/  riverpod/  provider/'),
    (r'cat ai.txt', 'gemma-3n · tflite · on-device'),
    (r'cat firebase.txt', 'auth · firestore · offline sync'),
    (r'status', 'Open to opportunities ✓'),
  ];

  @override
  Widget build(BuildContext context) {
    final mono = AppText.mono(12, height: 1.5);
    return ExcludeSemantics(
      child: HoverCard(
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
                  for (final color in const [
                    AppColors.statusRed,
                    AppColors.statusAmber,
                    AppColors.statusGreen,
                  ])
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (command, output) in _lines) ...[
                    Text.rich(
                      TextSpan(
                        style: mono,
                        children: [
                          TextSpan(
                            text: '❯ ',
                            style: mono.copyWith(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: command),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(output, style: mono),
                    const SizedBox(height: 6),
                  ],
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.cyan.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          size: 15,
                          color: AppColors.cyan,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'Bloc · Riverpod · Firebase · On-device AI',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.mono(11.5, letterSpacing: 0.5),
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
      ),
    );
  }
}

class _ScrollHint extends StatelessWidget {
  const _ScrollHint();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Column(
        children: [
          Container(
            width: 26,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.textMuted.withValues(alpha: 0.6),
              ),
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
            style: AppText.mono(
              10,
              color: AppColors.textMuted,
              letterSpacing: 3,
            ),
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
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotionOf(context)) {
      _controller
        ..stop()
        ..value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 4,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.cyan,
        borderRadius: BorderRadius.circular(4),
      ),
    );
    return AnimatedBuilder(
      animation: _controller,
      child: dot,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, 4 + _controller.value * 14),
        child: Opacity(opacity: 1 - _controller.value, child: child),
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
