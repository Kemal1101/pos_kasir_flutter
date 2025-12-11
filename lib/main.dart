import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/cart_provider.dart';
import 'pages/login_page.dart';
import 'screens/home_screen.dart';
import 'widgets/app_logo.dart';

void main() async {
  // Pastikan Anda menambahkan gambar aset dan mendeklarasikannya di pubspec.yaml
  WidgetsFlutterBinding.ensureInitialized();

  // Kunci orientasi ke landscape mode (seperti game)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Opsional: Sembunyikan status bar dan navigation bar untuk full screen
  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const SuperCashierApp(),
    ),
  );
}

class SuperCashierApp extends StatefulWidget {
  const SuperCashierApp({super.key});

  @override
  State<SuperCashierApp> createState() => _SuperCashierAppState();
}

class _SuperCashierAppState extends State<SuperCashierApp> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      setState(() {
        _isLoggedIn = token != null && token.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

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
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: SplashLogo(),
              ),
            )
          : _isLoggedIn
          ? const HomeScreen()
          : const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
