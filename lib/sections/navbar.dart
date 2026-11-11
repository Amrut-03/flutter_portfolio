import 'package:flutter/material.dart';

import '../core/anchors.dart';
import '../core/platform/browser.dart';
import '../theme/app_theme.dart';
import '../widgets/grad_text.dart';
import '../widgets/gradient_button.dart';
import '../widgets/pressable.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    super.key,
    required this.controller,
    required this.anchors,
    required this.onNavigate,
  });

  final ScrollController controller;
  final Anchors anchors;
  final ValueChanged<SectionId> onNavigate;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _scrolled = false;
  bool _menuOpen = false;
  SectionId? _active;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final scrolled = widget.controller.offset > 10;
    SectionId? active;
    var bestTop = double.negativeInfinity;
    for (final id in SectionId.values) {
      final box =
          widget.anchors[id].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      final top = box.localToGlobal(Offset.zero).dy;
      if (top <= AppTheme.navBarHeight + 40 && top > bestTop) {
        bestTop = top;
        active = id;
      }
    }
    // Only rebuild when something visible actually changed.
    if (scrolled == _scrolled && active == _active) return;
    if (active != _active) {
      Browser.replaceFragment(
        active == null || active == SectionId.about ? null : active.name,
      );
    }
    setState(() {
      _scrolled = scrolled;
      _active = active;
    });
  }

  void _navigate(SectionId id) {
    setState(() => _menuOpen = false);
    widget.onNavigate(id);
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = useCompactNav(context);
    final navColor = (_scrolled || _menuOpen)
        ? const Color(0xEA160F26)
        : const Color(0xA6160F26);

    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        decoration: BoxDecoration(
          color: navColor,
          border: Border(
            bottom: BorderSide(
              color: _scrolled ? AppColors.border : Colors.transparent,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: AppTheme.navBarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _Logo(
                          onTap: () => _navigate(SectionId.about),
                          compact: MediaQuery.sizeOf(context).width < 390,
                        ),
                      ),
                    ),
                    if (!isCompact) ...[
                      for (final id in SectionId.values)
                        _NavLink(
                          label: id.label,
                          active: _active == id,
                          onTap: () => _navigate(id),
                        ),
                      const SizedBox(width: 6),
                      const GradientButton(
                        label: 'Resume',
                        icon: Icons.download_rounded,
                        compact: true,
                        onPressed: Browser.downloadResume,
                      ),
                    ] else
                      IconButton(
                        onPressed: () => setState(() => _menuOpen = !_menuOpen),
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            _menuOpen
                                ? Icons.close_rounded
                                : Icons.menu_rounded,
                            key: ValueKey(_menuOpen),
                            color: AppColors.textPrimary,
                          ),
                        ),
                        tooltip: _menuOpen ? 'Close menu' : 'Open menu',
                      ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: !_menuOpen
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final id in SectionId.values)
                          _MobileLink(
                            label: id.label,
                            active: _active == id,
                            onTap: () => _navigate(id),
                          ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.border,
                        ),
                        _MobileLink(
                          label: 'Resume',
                          active: false,
                          onTap: () {
                            setState(() => _menuOpen = false);
                            Browser.downloadResume();
                          },
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

class _Logo extends StatelessWidget {
  const _Logo({required this.onTap, this.compact = false});

  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: 'Amrut Khochikar — back to top',
      builder: (context, highlighted) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              border: highlighted
                  ? Border.all(color: Colors.white, width: 1.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: -4,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'AK',
              style: AppText.mono(
                15,
                color: Colors.white,
                weight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amrut Khochikar',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.display(
                    compact ? 14 : 15,
                    weight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Flutter · AI Apps',
                    style: AppText.mono(
                      10.5,
                      color: AppColors.cyan,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      builder: (context, highlighted) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Text(
          label,
          style:
              AppText.mono(
                13,
                color: active
                    ? Colors.white
                    : (highlighted
                          ? AppColors.textPrimary
                          : AppColors.textSecondary),
                letterSpacing: 0.6,
              ).copyWith(
                decoration: highlighted ? TextDecoration.underline : null,
                decorationColor: AppColors.cyan,
              ),
        ),
      ),
    );
  }
}

class _MobileLink extends StatelessWidget {
  const _MobileLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      builder: (context, highlighted) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        color: active || highlighted
            ? AppColors.blue.withValues(alpha: 0.08)
            : Colors.transparent,
        child: Row(
          children: [
            if (active)
              GradientText('▸ ', style: AppText.mono(13, color: Colors.white)),
            Text(
              label,
              style: AppText.mono(
                14,
                color: active ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
