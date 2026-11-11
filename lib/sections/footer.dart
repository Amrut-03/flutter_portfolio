import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';

class Footer extends StatelessWidget {
  const Footer({super.key, required this.scrollToTop});

  final VoidCallback scrollToTop;

  @override
  Widget build(BuildContext context) {
    final padding = contentPaddingOf(context);
    final wide = deviceOf(context) == DeviceType.desktop;
    final backToTop = GradientButton(
      label: 'Back to Top',
      icon: Icons.arrow_upward_rounded,
      compact: true,
      outlined: true,
      onPressed: scrollToTop,
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
        color: AppColors.surface,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: wide ? 32 : 28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (wide)
                Row(children: [const _Logo(), const Spacer(), backToTop])
              else ...[
                const _Logo(),
                const SizedBox(height: 18),
                backToTop,
              ],
              const SizedBox(height: 22),
              Text(
                '© ${DateTime.now().year} Amrut Khochikar. Built with Flutter.',
                style: AppText.mono(11.5, letterSpacing: 0.8),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            'AK',
            style: AppText.mono(
              11.5,
              color: Colors.white,
              weight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Flexible(
          child: Text(
            'Amrut Khochikar — Flutter Developer',
            maxLines: 2,
            style: AppText.display(14.5, weight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
