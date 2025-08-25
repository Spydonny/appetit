import 'package:flutter/material.dart';
import 'calligraphy.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Colors.red,
      secondary: Colors.redAccent,
      surface: Colors.white,
      onSurface: Colors.black87,
      primaryContainer: Colors.white,
      onPrimaryContainer: Colors.black12
    ),
    textTheme: Calligraphy.textTheme,

    // 🎯 global style for all TextFields
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(color: Colors.black45),
      suffixIconColor: Colors.black54,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color(0xFF1E1E1E),
    colorScheme: const ColorScheme.dark(
      primary: Colors.red,
      secondary: Colors.redAccent,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white70,
      primaryContainer: Color.fromARGB(20, 0, 0, 0),
      onPrimaryContainer: Colors.transparent
    ),
    textTheme: Calligraphy.textTheme,

    // 🎯 global style for all TextFields
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(color: Colors.white54),
      suffixIconColor: Colors.white60,
    ),
  );
}

