import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFF0C0B09);
  static const raised = Color(0xFF16140F);
  static const ink = Color(0xFFF6F1E7);
  static const body = Color(0xFFD4CBBC);
  static const muted = Color(0xFFA89E90);
  static const faint = Color(0xFF7A7268);
  static const line = Color(0xFF2E2A24);
  static const copper = Color(0xFFE2A15C);
  static const copperInk = Color(0xFF1C140C);
  static const signal = Color(0xFFC6F25A);
}

class AppType {
  static TextStyle serif({
    double size = 18,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.ink,
    double height = 1.15,
    double letterSpacing = -0.4,
    FontStyle style = FontStyle.normal,
  }) {
    return GoogleFonts.newsreader(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontStyle: style,
    );
  }

  static TextStyle sans({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.body,
    double height = 1.55,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle mono({
    double size = 12,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.muted,
    double letterSpacing = 1.4,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.4,
      letterSpacing: letterSpacing,
    );
  }
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.copper,
      surface: AppColors.bg,
      onSurface: AppColors.ink,
    ),
  );

  return base.copyWith(
    textTheme: GoogleFonts.manropeTextTheme(base.textTheme).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.raised,
      behavior: SnackBarBehavior.floating,
      contentTextStyle: AppType.sans(size: 14, color: AppColors.ink, height: 1.4),
    ),
  );
}

double pagePadding(double width) => width < 720 ? 20 : 40;

double headlineSize(double width) {
  if (width < 420) return 38;
  if (width < 720) return 50;
  if (width < 1100) return 66;
  return 78;
}
