import 'package:flutter/material.dart';

class AppColors {
  // Base Colors
  static const Color backgroundColor = Color(0xFF0B3946);
  static const Color primaryColor = Color(0xFF0B3946);
  static const Color accentColor = Color(0xFFF0F9CE);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFEDDC);
  static const Color textSecondary = Color(0xFFF0F9CE);

  // Greys
  static const Color greyLight = Color(0xFFECECEC);
  static const Color greyLighter = Color(0xFFEEEEEE);
  static const Color grey = Colors.grey;
  static const Color greyDark = Color(0xFF424242);

  // Alerts
  static const Color red = Color(0xFFBA3232);
  static const Color green = Color(0xFF4CAF50);
  static const Color yellow = Color(0xFFFFEB3B);

  // Utility
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

class AppThemes {
  /// Light Theme
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primaryColor,
      secondary: AppColors.accentColor,
      surface: AppColors.greyLighter,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.textPrimary,
      elevation: 2,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textSecondary),
      bodySmall: TextStyle(color: AppColors.greyDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentColor,
        foregroundColor: AppColors.primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
    ),
    // cardTheme: CardTheme(
    //   color: AppColors.greyLight,
    //   elevation: 4,
    //   margin: const EdgeInsets.all(8),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    // ),
  );

  /// Dark Theme
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    primaryColor: AppColors.greyDark,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.greyDark,
      secondary: AppColors.accentColor,
      surface: AppColors.primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.greyDark,
      foregroundColor: AppColors.textPrimary,
      elevation: 2,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textSecondary),
      bodySmall: TextStyle(color: AppColors.grey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentColor,
        foregroundColor: AppColors.greyDark,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.textPrimary, width: 2),
      ),
    ),
    // cardTheme: CardTheme(
    //   color: AppColors.greyDark,
    //   elevation: 4,
    //   margin: const EdgeInsets.all(8),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    // ),
  );

  /// Custom gradient for buttons or backgrounds
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0B3946), Color(0xFF1E6073)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
