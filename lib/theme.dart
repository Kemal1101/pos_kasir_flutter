import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final Color primary = const Color(0xFF7F44FF);
  static final Color primaryLight = const Color(0xFF8B5CF6);
  static final Color accent = const Color(0xFFFF6B9D);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primary,
      secondary: accent,
    ),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      elevation: 2,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardColor: Colors.white,
    textTheme: TextTheme(
      headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.poppins(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey[400],
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
      primary: primaryLight,
      secondary: accent,
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2A2A2A),
      elevation: 2,
    ),
    cardColor: const Color(0xFF2A2A2A),
  );
}