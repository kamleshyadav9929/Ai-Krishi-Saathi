import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography configuration tailored for English and Hindi (Devanagari)
/// Guarantees generous line heights to prevent clipping of vowel marks (मात्राएँ)
class AppTypography {
  static TextStyle headingLarge({bool isHindi = false}) => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: isHindi ? 1.5 : 1.3,
      );

  static TextStyle headingMedium({bool isHindi = false}) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: isHindi ? 1.45 : 1.3,
      );

  static TextStyle headingSmall({bool isHindi = false}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: isHindi ? 1.4 : 1.25,
      );

  static TextStyle bodyLarge({bool isHindi = false}) => GoogleFonts.notoSansDevanagari(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle bodyMedium({bool isHindi = false}) => GoogleFonts.notoSansDevanagari(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.45,
      );

  static TextStyle bodySmall({bool isHindi = false}) => GoogleFonts.notoSansDevanagari(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.4,
      );

  static TextStyle labelLarge({bool isHindi = false}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: isHindi ? 1.4 : 1.2,
      );

  static TextStyle metricValue() => GoogleFonts.firaCode(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDark,
        letterSpacing: -0.5,
      );
}
