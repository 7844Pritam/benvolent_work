import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static final TextStyle Text23600 = GoogleFonts.inter(
    fontSize: 23,
    fontWeight: FontWeight.w600,
    color: AppThemes.backgroundColor,
  );

  static final TextStyle Text16400 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppThemes.primaryColor,
  );
  static final TextStyle Text16700 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppThemes.primaryColor,
  );
  static final TextStyle Text18700 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppThemes.primaryColor,
  );
  static final TextStyle Text13500 = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppThemes.primaryColor,
  );
  static final TextStyle Text13400 = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppThemes.primaryColor,
  );
  static final TextStyle Text14400 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppThemes.primaryColor,
  );

  static final TextStyle label = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF0B3946),
  );

  static final TextStyle error = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.red,
  );

  static final TextStyle link = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.red,
    decoration: TextDecoration.underline,
  );

  static final TextStyle terms = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppThemes.primaryColor,
  );

  static get Text14500 => null;

  static get Text15400 => null;
}
