import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // ---------------------------------------------------------------------------
  // 1. COLOR TOKENS
  // ---------------------------------------------------------------------------
  
  // Dark Mode (AMOLED Optimized)
  static const Color amoledBlack = Color(0xFF0D0D0F);
  static const Color surfaceDark = Color(0xFF1A1A1F);
  static const Color cardBgDark = Color(0xFF16161C);
  static const Color textPrimaryDark = Color(0xFFF0F0F5);
  static const Color textSecondaryDark = Color(0xFF8888A0);
  static const Color dividerDark = Color(0xFF2A2A35);

  // Light Mode (From Mockups)
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8F9FA);
  static const Color cardBgLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF111111);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color dividerLight = Color(0xFFEAEAEC);

  // Accent & Category Colors
  static const Color teal = Color(0xFF00E5D0);    // Medicine / Primary Actions
  static const Color purple = Color(0xFF9B6DFF);  // Pathology
  static const Color amber = Color(0xFFFFB547);   // Surgery / Hard Grade
  static const Color red = Color(0xFFFF5C5C);     // Overdue / Again Grade
  static const Color green = Color(0xFF3DDE8B);   // Success / Easy Grade
  static const Color blue = Color(0xFF4FC3F7);    // Pharmacology

  // ---------------------------------------------------------------------------
  // 2. PHYSICS & MOTION TOKENS
  // ---------------------------------------------------------------------------
  
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 800);
  
  // We use easeOutExpo to simulate iOS-style spring deceleration
  static const Curve springCurve = Curves.easeOutExpo;

  // ---------------------------------------------------------------------------
  // 3. TYPOGRAPHY ENGINE (System Font Stack with SF-Pro Tracking)
  // ---------------------------------------------------------------------------
  
  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: primary, letterSpacing: -1.0),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.8),
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.5),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primary, letterSpacing: -0.3),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primary, letterSpacing: -0.2),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primary, letterSpacing: 0.0),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: secondary, letterSpacing: 0.0),
      labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: secondary, letterSpacing: 0.3, uppercase: true),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. THEME BUILDERS
  // ---------------------------------------------------------------------------

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: surfaceLight,
      primaryColor: teal,
      colorScheme: const ColorScheme.light(
        primary: teal,
        surface: surfaceLight,
        error: red,
      ),
      textTheme: _buildTextTheme(textPrimaryLight, textSecondaryLight),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: teal,
        foregroundColor: pureWhite,
        elevation: 4,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: amoledBlack,
      primaryColor: teal,
      colorScheme: const ColorScheme.dark(
        primary: teal,
        surface: surfaceDark,
        error: red,
      ),
      textTheme: _buildTextTheme(textPrimaryDark, textSecondaryDark),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: teal,
        foregroundColor: pureWhite,
        elevation: 4,
      ),
    );
  }
}
