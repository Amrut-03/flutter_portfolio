import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/anchors.dart';
import '../core/resume_download.dart';
import '../theme/app_theme.dart';
import '../widgets/grad_text.dart';
import '../widgets/gradient_button.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    super.key,
    required this.controller,
    required this.anchors,
    required this.onNavigate,
  });

  final ScrollController controller;
  final Anchors anchors;
  final void Function(String id) onNavigate;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  static const _items = [
    (id: 'about', label: 'About'),
    (id: 'experience', label: 'Experience'),
    (id: 'skills', label: 'Skills'),
    (id: 'projects', label: 'Projects'),
    (id: 'achievements', label: 'Achievements'),
    (id: 'contact', label: 'Contact'),
  ];

  bool _scrolled = false;
  bool _menuOpen = false;
  String? _active;

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
    final offset = widget.controller.offset;
    String? active;
    var bestTop = -1e9;
    for (final item in _items) {
      final context = widget.anchors.keyFor(item.id)?.currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      final top = box.localToGlobal(Offset.zero).dy;
      if (top <= 116 && top > bestTop) {
        bestTop = top;
        active = item.id;
      }
    }
    if (mounted) {
      setState(() {
        _scrolled = offset > 10;
        _active = active;
      });
    }
  }

  void _navigate(String id) {
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
                    Flexible(
                      flex: 1,
                      child: _Logo(
                        onTap: () => _navigate('about'),
                        compact: MediaQuery.sizeOf(context).width < 390,
                      ),
                    ),
                    if (!isCompact) ...[
                      ..._items.map((item) => _NavLink(
                            label: item.label,
                            active: _active == item.id,
                            onTap: () => _navigate(item.id),
                          )),
                      const SizedBox(width: 6),
                      GradientButton(
                        label: 'Resume',
                        icon: Icons.download_rounded,
                        compact: true,
                        onPressed: downloadResume,
                      ),
                    ] else ...[
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
                        tooltip: 'Menu',
                      ),
                    ],
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
                          for (final item in _items)
                            _MobileLink(
                              label: item.label,
                              active: _active == item.id,
                              onTap: () => _navigate(item.id),
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
                              downloadResume();
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
  const _Logo({this.onTap, this.compact = false});

  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
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
                style: AppText.mono(15,
                    color: Colors.white, weight: FontWeight.w700),
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
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: compact ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Flutter Developer',
                      style: AppText.mono(10.5,
                          color: AppColors.cyan, letterSpacing: 1.4),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, required this.active, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.active
        ? Colors.white
        : (_hovered ? AppColors.textPrimary : AppColors.textSecondary);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Text(
            widget.label,
            style: AppText.mono(13,
                color: color, weight: FontWeight.w500, letterSpacing: 0.6),
          ),
        ),
      ),
    );
  }
}

class _MobileLink extends StatelessWidget {
  const _MobileLink({required this.label, required this.active, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        color: active
            ? AppColors.blue.withValues(alpha: 0.08)
            : Colors.transparent,
        child: Row(
          children: [
            if (active) ...[
              GradientText(
                '▸ ',
                style: AppText.mono(13, color: Colors.white, weight: FontWeight.w500),
                gradient: AppColors.primaryGradient,
              ),
            ],
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