import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFF09090B);
  static const tile = Color(0xFF131316);
  static const tileHi = Color(0xFF1A1A1F);
  static const line = Color(0xFF24242A);
  static const lineHi = Color(0xFF34343C);
  static const ink = Color(0xFFFAFAFA);
  static const body = Color(0xFFC8C8CF);
  static const muted = Color(0xFF8E8E98);
  static const faint = Color(0xFF5F5F68);
  static const accent = Color(0xFFFFB547);
  static const accentInk = Color(0xFF241703);
  static const signal = Color(0xFF7CF29A);
  static const splitsy = Color(0xFF1DB954);
  static const splitsyDeep = Color(0xFF0B3D1F);
  static const splitsyInk = Color(0xFF03210F);
}

class AppType {
  static TextStyle display({
    double size = 40,
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.ink,
    double height = 1.02,
    double? letterSpacing,
  }) {
    return GoogleFonts.interTight(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing ?? -size * 0.035,
    );
  }

  static TextStyle sans({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.body,
    double height = 1.55,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.inter(
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
    double letterSpacing = 1.2,
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
      primary: AppColors.accent,
      surface: AppColors.bg,
      onSurface: AppColors.ink,
    ),
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.tileHi,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      textStyle: AppType.sans(size: 12, color: AppColors.ink, height: 1.2),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.tileHi,
      behavior: SnackBarBehavior.floating,
      contentTextStyle: AppType.sans(size: 14, color: AppColors.ink, height: 1.4),
    ),
  );
}

enum Breakpoint { narrow, medium, wide }

Breakpoint breakpointOf(double width) {
  if (width >= 1024) return Breakpoint.wide;
  if (width >= 700) return Breakpoint.medium;
  return Breakpoint.narrow;
}

double pagePadding(double width) => width < 700 ? 16 : 32;

const double bentoGap = 14;
