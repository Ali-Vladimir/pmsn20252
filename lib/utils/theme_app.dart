import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData darkTheme() {
    final theme = ThemeData.dark().copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
        secondary: Colors.purpleAccent,
        onSecondary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: Colors.grey[900]!,
        onSurface: Colors.white,
      ),
    );
    return theme;
  }

  static ThemeData lightTheme() {
    final theme = ThemeData.light().copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Colors.blue,
        onPrimary: Colors.white,
        secondary: Colors.blueAccent,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.grey[50]!,
        onSurface: Colors.black87,
      ),
    );
    return theme;
  }
}
