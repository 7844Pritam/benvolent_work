import 'package:flutter/material.dart';

class AppThemes {
  static const Color backgroundColor = Color(0xFF0B3946);
  static const Color primaryColor = Color(0xFF0B3946);
  static const Color lightPrimaryColor = Color.fromARGB(143, 16, 56, 67);
  static const Color textColorPrimary = Color.fromARGB(255, 0, 0, 0);
  static const Color textColorWhite = Colors.white;
  static const Color textColorSecondary = Color.fromARGB(255, 0, 0, 0);
  static const Color lightGrey = Colors.grey;
  static const Color lightGreyMore = Color(0xFFECECEC);
  static const Color lightGreylittle = Color(0xFFEADADAD);
  static const Color darkGrey = Color(0xFF424242);
  static const Color white = Colors.white;
  static const Color red = Color(0xFFBA3232);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: backgroundColor,
      secondary: textColorSecondary,
      surface: white,
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
