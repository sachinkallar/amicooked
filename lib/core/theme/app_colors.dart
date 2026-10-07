import 'package:flutter/material.dart';

class AppColors {
  // Base canvas colors
  static const Color background = Color(0xFF09090C);
  static const Color surface = Color(0xFF111116);
  static const Color surfaceElevated = Color(0xFF181820);
  static const Color surfaceHighlight = Color(0xFF22222D);
  static const Color border = Color(0x1AFFFFFF);
  static const Color borderGlow = Color(0x33FF4500);

  // Text colors
  static const Color textPrimary = Color(0xFFFAFAFA);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);
  static const Color textInverse = Color(0xFF09090C);

  // Fire / Heat Primary accents
  static const Color fireRed = Color(0xFFFF2D55);
  static const Color fireOrange = Color(0xFFFF5E00);
  static const Color fireAmber = Color(0xFFFF9500);
  static const Color fireYellow = Color(0xFFFFD60A);
  static const Color cookedPurple = Color(0xFFAF52DE);

  // Gradients
  static const LinearGradient fireGradient = LinearGradient(
    colors: [fireRed, fireOrange, fireAmber],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coldGradient = LinearGradient(
    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [Color(0x22FF5E00), Color(0x00000000)],
    radius: 0.8,
  );

  // Cooked Tier Colors
  static Color getTierColor(int score) {
    if (score <= 20) return const Color(0xFF10B981); // RAW 🥩
    if (score <= 40) return const Color(0xFFF59E0B); // TOASTED 🍞
    if (score <= 60) return const Color(0xFFFF8C00); // WARM 🌡️
    if (score <= 80) return const Color(0xFFFF4500); // PRETTY COOKED 🍗
    if (score <= 95) return const Color(0xFFDC2626); // ABSOLUTELY COOKED 💀
    return const Color(0xFFFF003C); // CALL FIRE BRIGADE 🚒🔥
  }

  static LinearGradient getTierGradient(int score) {
    if (score <= 20) {
      return const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (score <= 40) {
      return const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (score <= 60) {
      return const LinearGradient(
        colors: [Color(0xFFFF8C00), Color(0xFFEA580C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (score <= 80) {
      return const LinearGradient(
        colors: [Color(0xFFFF4500), Color(0xFFDC2626)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (score <= 95) {
      return const LinearGradient(
        colors: [Color(0xFFDC2626), Color(0xFF7F1D1D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFFFF003C), Color(0xFFFF5E00), Color(0xFFFFD60A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
