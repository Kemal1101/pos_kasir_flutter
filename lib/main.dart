import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'widgets/main_shell.dart';
// WAJIB: Import AuthCheckWidget dari folder widgets
import 'widgets/auth_check_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperCashier',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // PERUBAHAN UTAMA:
      // Halaman pertama yang akan dibuka diarahkan ke rute root '/'
      initialRoute: '/',

      // Routing halaman
      routes: {
        // 1. Rute utama: Memulai pemeriksaan token
        '/': (context) => const AuthCheckWidget(),

        // 2. Rute login: Dituju jika token tidak ada
        '/login': (context) => const LoginPage(),

        // 3. Rute home: Dituju jika token valid
        '/home': (context) => const MainShell(),
      },
    );
  }
}
