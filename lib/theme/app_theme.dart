import 'package:flutter/material.dart';

class AppTheme {
  // اللون الأساسي الثابت
  static const Color primaryOrange = Colors.orange;

  // LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    primaryColor: primaryOrange,

    colorScheme: const ColorScheme.light(
      primary: primaryOrange,

      surface: Color.fromARGB(255, 255, 242, 223),

      onSurface: Colors.black,

      secondary: Colors.white,
    ),

    scaffoldBackgroundColor: Colors.white,
  );

  // DARK THEME
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    primaryColor: primaryOrange,

    colorScheme: const ColorScheme.dark(
      primary: primaryOrange,

      surface: Color(0xFF1E1E1E),

      onSurface: Colors.white,

      secondary: Colors.black,
    ),

    scaffoldBackgroundColor: Color(0xFF121212),
  );
}
