import 'package:dio/dio.dart';
import 'auth_interceptor.dart'; 
// Asumsikan LogInterceptor sudah tersedia di lingkungan Anda

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://supercashier.my.id/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      // Jangan follow redirect otomatis - handle manual
      followRedirects: false,
      validateStatus: (status) {
        // Terima semua status untuk dihandle manual
        return status != null && status < 500;
      },
    ),
  );

  DioClient() {
    // Tambahkan LogInterceptor (seperti yang Anda berikan)
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    
    // TAMBAHKAN INTERCEPTOR UNTUK OTOMATISASI TOKEN JWT
    dio.interceptors.add(AuthInterceptor());
  }
}