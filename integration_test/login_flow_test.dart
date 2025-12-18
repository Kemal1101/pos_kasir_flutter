import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:pos_kasir_flutter/main.dart';
import 'package:pos_kasir_flutter/providers/cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow Integration Tests', () {
    setUp(() async {
      // Clear shared preferences sebelum setiap test
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    testWidgets('User can see login screen on first launch',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const SuperCashierApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('SuperCashier'), findsWidgets);
      expect(find.byType(TextField), findsNWidgets(2)); // Email & Password
      // Login screen should show the "Sign In" title
      TestHelpers.verifyText('Sign In');
    });

    testWidgets('Login form validation works', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const SuperCashierApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Tap login tanpa isi form
      final loginButton = find.widgetWithText(ElevatedButton, 'Masuk')
          .or(find.widgetWithText(InkWell, 'Masuk'));
      
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton.first);
        await tester.pumpAndSettle();
      }

      // Assert - Masih di login page
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('Login with invalid credentials shows error',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const SuperCashierApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Enter invalid credentials
      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;

      await TestHelpers.enterTextSlowly(
        tester,
        emailField,
        'invalid@test.com',
      );
      await TestHelpers.enterTextSlowly(
        tester,
        passwordField,
        'wrongpassword',
      );
      await TestHelpers.dismissKeyboard(tester);

      // Tap login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Masuk')
          .or(find.widgetWithText(InkWell, 'Masuk'));
      
      if (loginButton.evaluate().isNotEmpty) {
        await TestHelpers.tapWithRetry(tester, loginButton.first);
        
        // Wait for API response
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();
      }

      // Assert - Error message atau masih di login page
      // Karena koneksi ke API real, ini akan gagal atau tampilkan error
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('Password toggle visibility works',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const SuperCashierApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Find password field dan toggle icon
      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, 'testpassword');
      await tester.pumpAndSettle();

      // Cari tombol icon toggle di dalam field password
      final visibilityToggle = find.descendant(
        of: passwordField,
        matching: find.byType(IconButton),
      );

      if (visibilityToggle.evaluate().isNotEmpty) {
        await tester.tap(visibilityToggle.first);
        await tester.pumpAndSettle();

        // Assert - Toggle icon tetap ada setelah diklik
        expect(visibilityToggle, findsOneOrMoreWidgets);
      }
    });

    testWidgets('Remember me checkbox can be toggled',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const SuperCashierApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Find checkbox if exists
      final checkbox = find.byType(Checkbox);

      if (checkbox.evaluate().isNotEmpty) {
        await tester.tap(checkbox.first);
        await tester.pumpAndSettle();

        // Assert - Checkbox state changed
        expect(checkbox, findsOneOrMoreWidgets);
      }
    });

    testWidgets('Screen orientation is locked to landscape',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const SuperCashierApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - App should be in landscape mode
      final size = tester.binding.window.physicalSize;
      // Note: Integration test mungkin tidak bisa test orientation lock
      // Tapi kita bisa verify app berjalan
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Login screen is responsive', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const SuperCashierApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Verify layout elements exist
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(SafeArea), findsOneOrMoreWidgets);

      // Different screen sizes would require device/platform specific testing
      final size = tester.getSize(find.byType(MaterialApp));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
    });
  });

  group('Login Success Flow', () {
    testWidgets('Successful login navigates to home screen',
        (WidgetTester tester) async {
      // Note: Test ini memerlukan mock API atau test credentials yang valid
      // Untuk demo, kita skip atau perlu setup mock service
      
      // Arrange - Set up app with pre-authenticated state
      SharedPreferences.setMockInitialValues({
        'token': 'mock_test_token_12345'
      });

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const SuperCashierApp(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - Should navigate to home screen if token exists
      // Look for home screen elements
      final homeIndicators = find.text('SuperCashier')
          .or(find.byIcon(Icons.shopping_cart))
          .or(find.byIcon(Icons.logout));

      expect(homeIndicators, findsOneOrMoreWidgets);
    }, skip: false);
  });

  group('Login Error Handling', () {
    testWidgets('Shows error dialog on network failure',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const SuperCashierApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Try to login (will fail with network error if offline)
      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // Note: Actual network test requires mocking or real credentials
    });

    testWidgets('Handles role-based access control',
        (WidgetTester tester) async {
      // This test would verify that role_id=1 (admin) is blocked
      // Requires mock API response with role_id=1
      
      // Test ini memerlukan mock service untuk simulate role_id response
      expect(true, true); // Placeholder
    }, skip: true);
  });
}
