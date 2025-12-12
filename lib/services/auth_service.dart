import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_client.dart';

class AuthService {
  final DioClient dioClient = DioClient();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      // Handle redirect response (302/301) - ini berarti kredensial salah
      if (response.statusCode == 302 || response.statusCode == 301) {
        return {
          'success': false,
          'meta': {'status': 401, 'message': 'Email atau password salah'},
          'message': 'Email atau password salah. Silakan coba lagi.',
          'data': null,
        };
      }

      // Cek jika response adalah JSON
      if (response.data is! Map<String, dynamic>) {
        return {
          'success': false,
          'meta': {'status': 500, 'message': 'Respons server tidak valid'},
          'message': 'Login gagal. Server mengembalikan format yang tidak sesuai.',
          'data': null,
        };
      }

      // Data utama (body respons JSON)
      final responseData = response.data as Map<String, dynamic>;

      // Validasi struktur response
      if (responseData['data'] == null) {
        return {
          'success': false,
          'meta': {'status': 500, 'message': 'Data tidak ditemukan di response'},
          'message': 'Login gagal. Format response tidak valid.',
          'data': null,
        };
      }

      // Ambil data dari key 'data'
      final userData = responseData['data'] as Map<String, dynamic>?;

      // Ambil role_id dengan safe parsing (bisa int atau string)
      dynamic rawRoleId = userData?['user']?['role_id'];
      String? roleId;
      if (rawRoleId != null) {
        roleId = rawRoleId.toString();
      }

      // --- Simpan token ---
      final accessToken = userData?['access_token'];
      if (accessToken != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', accessToken.toString());
      }

      // --- MENGEMBALIKAN STRUKTUR LENGKAP UNTUK CONTROLLER ---
      return {
        'success': true,
        'meta': responseData['meta'] ?? {'status': 200, 'message': 'Login berhasil'},
        'data': responseData['data'],
        'role_id_ekstrak': roleId,
        'message': responseData['meta']?['message'] ?? "Login berhasil.",
      };
    } on DioException catch (e) {
      // Handle redirect (302, 301, etc) di DioException juga
      if (e.response?.statusCode == 302 || e.response?.statusCode == 301) {
        return {
          'success': false,
          'meta': {'status': 401, 'message': 'Email atau password salah'},
          'message': 'Email atau password salah. Silakan coba lagi.',
          'data': null,
        };
      }

      // Cek apakah response data adalah JSON
      String message = "Login gagal. Cek kredensial.";
      if (e.response?.data is Map<String, dynamic>) {
        message = e.response?.data?['meta']?['message'] ?? 
                  e.response?.data?['message'] ?? 
                  message;
      }

      return {
        'success': false,
        'meta': {'status': e.response?.statusCode ?? 500, 'message': message},
        'message': message,
        'data': null,
      };
    } catch (e) {
      // Menangani error lain (misalnya parsing)
      return {
        'success': false,
        'meta': {'status': 500, 'message': "Terjadi kesalahan: $e"},
        'message': "Terjadi kesalahan. Coba lagi.",
        'data': null,
      };
    }
  }

  Future<bool> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      return true;
    } catch (e) {
      return false;
    }
  }
}
