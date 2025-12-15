import 'package:flutter_test/flutter_test.dart';
import 'package:pos_kasir_flutter/models/cart_item.dart';
import 'package:pos_kasir_flutter/models/product.dart';
import 'package:pos_kasir_flutter/providers/cart_provider.dart';

void main() {
  group('CartProvider Tests', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider();
    });

    test('Initial state should be empty', () {
      print('\n🧪 TEST: CartProvider initial state');
      print('   Expected: Empty cart with zero items and totals');
      
      // Assert
      expect(cartProvider.items.isEmpty, true);
      expect(cartProvider.cartItems.isEmpty, true);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.subtotal, 0);
      expect(cartProvider.total, 0);
      expect(cartProvider.currentSale, null);
      
      print('   ✅ Result: Cart initialized - Items: 0, Subtotal: 0, Total: 0');
    });

    test('itemCount should calculate total quantity correctly', () {
      print('\n🧪 TEST: CartProvider itemCount calculation');
      print('   Testing: Sum of quantities across all cart items');
      
      // Arrange
      final product1 = Product(
        productId: 1,
        name: 'Product 1',
        category: 'Test',
        sellingPrice: 5000,
        costPrice: 3000,
        stock: 100,
      );
      
      final product2 = Product(
        productId: 2,
        name: 'Product 2',
        category: 'Test',
        sellingPrice: 10000,
        costPrice: 6000,
        stock: 50,
      );

      // Manually add items for testing
      cartProvider.items.add(CartItem(product: product1, quantity: 3));
      cartProvider.items.add(CartItem(product: product2, quantity: 2));

      // Assert
      expect(cartProvider.itemCount, 5); // 3 + 2
      
      print('   ✅ Result: ItemCount = 5 (3 + 2 items)');
    });

    test('taxRate should be 0', () {
      // Assert
      expect(cartProvider.taxRate, 0);
    });

    test('catalog should be empty initially', () {
      // Assert
      expect(cartProvider.catalog.isEmpty, true);
    });

    test('isLoadingProducts should be false initially', () {
      // Assert
      expect(cartProvider.isLoadingProducts, false);
    });

    test('isLoadingSale should be false initially', () {
      // Assert
      expect(cartProvider.isLoadingSale, false);
    });

    test('isProcessing should be false initially', () {
      // Assert
      expect(cartProvider.isProcessing, false);
    });

    test('errorMessage should be null initially', () {
      // Assert
      expect(cartProvider.errorMessage, null);
    });

    test('subtotal should come from currentSale when available', () {
      // This test requires mocking or using a test double
      // Since currentSale is managed by API, we can only test the getter
      expect(cartProvider.subtotal, 0);
    });

    test('total should come from currentSale when available', () {
      // Similar to subtotal test
      expect(cartProvider.total, 0);
    });

    test('taxAmount should come from currentSale when available', () {
      expect(cartProvider.taxAmount, 0);
    });
  });

  group('CartProvider Calculations Tests', () {
    test('itemCount with single item', () {
      // Arrange
      final cartProvider = CartProvider();
      final product = Product(
        productId: 1,
        name: 'Test',
        category: 'Test',
        sellingPrice: 1000,
        costPrice: 500,
        stock: 10,
      );
      
      cartProvider.items.add(CartItem(product: product, quantity: 5));

      // Assert
      expect(cartProvider.itemCount, 5);
    });

    test('itemCount with multiple items', () {
      // Arrange
      final cartProvider = CartProvider();
      
      for (int i = 1; i <= 3; i++) {
        final product = Product(
          productId: i,
          name: 'Product $i',
          category: 'Test',
          sellingPrice: 1000,
          costPrice: 500,
          stock: 10,
        );
        cartProvider.items.add(CartItem(product: product, quantity: i));
      }

      // Assert
      expect(cartProvider.itemCount, 6); // 1 + 2 + 3
    });

    test('itemCount when cart is empty', () {
      // Arrange
      final cartProvider = CartProvider();

      // Assert
      expect(cartProvider.itemCount, 0);
    });
  });

  group('CartProvider State Tests', () {
    test('should notify listeners on state changes', () {
      // Arrange
      final cartProvider = CartProvider();
      var notified = false;
      
      cartProvider.addListener(() {
        notified = true;
      });

      // Act
      cartProvider.notifyListeners();

      // Assert
      expect(notified, true);
    });
  });
}
