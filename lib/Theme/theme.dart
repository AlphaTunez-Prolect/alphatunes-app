import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.pink, // Button background color
    secondary: Colors.white, // Secondary color
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold), // Very large headlines
    displayMedium: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold), // Large headlines
    displaySmall: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold), // Medium headlines
    headlineMedium: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold), // Section headings
    titleLarge: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), // Subtitles
    bodyLarge: TextStyle(color: Colors.black, fontSize: 18), // Regular text (large)
    bodyMedium: TextStyle(color: Colors.black, fontSize: 16), // Regular text (default)
    bodySmall: TextStyle(color: Colors.black, fontSize: 14), // Small text
    labelLarge: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600), // Button text
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.black.withOpacity(0.05), // Light mode

  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.pink, // Button background
      foregroundColor: Colors.white, // Button text color
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    primary: Colors.pink, // Button background color
    secondary: Colors.white, // Secondary color
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold), // Very large headlines
    displayMedium: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold), // Large headlines
    displaySmall: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), // Medium headlines
    headlineMedium: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), // Section headings
    titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Subtitles
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18), // Regular text (large)
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16), // Regular text (default)
    bodySmall: TextStyle(color: Colors.white, fontSize: 14), // Small text
    labelLarge: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600), // Button text (black for contrast)
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.1), // Dark mode

  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.pink, // Button background
      foregroundColor: Colors.black, // Button text color (black for contrast)
    ),
  ),
);
