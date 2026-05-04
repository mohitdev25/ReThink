import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF1A1A1D); // Deep dark for glass effect
  static const Color surface = Color(0xFF2C2C30);

  // Glass colors
  static const Color glassWhite = Color(0x1AFFFFFF); // 10% white
  static const Color glassWhiteStrong = Color(0x33FFFFFF); // 20% white
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassInnerGlow = Color(0x1AFFFFFF);

  // Accents
  static const Color primary = Color(0xFF4A90E2); // iOS-like blue
  static const Color primaryGlow = Color(0x404A90E2);

  static const Color success = Color(0xFF34C759); // iOS-like green
  static const Color warning = Color(0xFFFF9F0A); // iOS-like orange
  static const Color error = Color(0xFFFF453A);   // iOS-like red

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0x99FFFFFF); // 60% white
  static const Color textTertiary = Color(0x66FFFFFF); // 40% white
}
