import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_client.dart';

class AuthService {
  final DioClient dioClient = DioClient();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;

      // Simpan token
      if (data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
      }

      return {
        'success': true,
        'data': data,
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? "Login gagal"
      };
    } catch (e) {
      return {
        'success': false,
        'message': "Terjadi kesalahan. Coba lagi."
      };
    }
  }
}
