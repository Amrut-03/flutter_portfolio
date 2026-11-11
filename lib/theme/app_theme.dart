import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color background = Color(0xFF0F0A1E);
  static const Color surface = Color(0xFF160F26);
  static const Color surfaceAlt = Color(0xFF1E1633);

  static const Color border = Color(0xFF302549);

  static const Color textPrimary = Color(0xFFF2ECFC);
  static const Color textSecondary = Color(0xFFBEADD9);
  static const Color textMuted = Color(0xFF8070A3);

  static const Color blue = Color(0xFF8B5CF6);
  static const Color cyan = Color(0xFFC084FC);
  static const Color purple = Color(0xFFE879F9);

  static const Color statusGreen = Color(0xFF34D399);
  static const Color statusAmber = Color(0xFFFBBF24);
  static const Color statusRed = Color(0xFFF87171);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [blue, cyan, purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueCyanGradient = LinearGradient(
    colors: [blue, cyan],
  );

  static const List<Color> dotPalette = [
    cyan,
    blue,
    purple,
    statusGreen,
    Color(0xFFA855F7),
    statusAmber,
  ];
}

/// Font families are bundled in `assets/fonts` and registered in pubspec.yaml.
abstract final class AppText {
  static const String displayFont = 'SpaceGrotesk';
  static const String bodyFont = 'Inter';
  static const String monoFont = 'JetBrainsMono';

  static TextStyle mono(
    double size, {
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: monoFont,
      fontSize: size,
      color: color ?? AppColors.textSecondary,
      fontWeight: weight,
      letterSpacing: letterSpacing ?? 1.1,
      height: height,
    );
  }

  static TextStyle display(
    double size, {
    FontWeight weight = FontWeight.w700,
    double? height,
    double? letterSpacing,
    Color color = AppColors.textPrimary,
  }) {
    return TextStyle(
      fontFamily: displayFont,
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
      fontWeight: weight,
      color: color,
    );
  }

  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w400,
    double? height,
    Color color = AppColors.textSecondary,
  }) {
    return TextStyle(
      fontFamily: bodyFont,
      fontSize: size,
      height: height,
      fontWeight: weight,
      color: color,
    );
  }
}

abstract final class AppTheme {
  static const double navBarHeight = 76;

  /// Built once; MaterialApp rebuilds no longer recreate ThemeData.
  static final ThemeData dark = _buildDark();

  static ThemeData _buildDark() {
    const scheme = ColorScheme.dark(
      primary: AppColors.blue,
      secondary: AppColors.cyan,
      tertiary: AppColors.purple,
      surface: AppColors.background,
      onPrimary: Colors.white,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
    );

    final textTheme = TextTheme(
      displayLarge: AppText.display(56, height: 1.08, letterSpacing: -1.6),
      displayMedium: AppText.display(42, height: 1.12, letterSpacing: -1.1),
      headlineLarge: AppText.display(32, height: 1.16, letterSpacing: -0.7),
      headlineMedium: AppText.display(
        25,
        height: 1.2,
        letterSpacing: -0.4,
        weight: FontWeight.w600,
      ),
      headlineSmall: AppText.display(20, height: 1.25, weight: FontWeight.w600),
      titleLarge: AppText.display(17, height: 1.3, weight: FontWeight.w600),
      titleMedium: AppText.body(
        15,
        height: 1.35,
        weight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: AppText.body(16, height: 1.6),
      bodyMedium: AppText.body(14.5, height: 1.6),
      bodySmall: AppText.body(13, height: 1.55, color: AppColors.textMuted),
      labelLarge: AppText.body(
        14,
        height: 1.2,
        weight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );

    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppText.bodyFont,
      textTheme: textTheme,
      dividerColor: AppColors.border,
      // Standard ink ripple instead of InkSparkle, which needs the
      // ink_sparkle.frag shader asset (missing in tests and some web builds).
      splashFactory: InkRipple.splashFactory,
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        textStyle: AppText.mono(12, color: AppColors.textPrimary),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.cyan,
        selectionColor: Color(0x55C084FC),
        selectionHandleColor: AppColors.cyan,
      ),
      focusColor: AppColors.cyan.withValues(alpha: 0.18),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppText.body(14.5, color: AppColors.textMuted),
        labelStyle: AppText.body(14.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: border(AppColors.border),
        enabledBorder: border(AppColors.border),
        focusedBorder: border(AppColors.cyan, 1.4),
        errorBorder: border(AppColors.statusRed),
        focusedErrorBorder: border(AppColors.statusRed, 1.4),
      ),
    );
  }
}

enum DeviceType { mobile, tablet, desktop }

/// Responsive breakpoints:
///   mobile  : < 480
///   tablet  : 480 – 1024
///   desktop : 1025+
DeviceType deviceOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 480) return DeviceType.mobile;
  if (width < 1025) return DeviceType.tablet;
  return DeviceType.desktop;
}

double contentPaddingOf(BuildContext context) => switch (deviceOf(context)) {
  DeviceType.mobile => 20,
  DeviceType.tablet => 36,
  DeviceType.desktop => 64,
};

/// Collapses the navbar into a compact hamburger menu below this width.
bool useCompactNav(BuildContext context) =>
    MediaQuery.sizeOf(context).width < 1180;

/// True when the OS / browser asks for reduced motion.
bool reduceMotionOf(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

const double maxContentWidth = 1200;
