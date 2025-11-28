import 'package:dio/dio.dart';
import '../models/product.dart';
import 'dio_client.dart';

class ProductService {
  final DioClient dioClient = DioClient();

  /// Fetch all products
  Future<Map<String, dynamic>> getProducts({
    int? categoryId,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await dioClient.dio.get(
        '/products',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final products = (data as List)
            .map((json) => Product.fromJson(json))
            .toList();

        return {
          'success': true,
          'products': products,
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to fetch products',
        'products': <Product>[],
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to fetch products',
        'products': <Product>[],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
        'products': <Product>[],
      };
    }
  }

  /// Get single product by ID
  Future<Map<String, dynamic>> getProduct(int productId) async {
    try {
      final response = await dioClient.dio.get('/products/$productId');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'success': true,
          'product': Product.fromJson(data),
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Product not found',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to fetch product',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  /// Search products by barcode
  Future<Map<String, dynamic>> searchByBarcode(String barcode) async {
    try {
      final response = await dioClient.dio.get(
        '/products',
        queryParameters: {'barcode': barcode},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List && data.isNotEmpty) {
          return {
            'success': true,
            'product': Product.fromJson(data.first),
          };
        }

        return {
          'success': false,
          'message': 'Product not found',
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to search product',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to search product',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}
