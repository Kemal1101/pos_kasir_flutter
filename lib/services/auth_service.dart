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

      // Data utama (body respons JSON)
      final responseData = response.data as Map<String, dynamic>;

      // Ambil data dari key 'data'
      final userData = responseData['data'] as Map<String, dynamic>?;

      // Ambil role_id dari 'data.user.role_id'
      final String? roleId = userData?['user']?['role_id'] as String?;

      // --- Simpan token ---
      final String? accessToken = userData?['access_token'];
      if (accessToken != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Simpan access_token, bukan data['token']
        await prefs.setString('token', accessToken);
      }

      // --- MENGEMBALIKAN STRUKTUR LENGKAP UNTUK CONTROLLER ---
      // AuthController memerlukan 'meta' dan 'data.user.role_id' yang dilewatkan.

      return {
        // Status dari Dio/HTTP
        'success': true,
        // Meta data harus dilewatkan untuk pesan dan status code
        'meta': responseData['meta'],
        // Data lengkap untuk otorisasi role di controller
        'data': responseData['data'],
        // Secara opsional, lewati role_id yang sudah diekstrak untuk akses cepat (role_id)
        'role_id_ekstrak': roleId,
        'message': responseData['meta']['message'] ?? "Login berhasil.",
      };
    } on DioException catch (e) {
      // Menangani error HTTP/Dio (misalnya 401 Unauthorized)
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
      // Menangani error lain (misalnya parsing)
      return {
        'success': false,
        'meta': {'status': 500, 'message': "Terjadi kesalahan umum: $e"},
        'message': "Terjadi kesalahan umum. Coba lagi.",
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
