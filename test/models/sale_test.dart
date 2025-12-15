import 'package:flutter_test/flutter_test.dart';
import 'package:pos_kasir_flutter/models/sale.dart';

void main() {
  group('Sale Model Tests', () {
    test('Sale should be created with all required fields', () {
      print('\n🧪 TEST: Creating Sale with all required fields');
      print('   Expected: Sale instance with subtotal, discount, tax, total');
      
      // Arrange & Act
      final sale = Sale(
        saleId: 1,
        userId: 10,
        subtotal: 50000,
        discountAmount: 5000,
        taxAmount: 4950,
        totalAmount: 49950,
        paymentStatus: 'draft',
        saleDate: DateTime(2025, 12, 15),
      );

      // Assert
      expect(sale.saleId, 1);
      expect(sale.userId, 10);
      expect(sale.subtotal, 50000);
      expect(sale.discountAmount, 5000);
      expect(sale.taxAmount, 4950);
      expect(sale.totalAmount, 49950);
      expect(sale.paymentStatus, 'draft');
      expect(sale.paymentId, null);
      expect(sale.items, null);
      
      print('   ✅ Result: Sale created - Subtotal: 50000, Discount: 5000, Total: 49950');
    });

    test('Sale should support optional paymentId and items', () {
      // Arrange
      final saleItems = [
        SaleItem(
          saleId: 1,
          productId: 1,
          nameProduct: 'Test Product',
          quantity: 2,
          subtotal: 20000,
          discountAmount: 0,
        ),
      ];

      // Act
      final sale = Sale(
        saleId: 1,
        userId: 10,
        paymentId: 99,
        subtotal: 20000,
        discountAmount: 0,
        taxAmount: 2200,
        totalAmount: 22200,
        paymentStatus: 'paid',
        saleDate: DateTime.now(),
        items: saleItems,
      );

      // Assert
      expect(sale.paymentId, 99);
      expect(sale.items, saleItems);
      expect(sale.items!.length, 1);
    });

    test('Sale fromJson should parse JSON correctly', () {
      print('\n🧪 TEST: Sale JSON parsing');
      print('   Testing: Parse sale data from API response');
      
      // Arrange
      final json = {
        'sale_id': 1,
        'user_id': 10,
        'payment_id': 5,
        'subtotal': '50000',
        'discount_amount': '5000',
        'tax_amount': '4950',
        'total_amount': '49950',
        'payment_status': 'paid',
        'sale_date': '2025-12-15T10:00:00.000Z',
      };

      // Act
      final sale = Sale.fromJson(json);

      // Assert
      expect(sale.saleId, 1);
      expect(sale.userId, 10);
      expect(sale.paymentId, 5);
      expect(sale.subtotal, 50000);
      expect(sale.discountAmount, 5000);
      expect(sale.taxAmount, 4950);
      expect(sale.totalAmount, 49950);
      expect(sale.paymentStatus, 'paid');
      
      print('   ✅ Result: Sale parsed - Status: paid, Total: Rp 49.950');
    });

    test('Sale fromJson should handle string IDs', () {
      // Arrange
      final json = {
        'sale_id': '123',
        'user_id': '456',
        'payment_id': '789',
        'subtotal': '10000',
        'discount_amount': '0',
        'tax_amount': '1100',
        'total_amount': '11100',
        'payment_status': 'draft',
        'sale_date': '2025-12-15T10:00:00.000Z',
      };

      // Act
      final sale = Sale.fromJson(json);

      // Assert
      expect(sale.saleId, 123);
      expect(sale.userId, 456);
      expect(sale.paymentId, 789);
    });

    test('Sale fromJson should handle null payment_id', () {
      // Arrange
      final json = {
        'sale_id': 1,
        'user_id': 10,
        'payment_id': null,
        'subtotal': '10000',
        'discount_amount': '0',
        'tax_amount': '1100',
        'total_amount': '11100',
        'payment_status': 'draft',
        'sale_date': '2025-12-15T10:00:00.000Z',
      };

      // Act
      final sale = Sale.fromJson(json);

      // Assert
      expect(sale.paymentId, null);
    });

    test('Sale fromJson should parse items array', () {
      // Arrange
      final json = {
        'sale_id': 1,
        'user_id': 10,
        'subtotal': '20000',
        'discount_amount': '0',
        'tax_amount': '2200',
        'total_amount': '22200',
        'payment_status': 'draft',
        'sale_date': '2025-12-15T10:00:00.000Z',
        'items': [
          {
            'sale_id': 1,
            'product_id': 1,
            'name_product': 'Product 1',
            'quantity': 2,
            'subtotal': '20000',
            'discount_amount': '0',
          },
        ],
      };

      // Act
      final sale = Sale.fromJson(json);

      // Assert
      expect(sale.items, isNotNull);
      expect(sale.items!.length, 1);
      expect(sale.items!.first.nameProduct, 'Product 1');
    });

    test('Sale toJson should convert to JSON correctly', () {
      // Arrange
      final sale = Sale(
        saleId: 1,
        userId: 10,
        paymentId: 5,
        subtotal: 50000,
        discountAmount: 5000,
        taxAmount: 4950,
        totalAmount: 49950,
        paymentStatus: 'paid',
        saleDate: DateTime(2025, 12, 15, 10, 0, 0),
      );

      // Act
      final json = sale.toJson();

      // Assert
      expect(json['sale_id'], 1);
      expect(json['user_id'], 10);
      expect(json['payment_id'], 5);
      expect(json['subtotal'], 50000);
      expect(json['discount_amount'], 5000);
      expect(json['tax_amount'], 4950);
      expect(json['total_amount'], 49950);
      expect(json['payment_status'], 'paid');
      expect(json['sale_date'], isNotNull);
    });

    test('Sale copyWith should create modified copy', () {
      // Arrange
      final original = Sale(
        saleId: 1,
        userId: 10,
        subtotal: 50000,
        discountAmount: 5000,
        taxAmount: 4950,
        totalAmount: 49950,
        paymentStatus: 'draft',
        saleDate: DateTime.now(),
      );

      // Act
      final modified = original.copyWith(
        paymentStatus: 'paid',
        totalAmount: 45000,
      );

      // Assert
      expect(modified.saleId, original.saleId);
      expect(modified.userId, original.userId);
      expect(modified.paymentStatus, 'paid');
      expect(modified.totalAmount, 45000);
      expect(modified.subtotal, original.subtotal);
    });
  });

  group('SaleItem Model Tests', () {
    test('SaleItem should be created with all fields', () {
      // Act
      final saleItem = SaleItem(
        saleItemId: 1,
        saleId: 10,
        productId: 5,
        nameProduct: 'Air Mineral',
        quantity: 3,
        subtotal: 15000,
        discountAmount: 500,
      );

      // Assert
      expect(saleItem.saleItemId, 1);
      expect(saleItem.saleId, 10);
      expect(saleItem.productId, 5);
      expect(saleItem.nameProduct, 'Air Mineral');
      expect(saleItem.quantity, 3);
      expect(saleItem.subtotal, 15000);
      expect(saleItem.discountAmount, 500);
    });

    test('SaleItem should support null saleItemId', () {
      // Act
      final saleItem = SaleItem(
        saleId: 10,
        productId: 5,
        nameProduct: 'Product',
        quantity: 1,
        subtotal: 1000,
        discountAmount: 0,
      );

      // Assert
      expect(saleItem.saleItemId, null);
    });

    test('SaleItem fromJson should parse correctly', () {
      // Arrange
      final json = {
        'sale_item_id': 1,
        'sale_id': 10,
        'product_id': 5,
        'name_product': 'Air Mineral',
        'quantity': 3,
        'subtotal': '15000',
        'discount_amount': '500',
      };

      // Act
      final saleItem = SaleItem.fromJson(json);

      // Assert
      expect(saleItem.saleItemId, 1);
      expect(saleItem.nameProduct, 'Air Mineral');
      expect(saleItem.quantity, 3);
      expect(saleItem.subtotal, 15000);
    });

    test('SaleItem toJson should convert correctly', () {
      // Arrange
      final saleItem = SaleItem(
        saleItemId: 1,
        saleId: 10,
        productId: 5,
        nameProduct: 'Air Mineral',
        quantity: 3,
        subtotal: 15000,
        discountAmount: 500,
      );

      // Act
      final json = saleItem.toJson();

      // Assert
      expect(json['sale_item_id'], 1);
      expect(json['sale_id'], 10);
      expect(json['product_id'], 5);
      expect(json['name_product'], 'Air Mineral');
      expect(json['quantity'], 3);
      expect(json['subtotal'], 15000);
      expect(json['discount_amount'], 500);
    });
  });
}
