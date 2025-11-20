import 'package:flutter/material.dart';


class AppTheme {
static final Color primary = const Color(0xFF7F44FF);


static final ThemeData lightTheme = ThemeData(
brightness: Brightness.light,
colorScheme: ColorScheme.fromSwatch().copyWith(primary: primary),
scaffoldBackgroundColor: const Color(0xfff7f7f7),
appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF7F44FF)),
cardColor: Colors.white,
);


static final ThemeData darkTheme = ThemeData(
brightness: Brightness.dark,
colorScheme: ColorScheme.fromSwatch().copyWith(primary: primary),
scaffoldBackgroundColor: const Color(0xff2b2b2b),
appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF5e3b8a)),
cardColor: const Color(0xff3a3a3a),
);
}