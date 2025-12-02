import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthCheckWidget extends StatefulWidget {
  // <<< PERBAIKAN WARNING: Menambahkan key ke constructor
  const AuthCheckWidget({super.key}); 

  // <<< PERBAIKAN ERROR: Implementasi wajib createState
  @override
  State<AuthCheckWidget> createState() => _AuthCheckWidgetState();
}

class _AuthCheckWidgetState extends State<AuthCheckWidget> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate(); 
  }

  Future<void> _checkTokenAndNavigate() async {
    // Membaca token dari SharedPreferences
    final String? token = await _authService.getToken(); 
    
    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // Jika token ada (dari penyimpanan persisten), langsung ke Home
      Navigator.pushReplacementNamed(context, '/home'); 
    } else {
      // Jika token tidak ada, ke Login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // <<< PERBAIKAN ERROR: Implementasi wajib build()
  @override
  Widget build(BuildContext context) {
    // Menampilkan layar loading (Splash Screen) saat memeriksa token
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}