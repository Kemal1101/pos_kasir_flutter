import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
// WAJIB: Import flutter/foundation untuk mengakses debugPrint
import 'package:flutter/foundation.dart';

import 'dio_client.dart';

class AuthService {
  final DioClient dioClient = DioClient();
  // Key token harus konsisten
  static const String _tokenKey = 'access_token';

  // --- FUNGSI TOKEN UTILITY ---

  // Mengambil token dari SharedPreferences (digunakan oleh AuthCheckWidget)
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Menyimpan token ke SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    debugPrint("Token berhasil disimpan.");
  }

  // Menghapus token dari SharedPreferences
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    debugPrint("Token berhasil dihapus dari storage.");
  }

  // Fungsi Logout (POST /api/logout)
  Future<void> logout() async {
    final token = await getToken();

    if (token == null) {
      debugPrint("Token sudah hilang di lokal. Logout sukses secara lokal.");
      return;
    }

    try {
      await dioClient.dio.post('/logout');
      debugPrint("Logout server berhasil dipanggil.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        debugPrint(
          "Logout server error (401/403). Token tidak valid, melanjutkan penghapusan lokal.",
        );
      } else {
        debugPrint(
          "Logout server error: ${e.response?.statusCode}. Token lokal tetap dihapus.",
        );
      }
    } catch (e) {
      debugPrint("Logout umum error: $e. Token lokal tetap dihapus.");
    } finally {
      // Pastikan token dihapus lokal
      await removeToken();
    }
  }

  // --- FUNGSI LOGIN ---

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final responseData = response.data as Map<String, dynamic>;
      final userData = responseData['data'] as Map<String, dynamic>?;

      final dynamic rawRoleId = userData?['user']?['role_id'];

      final String? accessToken = userData?['access_token'];
      if (accessToken != null) {
        await saveToken(accessToken);
      }

      return {
        'success': true,
        'meta': responseData['meta'],
        'data': responseData['data'],
        'role_id_ekstrak': rawRoleId,
        'message': responseData['meta']['message'] ?? "Login berhasil.",
      };
    } on DioException catch (e) {
      final message =
          e.response?.data?['meta']?['message'] ??
          "Login gagal. Cek kredensial.";

      return {
        'success': false,
        'meta': {'status': e.response?.statusCode ?? 500, 'message': message},
        'message': message,
        'data': null,
      };
    } catch (e) {
      return {
        'success': false,
        'meta': {'status': 500, 'message': "Terjadi kesalahan umum: $e"},
        'message': "Terjadi kesalahan umum. Coba lagi.",
        'data': null,
      };
    }
  }
}
