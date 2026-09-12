import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // Display Hero
  static TextStyle displayHero = GoogleFonts.inter(
    fontSize: 80,
    fontWeight: FontWeight.w200,
    height: 84 / 80,
    letterSpacing: -0.04 * 80,
    color: AppColors.textPrimary,
  );

  static TextStyle displayHeroMobile = GoogleFonts.inter(
    fontSize: 64,
    fontWeight: FontWeight.w200,
    height: 68 / 64,
    letterSpacing: -0.03 * 64,
    color: AppColors.textPrimary,
  );

  // Headlines
  static TextStyle headlineLg = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    letterSpacing: -0.02 * 32,
    color: AppColors.onSurface,
  );

  static TextStyle headlineMd = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.015 * 24,
    color: AppColors.onSurface,
  );

  static TextStyle headlineSm = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: -0.01 * 18,
    color: AppColors.onSurface,
  );

  // Body
  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurface,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.onSurface,
  );

  static TextStyle bodySm = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.onSurfaceVariant,
  );

  // Labels
  static TextStyle labelLg = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 18 / 14,
    letterSpacing: 0.01 * 14,
    color: AppColors.onSurface,
  );

  static TextStyle labelMd = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.02 * 12,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle labelSm = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 12 / 10,
    letterSpacing: 0.06 * 10,
    color: AppColors.onSurfaceVariant,
  );
}
