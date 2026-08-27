// lib/utils/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // ── Brand Palette ─────────────────────────────────────────────────────────
  static const Color orange      = Color(0xFFF37721); // CTA buttons
  static const Color red         = Color(0xFFEE4036); // Alerts / emergency actions
  static const Color purple      = Color(0xFF673C96); // Primary brand color
  static const Color darkPurple  = Color(0xFF3E195E);
  static const Color deepPurple  = Color(0xFF311B52);
  static const Color white       = Color(0xFFFFFFFF);
  static const Color lightPurple = Color(0xFF7B4EBF);
  // ── Primary ───────────────────────────────────────────────────────────────
  static const Color primary          = purple;
  static const Color primaryDark      = darkPurple;
  static const Color primaryDeep      = deepPurple;

  // ── CTA / Actions ─────────────────────────────────────────────────────────
  static const Color buttonColor      = orange;   // Call-to-action buttons
  static const Color alertColor       = red;      // Alerts & emergency actions

  // ── Backgrounds & Surfaces ────────────────────────────────────────────────
  static const Color background       = white;              // Main background
  static const Color surface          = Color(0xFFF5F5F5);  // Soft grey surface
  static const Color greyLight        = Color(0xFFE0E0E0);  // Dividers / borders

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color primaryText      = deepPurple;
  static const Color secondaryText    = Color(0xFF424242);
  static const Color greyText         = Color(0xFF757575);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color error            = red;
  static const Color warning          = orange;
  static const Color accentGreen      = Color(0xFF388E3C);
  static const Color accentBlue       = Color(0xFF1976D2);

  // ── Legacy aliases (kept to avoid breaking existing references) ───────────
  static const Color primaryLight     = surface;
  static const Color backColor        = primaryDeep;
}
