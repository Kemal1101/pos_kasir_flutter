// lib/theme.dart
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'Poppins',
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  scaffoldBackgroundColor: const Color(0xFFF6F7FB),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.transparent, // we'll provide gradient inside AppBar flexibleSpace where needed
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
