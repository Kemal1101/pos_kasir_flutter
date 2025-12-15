# Unit Testing Guide - SuperCashier POS

## 📋 Overview
Project ini menggunakan **Flutter Unit Testing** dengan framework `flutter_test` dan `mockito` untuk mock dependencies.

**📖 Untuk dokumentasi lengkap setiap test, lihat:** [TEST_DOCUMENTATION.md](TEST_DOCUMENTATION.md)

## 🧪 Test Coverage

### 1. **Model Tests**
- ✅ `test/models/product_test.dart` - Product model serialization & validation
- ✅ `test/models/cart_item_test.dart` - CartItem calculations & state
- ✅ `test/models/sale_test.dart` - Sale & SaleItem models

### 2. **Provider Tests**
- ✅ `test/providers/cart_provider_test.dart` - CartProvider state management

### 3. **Service Tests**
- ✅ `test/services/auth_service_test.dart` - Authentication service
- ✅ `test/services/product_service_test.dart` - Product API service

### 4. **Utility Tests**
- ✅ `test/utils/responsive_helper_test.dart` - Responsive design helpers

## 🚀 Running Tests

### Run All Tests (Default)
```bash
flutter test
```

### Run All Tests with Detailed Output
```bash
flutter test --reporter expanded
```
*Menampilkan penjelasan lengkap setiap test dengan emoji dan hasil*

### Run Specific Test File
```bash
flutter test test/models/product_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Generate Coverage Report (HTML)
```bash
# Install genhtml (from lcov package)
# Windows: Use chocolatey
choco install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
start coverage/html/index.html
```

## 🔧 Setup

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Mocks (for mockito)
```bash
flutter pub run build_runner build
```

### 3. Clean & Rebuild (if needed)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📦 Test Dependencies

Dependencies sudah ditambahkan di `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4          # Mocking framework
  build_runner: ^2.4.7     # Code generation
```

## 🧩 Test Structure

### Model Test Example
```dart
test('Product should be created with all required fields', () {
  // Arrange & Act
  final product = Product(
    productId: 1,
    name: 'Air Mineral',
    category: 'Minuman',
    sellingPrice: 5000,
    costPrice: 3500,
    stock: 100,
  );

  // Assert
  expect(product.productId, 1);
  expect(product.name, 'Air Mineral');
});
```

### Provider Test Example
```dart
test('itemCount should calculate total quantity correctly', () {
  // Arrange
  cartProvider.items.add(CartItem(product: product1, quantity: 3));
  cartProvider.items.add(CartItem(product: product2, quantity: 2));

  // Assert
  expect(cartProvider.itemCount, 5); // 3 + 2
});
```

### Widget Test Example
```dart
testWidgets('isMobile should return true for width < 600', (tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(size: Size(400, 800)),
      child: Builder(
        builder: (context) {
          expect(ResponsiveHelper.isMobile(context), true);
          return Container();
        },
      ),
    ),
  );
});
```

## 📊 Test Categories

### ✅ Unit Tests
- Model data validation
- Utility functions
- Business logic calculations

### ✅ Widget Tests
- UI component behavior
- Responsive layout
- User interactions

### ⏳ Integration Tests (Future Work)
- API integration
- Database operations
- Full user flows

## 🎯 Testing Best Practices

1. **AAA Pattern** - Arrange, Act, Assert
2. **Descriptive Test Names** - Should clearly describe what is being tested
3. **Independent Tests** - Each test should be self-contained
4. **Mock External Dependencies** - Use mockito for API calls, database, etc.
5. **Test Edge Cases** - Null values, empty lists, boundary conditions

## 📝 Writing New Tests

### 1. Create Test File
```dart
// test/my_feature/my_class_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_kasir_flutter/my_feature/my_class.dart';

void main() {
  group('MyClass Tests', () {
    test('should do something', () {
      // Test implementation
    });
  });
}
```

### 2. Using Mockito for Mocking
```dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([MyService])
import 'my_class_test.mocks.dart';

void main() {
  late MockMyService mockService;
  
  setUp(() {
    mockService = MockMyService();
  });
  
  test('should call service', () {
    when(mockService.getData()).thenReturn('data');
    // Test implementation
  });
}
```

### 3. Generate Mocks
```bash
flutter pub run build_runner build
```

## 🐛 Troubleshooting

### Mock Generation Issues
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Test Dependencies Not Found
```bash
flutter pub get
flutter clean
flutter pub get
```

### Coverage Not Generated
- **Model Tests**: 40+ test cases ✅
- **Provider Tests**: 16+ test cases ✅
- **Service Tests**: 30+ test cases ✅
- **Utility Tests**: 20+ test cases ✅
- **Widget Tests**: 1+ test cases ✅

**Total**: **102 test cases** ✅
**Success Rate**: **100%** 🎉

### Test Output Features
Setiap test menampilkan:
- 🧪 **TEST:** Nama test yang sedang berjalan
- **Expected/Testing:** Apa yang diharapkan
- ✅ **Result:** Hasil dengan nilai aktual

**Contoh Output:**
```
🧪 TEST: CartItem totalAmount calculation
   Testing: quantity(3) × price(5000) = total(15000)
   ✅ Result: Total amount calculated correctly = Rp 15.000
```

## 📖 Detailed Documentation

Untuk penjelasan lengkap setiap test, lihat:
- **[TEST_DOCUMENTATION.md](TEST_DOCUMENTATION.md)** - Dokumentasi lengkap 102 test cases
- **Model Tests**: 40+ test cases
- **Provider Tests**: 10+ test cases
- **Service Tests**: 30+ test cases
- **Utility Tests**: 20+ test cases

**Total**: 100+ test cases ✅

## 🔮 Future Improvements

- [ ] Add integration tests for API endpoints
- [ ] Add widget tests for all screens
- [ ] Implement golden tests for UI consistency
- [ ] Add performance tests
- [ ] Set up CI/CD with automated testing
- [ ] Achieve 80%+ code coverage

## 📚 Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Flutter Test Coverage](https://flutter.dev/docs/testing/code-coverage)
- [Testing Best Practices](https://flutter.dev/docs/testing/best-practices)

---

**Happy Testing! 🧪✨**
