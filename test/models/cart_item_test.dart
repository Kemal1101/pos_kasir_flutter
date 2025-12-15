import 'package:flutter_test/flutter_test.dart';
import 'package:pos_kasir_flutter/models/cart_item.dart';
import 'package:pos_kasir_flutter/models/product.dart';

void main() {
  group('CartItem Model Tests', () {
    late Product testProduct;

    setUp(() {
      testProduct = Product(
        productId: 1,
        name: 'Air Mineral',
        category: 'Minuman',
        sellingPrice: 5000,
        costPrice: 3500,
        stock: 100,
      );
    });

    test('CartItem should be created with default values', () {
      print('\n🧪 TEST: CartItem default values');
      print('   Testing: CartItem created with default quantity=1, selected=true');
      
      // Act
      final cartItem = CartItem(product: testProduct);

      // Assert
      expect(cartItem.product, testProduct);
      expect(cartItem.quantity, 1);
      expect(cartItem.sizeColor, 'Default');
      expect(cartItem.isSelected, true);
      expect(cartItem.saleItemId, null);
      
      print('   ✅ Result: CartItem initialized - Qty: 1, Selected: true');
    });

    test('CartItem should be created with custom values', () {
      // Act
      final cartItem = CartItem(
        product: testProduct,
        quantity: 5,
        sizeColor: 'Large',
        isSelected: false,
        saleItemId: 123,
      );

      // Assert
      expect(cartItem.quantity, 5);
      expect(cartItem.sizeColor, 'Large');
      expect(cartItem.isSelected, false);
      expect(cartItem.saleItemId, 123);
    });

    test('CartItem totalAmount should calculate correctly', () {
      print('\n🧪 TEST: CartItem totalAmount calculation');
      print('   Testing: quantity(3) × price(5000) = total(15000)');
      
      // Arrange
      final cartItem = CartItem(
        product: testProduct,
        quantity: 3,
      );

      // Act
      final totalAmount = cartItem.totalAmount;

      // Assert
      expect(totalAmount, 15000); // 5000 * 3
      
      print('   ✅ Result: Total amount calculated correctly = Rp 15.000');
    });

    test('CartItem totalPrice should be alias of totalAmount', () {
      // Arrange
      final cartItem = CartItem(
        product: testProduct,
        quantity: 2,
      );

      // Assert
      expect(cartItem.totalPrice, cartItem.totalAmount);
      expect(cartItem.totalPrice, 10000); // 5000 * 2
    });

    test('CartItem totalAmount should update when quantity changes', () {
      // Arrange
      final cartItem = CartItem(
        product: testProduct,
        quantity: 1,
      );

      // Assert initial
      expect(cartItem.totalAmount, 5000);

      // Act - change quantity
      cartItem.quantity = 4;

      // Assert after change
      expect(cartItem.totalAmount, 20000); // 5000 * 4
    });

    test('CartItem should work with products having different prices', () {
      // Arrange
      final expensiveProduct = Product(
        productId: 2,
        name: 'Premium Product',
        category: 'Premium',
        sellingPrice: 50000,
        costPrice: 30000,
        stock: 10,
      );

      final cartItem = CartItem(
        product: expensiveProduct,
        quantity: 2,
      );

      // Assert
      expect(cartItem.totalAmount, 100000); // 50000 * 2
    });

    test('CartItem quantity can be modified', () {
      // Arrange
      final cartItem = CartItem(product: testProduct);

      // Act
      cartItem.quantity = 10;

      // Assert
      expect(cartItem.quantity, 10);
      expect(cartItem.totalAmount, 50000);
    });

    test('CartItem isSelected can be toggled', () {
      // Arrange
      final cartItem = CartItem(product: testProduct);

      // Assert initial
      expect(cartItem.isSelected, true);

      // Act
      cartItem.isSelected = false;

      // Assert after toggle
      expect(cartItem.isSelected, false);
    });
  });
}
