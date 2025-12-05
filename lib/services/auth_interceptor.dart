import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import DioClient jika berada di folder yang sama, atau sesuaikan path
// import 'dio_client.dart';

class AuthInterceptor extends Interceptor {
  // Key yang digunakan untuk menyimpan token di SharedPreferences
  static const String _tokenKey = 'token';

  // Fungsi untuk mengambil token secara asinkron
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Ambil token dari penyimpanan
    final token = await getToken();

    // 2. Jika token ada, tambahkan ke header 'Authorization'
    if (token != null && token.isNotEmpty) {
      // Format Authorization header adalah "Bearer <token>"
      options.headers['Authorization'] = 'Bearer $token';
      // Anda bisa mencetak ini di LogInterceptor, tapi ini adalah validasi internal
      print('Adding Authorization Header: Bearer $token');
    }

    // Lanjutkan permintaan
    super.onRequest(options, handler);
  }

  // Anda bisa menambahkan logika error handling/refresh token di sini
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Contoh: Jika menerima status 401 (Unauthorized), bisa coba refresh token
    // atau mengarahkan pengguna ke halaman login.
    super.onError(err, handler);
  }
}
