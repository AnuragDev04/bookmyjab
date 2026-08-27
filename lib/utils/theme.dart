// lib/utils/theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary:        AppColors.primary,
      onPrimary:      AppColors.white,
      primaryContainer: AppColors.darkPurple,
      secondary:      AppColors.orange,
      onSecondary:    AppColors.white,
      error:          AppColors.red,
      onError:        AppColors.white,
      surface:        AppColors.surface,
      onSurface:      AppColors.primaryText,
    ),

    // ── Typography ──────────────────────────────────────────────────────────
    textTheme: AppTextStyles.textTheme,

    // ── Icons: rounded Material Symbols ────────────────────────────────────
    iconTheme: const IconThemeData(
      color: AppColors.primary,
      size: 24,
      opticalSize: 24,
      fill: 0,
      weight: 400,
      grade: 0,
    ),

    // ── AppBar ──────────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
      iconTheme: const IconThemeData(color: AppColors.white, size: 24),
    ),

    // ── ElevatedButton (CTA — orange) ───────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.buttonRadius,
        ),
        textStyle: AppTextStyles.labelLarge,
        elevation: 2,
      ),
    ),

    // ── OutlinedButton (secondary — purple outline) ─────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.buttonRadius,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
      ),
    ),

    // ── TextButton ──────────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.buttonRadius,
        ),
      ),
    ),

    // ── Card ────────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardRadius,
      ),
      margin: const EdgeInsets.all(AppSpacing.x1),
    ),

    // ── InputDecoration ─────────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.x2,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.red),
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyText),
      labelStyle: AppTextStyles.bodyMedium,
    ),

    // ── BottomNavigationBar ─────────────────────────────────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.greyText,
      selectedLabelStyle: AppTextStyles.labelSmall,
      unselectedLabelStyle: AppTextStyles.labelSmall,
      elevation: 8,
    ),

    // ── Divider ─────────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.greyLight,
      thickness: 1,
      space: AppSpacing.x2,
    ),

    // ── Scaffold background ─────────────────────────────────────────────────
    scaffoldBackgroundColor: AppColors.background,
  );
}
