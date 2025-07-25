import 'package:flutter/material.dart';

class AppThemes {
  // Common colors
  static const Color backgroundColor = Color(0xFF0B3946); // #0B3946
  static const Color primaryColor = Color(0xFF0B3946); // #0B3946
  static const Color textColorPrimary = Color(0xFFFFEDDC); // #FFEDDC
  static const Color textColorSecondary = Color(0xFFF0F9CE); // #F0F9CE
  static const Color lightGrey = Colors.grey; // Light grey
  static const Color lightGreyMore = Color(0xFFECECEC); // Light grey
  static const Color lightGreylittle = Color(0xFFEADADAD); // Light grey
  static const Color darkGrey = Color(0xFF424242); // Dark grey
  static const Color white = Colors.white; // White
  static const Color red = Color(0xFFBA3232); // White

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: backgroundColor,
      secondary: textColorSecondary,
      surface: white,
      background: white,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textColorPrimary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColorPrimary),
      bodyMedium: TextStyle(color: textColorSecondary),
      bodySmall: TextStyle(color: lightGrey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: textColorSecondary,
        foregroundColor: backgroundColor,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textColorPrimary, width: 2.0),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: darkGrey,
    colorScheme: const ColorScheme.dark(
      primary: darkGrey,
      secondary: textColorSecondary,
      surface: backgroundColor,
      background: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGrey,
      foregroundColor: textColorPrimary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColorPrimary),
      bodyMedium: TextStyle(color: textColorSecondary),
      bodySmall: TextStyle(color: lightGrey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: textColorSecondary,
        foregroundColor: darkGrey,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textColorPrimary, width: 2.0),
      ),
    ),
  );

  // Gradients for UI elements
}
