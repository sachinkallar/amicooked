import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle heroTitle({double fontSize = 56, Color? color}) =>
      GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.5,
        height: 1.05,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle headingLarge({double fontSize = 36, Color? color}) =>
      GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        height: 1.15,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle headingMedium({double fontSize = 24, Color? color}) =>
      GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle headingSmall({double fontSize = 20, Color? color}) =>
      GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle bodyLarge({double fontSize = 18, Color? color}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle bodyMedium({double fontSize = 15, Color? color}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle bodySmall({double fontSize = 13, Color? color}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textMuted,
      );

  static TextStyle label({double fontSize = 14, FontWeight weight = FontWeight.w600, Color? color}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: weight,
        letterSpacing: 0.2,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle mono({double fontSize = 14, FontWeight weight = FontWeight.w600, Color? color}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: weight,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle scoreDisplay({double fontSize = 84, Color? color}) =>
      GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        letterSpacing: -3.0,
        height: 0.95,
        color: color ?? AppColors.textPrimary,
      );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.fireOrange,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.fireOrange,
        secondary: AppColors.fireRed,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      dividerColor: AppColors.border,
      cardColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
