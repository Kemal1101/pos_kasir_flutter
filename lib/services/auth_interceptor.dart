import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart'; // Mungkin diperlukan untuk navigasi

class AuthInterceptor extends Interceptor {
  // PENTING: Gunakan key yang konsisten ('access_token')
  static const String _tokenKey = 'access_token';

  // --- Utility Functions ---

  // Fungsi untuk mengambil token secara asinkron
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Fungsi untuk menghapus token
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // --- Request Handler ---

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Ambil token dari penyimpanan
    final token = await getToken();

    // 2. Jika token ada, tambahkan ke header 'Authorization'
    // Pengecualian: Permintaan Login atau Register TIDAK boleh ditambahi token
    // (Tambahkan logika pengecualian jika diperlukan)
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      // print('Adding Authorization Header: Bearer $token'); // Bermanfaat untuk debugging
    }

    // Lanjutkan permintaan
    return handler.next(options);
  }

  // --- Error Handler (Peningkatan) ---

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Cek apakah error berasal dari status 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      print("Token expired atau tidak valid. Status 401 diterima.");

      // 1. Hapus token lama dari penyimpanan lokal
      await removeToken();

      // 2. Arahkan pengguna ke halaman login
      // PENTING: Logika ini harus diimplementasikan melalui mekanisme global
      // seperti EventBus, Provider, atau NavigatorKey statis, karena Interceptor
      // tidak memiliki akses ke BuildContext secara langsung.
      // Contoh:
      // GlobalNavigator.navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);

      // 3. (Opsional) Jika Anda memiliki endpoint Refresh Token, lakukan di sini
      // final newAccessToken = await _refreshToken();
      // ... ulangi permintaan dengan token baru ...

      // Mengakhiri alur error di Interceptor
      return handler.next(err);
    }

    // Untuk error selain 401, lanjutkan alur error normal
    return super.onError(err, handler);
  }
}
