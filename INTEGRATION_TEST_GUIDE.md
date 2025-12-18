# Integration Testing Guide

## 📋 Overview

Dokumen ini menjelaskan cara menjalankan integration testing untuk aplikasi SuperCashier POS.

## 🗂️ Struktur Integration Tests

```
integration_test/
├── app_test.dart                    # End-to-end user journey tests
├── login_flow_test.dart             # Login & authentication tests
├── cart_checkout_flow_test.dart     # Cart & checkout flow tests
├── payment_flow_test.dart           # Payment processing tests
└── helpers/
    └── test_helpers.dart            # Utility functions untuk testing
```

## 🚀 Cara Menjalankan Integration Tests

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run Semua Integration Tests

```bash
flutter test integration_test
```

### 3. Run Test Spesifik

```bash
# Login flow tests
flutter test integration_test/login_flow_test.dart

# Cart & checkout tests
flutter test integration_test/cart_checkout_flow_test.dart

# Payment flow tests
flutter test integration_test/payment_flow_test.dart

# Complete end-to-end tests
flutter test integration_test/app_test.dart
```

### 4. Run di Device/Emulator Spesifik

```bash
# Run di Android emulator
flutter test integration_test --device-id=emulator-5554

# Run di iOS simulator
flutter test integration_test --device-id=iPhone-14

# List available devices
flutter devices
```

### 5. Run dengan Coverage Report

```bash
flutter test --coverage integration_test
genhtml coverage/lcov.info -o coverage/html
```

### 6. Run dengan Screenshots (untuk debugging)

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  --screenshot
```

## 📝 Test Coverage

### Login Flow Tests (`login_flow_test.dart`)

✅ **Tested Scenarios:**
- App launch menampilkan login screen
- Form validation bekerja dengan benar
- Login dengan kredensial tidak valid
- Password visibility toggle
- Remember me checkbox
- Orientation lock ke landscape
- Responsive layout
- Login success navigasi ke home

### Cart & Checkout Tests (`cart_checkout_flow_test.dart`)

✅ **Tested Scenarios:**
- Browse product catalog
- Search products
- Filter by category
- Add product to cart
- View product details
- Adjust quantity di cart
- Remove product dari cart
- Calculate total dengan benar
- Empty cart message
- Proceed to checkout
- Cart state persistence
- Responsive cart layout

### Payment Flow Tests (`payment_flow_test.dart`)

✅ **Tested Scenarios:**
- Navigate ke payment screen
- Display payment methods (Cash, QRIS, dll)
- Select payment method
- Cash payment calculation
- QRIS QR code generation
- Payment success confirmation
- Receipt generation
- Print receipt
- Cancel payment
- Clear cart after payment
- Success animation (Lottie)
- Return to home after payment

### End-to-End Tests (`app_test.dart`)

✅ **Tested Scenarios:**
- Complete user journey: Login → Catalog → Cart → Payment
- Multiple transactions in sequence
- Network interruption handling
- State persistence during orientation changes
- Logout functionality
- Rapid button tap handling
- Large product list performance
- Accessibility compliance

## 🔧 Test Helpers

File `test_helpers.dart` menyediakan utility functions:

```dart
// Wait for widget to appear
await TestHelpers.waitForWidget(tester, finder);

// Wait for loading to finish
await TestHelpers.waitForLoadingToFinish(tester);

// Scroll to widget
await TestHelpers.scrollToWidget(tester, finder);

// Enter text slowly (simulate user typing)
await TestHelpers.enterTextSlowly(tester, finder, 'text');

// Tap with retry
await TestHelpers.tapWithRetry(tester, finder);

// Verify text exists
TestHelpers.verifyText('Expected Text');

// Format currency
String formatted = TestHelpers.formatCurrency(15000);

// Dismiss keyboard
await TestHelpers.dismissKeyboard(tester);
```

## ⚠️ Catatan Penting

### API Dependencies

Beberapa test memerlukan koneksi ke backend API:
- `login_flow_test.dart` - requires valid test credentials
- `cart_checkout_flow_test.dart` - requires product API
- `payment_flow_test.dart` - requires payment API

Untuk testing yang lebih reliable, pertimbangkan:
1. **Mock API responses** menggunakan `mockito`
2. **Setup test server** dengan data fixture
3. **Use integration test environment** dengan test database

### Test Environment Setup

Tambahkan test credentials di environment variables:

```bash
# .env.test
TEST_EMAIL=test@supercashier.com
TEST_PASSWORD=testpassword123
API_BASE_URL=https://supercashier.my.id/api
```

### Skipped Tests

Beberapa test di-skip karena memerlukan:
- Mock API setup
- Real payment gateway credentials
- Specific device capabilities

Untuk enable skipped tests, hapus `skip: true` parameter.

## 🐛 Troubleshooting

### Test Timeout

Jika test timeout, increase timeout duration:

```dart
testWidgets('My test', (tester) async {
  await tester.pumpAndSettle(const Duration(seconds: 10));
}, timeout: const Timeout(Duration(minutes: 2)));
```

### Widget Not Found

Gunakan debug helpers:

```dart
// Print widget tree
debugDumpApp();

// Print render tree
debugDumpRenderTree();

// Take screenshot
await TestHelpers.takeScreenshot(tester, 'debug_screenshot');
```

### Network Errors

Pastikan:
1. Device/emulator memiliki koneksi internet
2. API server running dan accessible
3. Firewall tidak blocking koneksi

### Platform-Specific Issues

```bash
# Android: Clear app data
adb shell pm clear com.example.pos_kasir_flutter

# iOS: Reset simulator
xcrun simctl erase all
```

## 📊 Best Practices

1. **Isolate Tests**: Setiap test harus independent
2. **Clean State**: Use `setUp()` untuk reset state
3. **Descriptive Names**: Test names harus jelas describe behavior
4. **Assertion Messages**: Provide clear failure messages
5. **Avoid Hardcoded Delays**: Use `pumpAndSettle()` instead of `Future.delayed()`
6. **Group Related Tests**: Organize dengan `group()`
7. **Mock External Dependencies**: Don't depend on real API for unit tests

## 🔄 CI/CD Integration

### GitHub Actions Example

```yaml
name: Integration Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.0'
      - run: flutter pub get
      - run: flutter test integration_test
```

## 📈 Coverage Goals

Target coverage untuk integration tests:
- **Critical User Flows**: 100%
- **Happy Path**: 100%
- **Error Handling**: 80%
- **Edge Cases**: 60%

## 🆘 Support

Untuk pertanyaan atau issues:
1. Check dokumentasi di `TEST_DOCUMENTATION.md`
2. Review `TESTING_GUIDE.md`
3. Contact development team

## 📚 Resources

- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [IntegrationTestWidgetsFlutterBinding](https://api.flutter.dev/flutter/flutter_test/IntegrationTestWidgetsFlutterBinding-class.html)
- [Flutter Drive](https://docs.flutter.dev/cookbook/testing/integration/introduction)
- [Testing Best Practices](https://docs.flutter.dev/testing/best-practices)

---

**Last Updated**: December 18, 2025
**Version**: 1.0.0
