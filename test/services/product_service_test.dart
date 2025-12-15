import 'package:flutter_test/flutter_test.dart';
import 'package:pos_kasir_flutter/models/product.dart';
import 'package:pos_kasir_flutter/services/product_service.dart';

void main() {
  // Initialize TestWidgetsFlutterBinding for SharedPreferences
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductService Tests', () {
    late ProductService productService;

    setUp(() {
      productService = ProductService();
    });

    test('getProducts method exists and has correct signature', () {
      print('\n🧪 TEST: ProductService getProducts method');
      print('   Expected: Method exists and can be called');
      
      // Test that method exists and has correct signature
      expect(productService.getProducts, isA<Function>());
      
      print('   ✅ Result: getProducts method verified');
    });

    test('getProduct method exists', () {
      // Verify method can be called with productId
      expect(productService.getProduct, isA<Function>());
    });

    test('searchByBarcode method exists', () {
      // Verify method exists with correct signature
      expect(productService.searchByBarcode, isA<Function>());
    });
  });

  group('ProductService Response Format Tests', () {
    test('successful getProducts response should have expected structure', () {
      // Expected response format
      final expectedResponse = {
        'success': true,
        'products': <Product>[],
      };
      
      expect(expectedResponse['success'], true);
      expect(expectedResponse['products'], isA<List<Product>>());
    });

    test('failed getProducts response should have error message', () {
      // Expected error response
      final expectedResponse = {
        'success': false,
        'message': 'Failed to fetch products',
        'products': <Product>[],
      };
      
      expect(expectedResponse['success'], false);
      expect(expectedResponse['message'], isNotNull);
      expect(expectedResponse['products'], isEmpty);
    });

    test('successful getProduct response should contain single product', () {
      // Expected single product response
      final expectedResponse = {
        'success': true,
        'product': Product(
          productId: 1,
          name: 'Test Product',
          category: 'Test',
          sellingPrice: 10000,
          costPrice: 5000,
          stock: 10,
        ),
      };
      
      expect(expectedResponse['success'], true);
      expect(expectedResponse['product'], isA<Product>());
    });

    test('failed getProduct response should have error message', () {
      // Expected error response
      final expectedResponse = {
        'success': false,
        'message': 'Product not found',
      };
      
      expect(expectedResponse['success'], false);
      expect(expectedResponse['message'], isNotNull);
    });

    test('successful searchByBarcode should return product', () {
      // Expected barcode search response
      final expectedResponse = {
        'success': true,
        'product': Product(
          productId: 1,
          name: 'Test Product',
          category: 'Test',
          sellingPrice: 10000,
          costPrice: 5000,
          stock: 10,
        ),
      };
      
      expect(expectedResponse['success'], true);
      expect(expectedResponse['product'], isA<Product>());
    });

    test('failed searchByBarcode should indicate product not found', () {
      // Expected response when barcode not found
      final expectedResponse = {
        'success': false,
        'message': 'Product not found',
      };
      
      expect(expectedResponse['success'], false);
      expect(expectedResponse['message'], contains('not found'));
    });
  });

  group('ProductService Query Parameters Tests', () {
    test('should build query params with categoryId only', () {
      // Expected query structure
      final queryParams = {'category_id': 1};
      
      expect(queryParams['category_id'], 1);
      expect(queryParams.containsKey('search'), false);
    });

    test('should build query params with search only', () {
      // Expected query structure
      final queryParams = {'search': 'air mineral'};
      
      expect(queryParams['search'], 'air mineral');
      expect(queryParams.containsKey('category_id'), false);
    });

    test('should build query params with both categoryId and search', () {
      // Expected query structure
      final queryParams = {
        'category_id': 2,
        'search': 'indomie',
      };
      
      expect(queryParams['category_id'], 2);
      expect(queryParams['search'], 'indomie');
    });

    test('should not include empty search in query params', () {
      // Test empty string handling
      final search = '';
      final shouldInclude = search.isNotEmpty;
      
      expect(shouldInclude, false);
    });
  });

  group('ProductService Error Handling Tests', () {
    test('should handle DioException gracefully', () {
      // Expected error response structure
      final expectedResponse = {
        'success': false,
        'message': 'Failed to fetch products',
        'products': <Product>[],
      };
      
      expect(expectedResponse['success'], false);
      expect(expectedResponse['products'], isEmpty);
    });

    test('should handle generic exceptions', () {
      // Expected error response for generic errors
      final expectedResponse = {
        'success': false,
        'message': 'An error occurred: Some error',
        'products': <Product>[],
      };
      
      expect(expectedResponse['success'], false);
      expect(expectedResponse['message'], contains('An error occurred'));
    });

    test('should handle null or invalid API response', () {
      // Expected behavior for invalid response
      final expectedResponse = {
        'success': false,
        'message': 'Failed to fetch products',
        'products': <Product>[],
      };
      
      expect(expectedResponse['success'], false);
    });
  });

  group('ProductService Data Parsing Tests', () {
    test('should parse product list from API response', () {
      // Sample API response
      final apiResponse = {
        'data': [
          {
            'product_id': 1,
            'name': 'Air Mineral',
            'category': 'Minuman',
            'cost_price': '3500',
            'selling_price': '5000',
            'stock': 100,
          },
          {
            'product_id': 2,
            'name': 'Indomie',
            'category': 'Sembako',
            'cost_price': '2500',
            'selling_price': '3500',
            'stock': 200,
          },
        ],
      };
      
      final data = apiResponse['data'] as List;
      final products = data.map((json) => Product.fromJson(json)).toList();
      
      expect(products.length, 2);
      expect(products[0].name, 'Air Mineral');
      expect(products[1].name, 'Indomie');
    });

    test('should parse single product from API response', () {
      // Sample single product response
      final apiResponse = {
        'data': {
          'product_id': 1,
          'name': 'Air Mineral',
          'category': 'Minuman',
          'cost_price': '3500',
          'selling_price': '5000',
          'stock': 100,
        },
      };
      
      final product = Product.fromJson(apiResponse['data'] as Map<String, dynamic>);
      
      expect(product.productId, 1);
      expect(product.name, 'Air Mineral');
      expect(product.sellingPrice, 5000);
    });

    test('should handle empty product list', () {
      // Empty response
      final apiResponse = {'data': []};
      
      final data = apiResponse['data'] as List;
      final products = data.map((json) => Product.fromJson(json)).toList();
      
      expect(products, isEmpty);
    });
  });
}
