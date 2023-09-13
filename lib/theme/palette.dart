import 'package:flutter/material.dart';

class Palette {
  static const primeBlue = Color(0xFF1763eb);
  static const primePurple = Color(0xFFAB81CD);
  static const facebookColor = Color(0xFF4a6ea9);
  static const discordColor = Color(0xFF5c6bc0);
  static const noteColor1 = Color(0xFFd64f6f);
  static const noteColor2 = Color(0xFFbe6a0b);
  static const noteColor3 = Color(0xFF4d61c1);
  static const noteColor4 = Color(0xFF36b4a6);
  static const noteColor5 = Color(0xFFcc5dbd);
  static const noteColor6 = Color(0xFFd49d29);
  static const darkThemeBackground = Color(0xFF202934);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: darkThemeBackground),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkThemeBackground,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
      background: darkThemeBackground,
    ),
  );
}
