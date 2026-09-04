import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF070B14);
  static const Color surface = Color(0xFF0B1322);
  static const Color surfaceAlt = Color(0xFF0F1B2E);
  static const Color surfaceGlass = Color(0x0F15233A);

  static const Color border = Color(0xFF1E2C45);
  static const Color borderBright = Color(0xFF2E4366);

  static const Color textPrimary = Color(0xFFE8EEF9);
  static const Color textSecondary = Color(0xFF92A4C0);
  static const Color textMuted = Color(0xFF5C6E8C);

  static const Color blue = Color(0xFF3B82F6);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color purple = Color(0xFF8B5CF6);

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
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const List<Color> dotPalette = [
    cyan,
    blue,
    purple,
    statusGreen,
    Color(0xFFF472B6),
    statusAmber,
  ];
}

class AppText {
  AppText._();

  static const String displayFont = 'SpaceGrotesk';
  static const String bodyFont = 'Inter';
  static const String monoFont = 'JetBrainsMono';

  static TextStyle mono(double size,
      {Color? color,
      FontWeight weight = FontWeight.w500,
      double? letterSpacing,
      double? height}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      color: color ?? AppColors.textSecondary,
      fontWeight: weight,
      letterSpacing: letterSpacing ?? 1.1,
      height: height,
    );
  }
}

class AppTheme {
  AppTheme._();

  static const double navBarHeight = 76;

  static ThemeData get dark {
    final scheme = const ColorScheme.dark(
      primary: AppColors.blue,
      secondary: AppColors.cyan,
      tertiary: AppColors.purple,
      surface: AppColors.background,
      onPrimary: Colors.white,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
    );

    final baseText = GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.dark, useMaterial3: true).textTheme,
    );

    final textTheme = baseText.copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 56,
        height: 1.08,
        letterSpacing: -1.6,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 42,
        height: 1.12,
        letterSpacing: -1.1,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        height: 1.16,
        letterSpacing: -0.7,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 25,
        height: 1.2,
        letterSpacing: -0.4,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: 20,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 17,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 15,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14.5,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 13,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppText.bodyFont,
      textTheme: textTheme,
      dividerColor: AppColors.border,
      // Use the standard ink ripple instead of InkSparkle, which requires the
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
        selectionColor: Color(0x3322D3EE),
        selectionHandleColor: AppColors.cyan,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: GoogleFonts.inter(
          fontSize: 14.5,
          color: AppColors.textMuted,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14.5,
          color: AppColors.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cyan, width: 1.4),
        ),
      ),
    );
  }
}

enum DeviceType { mobile, tablet, desktop }

/// Responsive breakpoints:
///   mobile  : < 480
///   tablet  : 481 – 1024
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
/// Set high enough that the inline links + resume button always fit without
/// overflowing on desktop.
bool useCompactNav(BuildContext context) =>
    MediaQuery.sizeOf(context).width < 1180;

const double maxContentWidth = 1200;