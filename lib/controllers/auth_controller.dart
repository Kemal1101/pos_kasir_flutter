import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// --- HELPER FUNCTION: CUSTOM DIALOG POP-UP ---
Future<void> _showStatusDialog(
  BuildContext context,
  String title,
  String message,
  Color color,
) async {
  if (!context.mounted) return;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            // Icon berdasarkan warna (sukses=centang, error=silang)
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.error,
              color: color,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK', style: TextStyle(color: color)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
// ---------------------------------------------

class AuthController {
  final AuthService _authService = AuthService();

  Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    // Panggil service. Asumsi 'result' adalah body respons API lengkap.
    final result = await _authService.login(email, password);

    if (!context.mounted) return false;

    // --- Ekstraksi Data Status dan Pesan ---
    final Map<String, dynamic>? metaData = result['meta'];
    final Map<String, dynamic>? userData = result['data']?['user'];

    final bool isSuccess = metaData != null && metaData['status'] == 200;

    final String message;
    if (metaData != null && metaData.containsKey('message')) {
      message = metaData['message'];
    } else {
      message =
          'Gagal memproses respon server. Struktur data status (meta) hilang atau tidak lengkap.';
    }

    if (isSuccess) {
      // --- Ekstraksi Role ID ---
      dynamic rawRoleId = userData?['role_id'];
      int roleId;

      if (rawRoleId is String) {
        roleId = int.tryParse(rawRoleId.trim()) ?? 0;
      } else if (rawRoleId is int) {
        roleId = rawRoleId;
      } else {
        roleId = 0;
      }

      if (roleId == 2) {
        // --- AKSES DIIZINKAN (Role 2) ---
        // Navigasi ke Dashboard
        Navigator.pushReplacementNamed(context, '/home');
        
        return true;
      } else if (roleId == 1) {
        // --- AKSES DITOLAK (Role 1) ---
        await _showStatusDialog(
          context,
          'Akses Ditolak!',
          'Akses Ditolak! Admin tidak diizinkan masuk ke sistem.',
          Colors.red,
        );
        return false;
      } else {
        // Jika sukses, tapi roleId tidak 1 atau 2.
        await _showStatusDialog(
          context,
          'Peringatan Otorisasi',
          'Akses Ditolak: Role ID ${rawRoleId} tidak memiliki izin (Hanya Role 2 yang diizinkan).',
          Colors.orange,
        );
        return false;
      }
    } else {
      // --- GAGAL OTENTIKASI (Status bukan 200) ---
      await _showStatusDialog(context, 'Gagal Login', message, Colors.red);
      return false;
    }
  }
}
