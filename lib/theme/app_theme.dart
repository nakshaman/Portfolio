import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFF0A0E17);
  static const surface = Color(0xFF11172A);
  static const surfaceAlt = Color(0xFF161D33);
  static const primary = Color(0xFF6C5CE7); // violet
  static const secondary = Color(0xFF00E0C7); // teal
  static const accent = Color(0xFFFF6FB5); // pink accent for highlights
  static const textPrimary = Color(0xFFF5F6FA);
  static const textSecondary = Color(0xFFA0A8C0);
  static const border = Color(0xFF232B47);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C5CE7), Color(0xFF00E0C7)],
  );
}

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      splashFactory: NoSplash.splashFactory,
      hoverColor: Colors.transparent,
    );
  }

  static TextStyle heading({double size = 40, FontWeight weight = FontWeight.w700}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, height: 1.15, color: AppColors.textPrimary);

  static TextStyle body({double size = 16, Color? color, FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, height: 1.6, color: color ?? AppColors.textSecondary);

  static TextStyle mono({double size = 14, Color? color}) =>
      GoogleFonts.jetBrainsMono(fontSize: size, color: color ?? AppColors.secondary);
}

/// Simple responsive breakpoints used across the site.
class Responsive {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 700;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 700 && MediaQuery.of(context).size.width < 1050;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1050;

  static double horizontalPadding(BuildContext context) {
    if (isMobile(context)) return 20;
    if (isTablet(context)) return 48;
    return 96;
  }

  static double maxContentWidth = 1200;
}
