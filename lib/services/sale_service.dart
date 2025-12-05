import 'package:dio/dio.dart';
import '../models/sale.dart';
import 'dio_client.dart';

class SaleService {
  final DioClient dioClient = DioClient();

  /// Create a new draft sale
  /// Returns Sale object with sale_id
  Future<Map<String, dynamic>> createSale({int? paymentId}) async {
    try {
      final response = await dioClient.dio.post(
        '/sales',
        data: {
          if (paymentId != null) 'payment_id': paymentId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'success': true,
          'sale': Sale.fromJson(data),
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to create sale',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to create sale',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  /// Add item to an existing sale
  /// Automatically recalculates totals on backend
  Future<Map<String, dynamic>> addItem({
    required int saleId,
    required int productId,
    int quantity = 1,
    double discountAmount = 0,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/sales/items',
        data: {
          'sale_id': saleId,
          'product_id': productId,
          'quantity': quantity,
          'discount_amount': discountAmount,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'success': true,
          'sale': Sale.fromJson(data),
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to add item',
      };
    } on DioException catch (e) {
      // Handle validation errors (e.g., insufficient stock)
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null && errors['quantity'] != null) {
          return {
            'success': false,
            'message': errors['quantity'][0],
          };
        }
      }

      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to add item',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  /// Remove item from sale
  /// Restores product stock automatically
  Future<Map<String, dynamic>> removeItem(int saleItemId) async {
    try {
      final response = await dioClient.dio.delete(
        '/sales/items/$saleItemId',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'success': true,
          'sale': Sale.fromJson(data),
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to remove item',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to remove item',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  /// Get sale details with items
  Future<Map<String, dynamic>> getSale(int saleId) async {
    try {
      final response = await dioClient.dio.get('/sales/$saleId');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'success': true,
          'sale': Sale.fromJson(data),
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Sale not found',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to fetch sale',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  /// Delete a draft sale
  /// Only works for draft sales, restores stock
  Future<Map<String, dynamic>> deleteSale(int saleId) async {
    try {
      final response = await dioClient.dio.delete('/sales/$saleId');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Sale deleted successfully',
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to delete sale',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to delete sale',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}
