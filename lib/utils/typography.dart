// lib/utils/typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// 8-point spacing system
class AppSpacing {
  AppSpacing._();

  static const double x1 = 8.0;
  static const double x2 = 16.0;
  static const double x3 = 24.0;
  static const double x4 = 32.0;
  static const double x5 = 40.0;
  static const double x6 = 48.0;
  static const double x7 = 56.0;
  static const double x8 = 64.0;

  // Semantic aliases
  static const double xs   = x1;   // 8
  static const double sm   = x2;   // 16
  static const double md   = x3;   // 24
  static const double lg   = x4;   // 32
  static const double xl   = x5;   // 40
  static const double xxl  = x6;   // 48
}

/// Border radius tokens
class AppRadius {
  AppRadius._();

  static const double button = 16.0;  // CTA buttons
  static const double card   = 20.0;  // Cards
  static const double input  = 12.0;  // Text fields
  static const double chip   = 8.0;   // Chips / tags
  static const double full   = 999.0; // Pill / circular

  static BorderRadius buttonRadius = BorderRadius.circular(button);
  static BorderRadius cardRadius   = BorderRadius.circular(card);
  static BorderRadius inputRadius  = BorderRadius.circular(input);
  static BorderRadius chipRadius   = BorderRadius.circular(chip);
}

/// Text styles
/// Headings  → Poppins
/// Body text → Montserrat
class AppTextStyles {
  AppTextStyles._();

  // ── Headings (Poppins) ────────────────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 57, fontWeight: FontWeight.w700, color: AppColors.primaryText,
  );
  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 45, fontWeight: FontWeight.w700, color: AppColors.primaryText,
  );
  static TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 36, fontWeight: FontWeight.w600, color: AppColors.primaryText,
  );
  static TextStyle headlineLarge = GoogleFonts.poppins(
    fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.primaryText,
  );
  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.primaryText,
  );
  static TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primaryText,
  );
  static TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.primaryText,
  );
  static TextStyle titleMedium = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryText,
    letterSpacing: 0.15,
  );
  static TextStyle titleSmall = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primaryText,
    letterSpacing: 0.1,
  );

  // ── Body / UI (Montserrat) ────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.montserrat(
    fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.secondaryText,
    letterSpacing: 0.5,
  );
  static TextStyle bodyMedium = GoogleFonts.montserrat(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.secondaryText,
    letterSpacing: 0.25,
  );
  static TextStyle bodySmall = GoogleFonts.montserrat(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.greyText,
    letterSpacing: 0.4,
  );
  static TextStyle labelLarge = GoogleFonts.montserrat(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.white,
    letterSpacing: 0.1,
  );
  static TextStyle labelMedium = GoogleFonts.montserrat(
    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.secondaryText,
    letterSpacing: 0.5,
  );
  static TextStyle labelSmall = GoogleFonts.montserrat(
    fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.greyText,
    letterSpacing: 0.5,
  );

  // ── TextTheme for MaterialApp ─────────────────────────────────────────────
  static TextTheme get textTheme => TextTheme(
    displayLarge:   displayLarge,
    displayMedium:  displayMedium,
    displaySmall:   displaySmall,
    headlineLarge:  headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall:  headlineSmall,
    titleLarge:     titleLarge,
    titleMedium:    titleMedium,
    titleSmall:     titleSmall,
    bodyLarge:      bodyLarge,
    bodyMedium:     bodyMedium,
    bodySmall:      bodySmall,
    labelLarge:     labelLarge,
    labelMedium:    labelMedium,
    labelSmall:     labelSmall,
  );
}
