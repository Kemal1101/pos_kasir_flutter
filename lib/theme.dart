// lib/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF673AB7);
  static const Color secondary = Color(0xFFE94B9C);
  static const Color background = Color(0xFFF6F7FB);
}

final ThemeData appTheme = ThemeData(
  fontFamily: 'Poppins',
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primary),
  scaffoldBackgroundColor: AppTheme.background,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: Colors.black87,
    ),
  ),
);
