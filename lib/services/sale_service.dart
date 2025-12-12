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

  /// Update item quantity in sale
  /// Since backend doesn't have update endpoint, we remove and re-add with new quantity
  Future<Map<String, dynamic>> updateItemQuantity({
    required int saleId,
    required int saleItemId,
    required int productId,
    required int newQuantity,
  }) async {
    try {
      // Step 1: Remove existing item
      final removeResponse = await dioClient.dio.delete(
        '/sales/items/$saleItemId',
      );

      if (removeResponse.statusCode != 200) {
        return {
          'success': false,
          'message': removeResponse.data['message'] ?? 'Failed to update quantity',
        };
      }

      // Step 2: Add item with new quantity
      final addResponse = await dioClient.dio.post(
        '/sales/items',
        data: {
          'sale_id': saleId,
          'product_id': productId,
          'quantity': newQuantity,
          'discount_amount': 0,
        },
      );

      if (addResponse.statusCode == 200) {
        final data = addResponse.data['data'];
        return {
          'success': true,
          'sale': Sale.fromJson(data),
        };
      }

      return {
        'success': false,
        'message': addResponse.data['message'] ?? 'Failed to update quantity',
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
        'message': e.response?.data['message'] ?? 'Failed to update quantity',
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

  /// Complete/finalize a sale (change status from draft to paid)
  /// paymentId: 1=cash, 2=card, 5=qris
  Future<Map<String, dynamic>> completeSale({
    required int saleId,
    required int paymentId,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/sales/$saleId/confirm-payment',
        data: {
          'payment_id': paymentId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'success': true,
          'sale': Sale.fromJson(data),
          'message': 'Payment confirmed successfully',
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to confirm payment',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to confirm payment',
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
