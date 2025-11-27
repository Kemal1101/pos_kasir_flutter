import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() {
  // Pastikan Anda menambahkan gambar aset dan mendeklarasikannya di pubspec.yaml
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const SuperCashierApp(),
    ),
  );
}

class SuperCashierApp extends StatelessWidget {
  const SuperCashierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperCashier POS', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // scaffoldBackgroundColor: Colors.grey[100], // Uncomment jika ingin background abu-abu
      ),
      initialRoute: '/login', 
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(), 
      },
    );
  }
}
