import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Reusable section heading: monospace order tag + subtitle + big title.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.order,
    required this.label,
    required this.title,
    this.subtitle,
    this.center = false,
  });

  final String order;
  final String label;
  final String title;
  final String? subtitle;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final device = deviceOf(context);
    final titleStyle = switch (device) {
      DeviceType.mobile => Theme.of(context).textTheme.headlineLarge,
      DeviceType.tablet => Theme.of(context).textTheme.headlineLarge,
      DeviceType.desktop => Theme.of(context).textTheme.displayMedium,
    };

    final tag = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$order — ',
          style: AppText.mono(13,
              color: AppColors.cyan, letterSpacing: 1.6),
        ),
        Text(
          label.toUpperCase(),
          style: AppText.mono(13, letterSpacing: 3),
        ),
      ],
    );

    final divider = Container(
      height: 1,
      constraints: BoxConstraints(
        maxWidth: center ? 160 : double.infinity,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.blue.withValues(alpha: 0.8),
            AppColors.cyan.withValues(alpha: 0.15),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (!center) ...[
          Row(
            children: [
              tag,
              const SizedBox(width: 18),
              Expanded(child: divider),
            ],
          ),
        ] else
          Column(
            children: [
              tag,
              const SizedBox(height: 12),
              divider,
            ],
          ),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: center ? TextAlign.center : null,
          style: titleStyle,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              subtitle!,
              textAlign: center ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ],
    );
  }
}