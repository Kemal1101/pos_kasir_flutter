import 'package:flutter_test/flutter_test.dart';
import 'package:pos_kasir_flutter/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('Product should be created with all required fields', () {
      print('\n🧪 TEST: Creating Product with all required fields');
      print('   Expected: Product instance with all properties set correctly');
      
      // Arrange & Act
      final product = Product(
        productId: 1,
        name: 'Air Mineral 600ml',
        category: 'Minuman',
        sellingPrice: 5000,
        costPrice: 3500,
        stock: 100,
        description: 'Air mineral kemasan 600ml',
      );

      // Assert
      expect(product.productId, 1);
      expect(product.name, 'Air Mineral 600ml');
      expect(product.category, 'Minuman');
      expect(product.sellingPrice, 5000);
      expect(product.costPrice, 3500);
      expect(product.stock, 100);
      expect(product.description, 'Air mineral kemasan 600ml');
      
      print('   ✅ Result: All product fields validated successfully');
    });

    test('Product should support optional categoriesId', () {
      print('\n🧪 TEST: Product optional categoriesId support');
      print('   Testing: Product with and without category ID');
      
      // Act
      final productWithCategory = Product(
        productId: 1,
        categoriesId: 2,
        name: 'Test Product',
        category: 'Test',
        sellingPrice: 1000,
        costPrice: 500,
        stock: 10,
      );

      final productWithoutCategory = Product(
        productId: 2,
        name: 'Test Product 2',
        category: 'Test',
        sellingPrice: 1000,
        costPrice: 500,
        stock: 10,
      );

      // Assert
      expect(productWithCategory.categoriesId, 2);
      expect(productWithoutCategory.categoriesId, null);
      
      print('   ✅ Result: Optional categoriesId working - With: 2, Without: null');
    });

    test('Product compatibility getters should work correctly', () {
      // Arrange
      final product = Product(
        productId: 123,
        name: 'Test Product',
        category: 'Test',
        sellingPrice: 10000,
        costPrice: 5000,
        stock: 50,
      );

      // Act & Assert
      expect(product.id, '123');
      expect(product.price, 10000);
    });

    test('Product fromJson should parse JSON correctly', () {
      print('\n🧪 TEST: Product JSON parsing (fromJson)');
      print('   Testing: Convert JSON data to Product object');
      
      // Arrange
      final json = {
        'product_id': 1,
        'categories_id': 2,
        'name': 'Air Mineral',
        'category': 'Minuman',
        'cost_price': '3500',
        'selling_price': '5000',
        'product_images': 'image.jpg',
        'stock': 100,
        'description': 'Air mineral kemasan',
      };

      // Act
      final product = Product.fromJson(json);

      // Assert
      expect(product.productId, 1);
      expect(product.categoriesId, 2);
      expect(product.name, 'Air Mineral');
      expect(product.category, 'Minuman');
      expect(product.costPrice, 3500);
      expect(product.sellingPrice, 5000);
      expect(product.productImages, 'image.jpg');
      expect(product.stock, 100);
      expect(product.description, 'Air mineral kemasan');
      
      print('   ✅ Result: JSON parsed successfully - Air Mineral @ Rp 5000');
    });

    test('Product fromJson should handle string product_id', () {
      // Arrange
      final json = {
        'product_id': '123',
        'name': 'Test',
        'category': 'Test',
        'cost_price': '1000',
        'selling_price': '2000',
        'stock': '50',
      };

      // Act
      final product = Product.fromJson(json);

      // Assert
      expect(product.productId, 123);
      expect(product.stock, 50);
    });

    test('Product fromJson should handle null categories_id', () {
      // Arrange
      final json = {
        'product_id': 1,
        'categories_id': null,
        'name': 'Test',
        'category': 'Test',
        'cost_price': '1000',
        'selling_price': '2000',
        'stock': 10,
      };

      // Act
      final product = Product.fromJson(json);

      // Assert
      expect(product.categoriesId, null);
    });

    test('Product fromJson should set default category when null', () {
      // Arrange
      final json = {
        'product_id': 1,
        'name': 'Test',
        'category': null,
        'cost_price': '1000',
        'selling_price': '2000',
        'stock': 10,
      };

      // Act
      final product = Product.fromJson(json);

      // Assert
      expect(product.category, 'Uncategorized');
    });

    test('Product fromJson should set empty description when null', () {
      // Arrange
      final json = {
        'product_id': 1,
        'name': 'Test',
        'category': 'Test',
        'cost_price': '1000',
        'selling_price': '2000',
        'stock': 10,
        'description': null,
      };

      // Act
      final product = Product.fromJson(json);

      // Assert
      expect(product.description, '');
    });

    test('Product toJson should convert to JSON correctly', () {
      // Arrange
      final product = Product(
        productId: 1,
        categoriesId: 2,
        name: 'Air Mineral',
        category: 'Minuman',
        sellingPrice: 5000,
        costPrice: 3500,
        stock: 100,
        productImages: 'image.jpg',
        description: 'Test description',
      );

      // Act
      final json = product.toJson();

      // Assert
      expect(json['product_id'], 1);
      expect(json['categories_id'], 2);
      expect(json['name'], 'Air Mineral');
      expect(json['category'], 'Minuman');
      expect(json['cost_price'], 3500);
      expect(json['selling_price'], 5000);
      expect(json['product_images'], 'image.jpg');
      expect(json['stock'], 100);
      expect(json['description'], 'Test description');
    });

    test('Product categories list should contain all expected categories', () {
      // Assert
      expect(Product.categories, contains('All'));
      expect(Product.categories, contains('Sembako'));
      expect(Product.categories, contains('Minuman'));
      expect(Product.categories, contains('Snack'));
      expect(Product.categories, contains('Kebutuhan Rumah'));
      expect(Product.categories, contains('Perawatan Pribadi'));
      expect(Product.categories.length, 6);
    });

    test('Product sampleProducts should contain valid products', () {
      // Assert
      expect(Product.sampleProducts.isNotEmpty, true);
      expect(Product.sampleProducts.length, 8);
      
      final firstProduct = Product.sampleProducts.first;
      expect(firstProduct.productId, isPositive);
      expect(firstProduct.name, isNotEmpty);
      expect(firstProduct.sellingPrice, isPositive);
    });
  });
}
