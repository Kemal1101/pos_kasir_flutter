import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<bool> login(BuildContext context, String email, String password) async {
    final result = await _authService.login(email, password);

    if (result['success']) {
      // Berhasil → pindah ke dashboard
      Navigator.pushReplacementNamed(context, '/home');
      return true;
    } else {
      // Tampilkan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      return false;
    }
  }
}
