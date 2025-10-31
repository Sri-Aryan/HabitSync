import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightBlue = Color(0xFF6B9FFF);
  static const Color darkBlue = Color(0xFF4A7FE5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);

  static ThemeData lightTheme = ThemeData(
    primaryColor: lightBlue,
    scaffoldBackgroundColor: white,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: lightBlue,
      secondary: darkBlue,
      surface: white,
      background: lightGrey,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: black),
      titleTextStyle: TextStyle(
        color: black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: black),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: black),
      bodyLarge: TextStyle(fontSize: 16, color: black),
      bodyMedium: TextStyle(fontSize: 14, color: grey),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: lightGrey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightBlue,
      foregroundColor: white,
      elevation: 4,
    ),
  );
}
