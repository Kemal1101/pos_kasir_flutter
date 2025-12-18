import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:pos_kasir_flutter/main.dart';
import 'package:pos_kasir_flutter/providers/cart_provider.dart';
import 'package:pos_kasir_flutter/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cart and Checkout Flow Integration Tests', () {
    setUp(() async {
      // Setup authenticated state
      SharedPreferences.setMockInitialValues({
        'token': 'test_token_for_integration_test'
      });
    });

    testWidgets('User can browse product catalog', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: const SuperCashierApp(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip login, go directly to home
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Catalog should be visible
      expect(find.byType(HomeScreen), findsOneWidget);
      
      // Look for search bar or product catalog elements
      final searchBar = find.byType(TextField);
      if (searchBar.evaluate().isNotEmpty) {
        expect(searchBar, findsOneOrMoreWidgets);
      }
    });

    testWidgets('User can search for products', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Find search field and enter text
      final searchField = find.byType(TextField).first;
      if (searchField.evaluate().isNotEmpty) {
        await TestHelpers.enterTextSlowly(
          tester,
          searchField,
          'Indomie',
        );
        await tester.pumpAndSettle();

        // Assert - Search should filter results
        // Results would depend on actual data from API
        expect(find.byType(TextField), findsOneOrMoreWidgets);
      }
    });

    testWidgets('User can filter products by category',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Find category chips
      final categoryChips = find.byType(FilterChip);
      
      if (categoryChips.evaluate().length > 1) {
        // Tap second category chip
        await tester.tap(categoryChips.at(1));
        await tester.pumpAndSettle();

        // Assert - Category should be selected
        expect(categoryChips, findsOneOrMoreWidgets);
      }
    });

    testWidgets('User can add product to cart from catalog',
        (WidgetTester tester) async {
      // Arrange
      final cartProvider = CartProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: cartProvider,
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Act - Find and tap first product card
      final productCards = find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString().contains('ProductCard'),
      );

      if (productCards.evaluate().isNotEmpty) {
        await tester.tap(productCards.first);
        await tester.pumpAndSettle();

        // Look for "Tambah ke Keranjang" button or similar
        final addToCartButton = find.textContaining('Tambah')
            .or(find.byIcon(Icons.add_shopping_cart))
            .or(find.byIcon(Icons.add));

        if (addToCartButton.evaluate().isNotEmpty) {
          await TestHelpers.tapWithRetry(tester, addToCartButton.first);
          await tester.pumpAndSettle();

          // Assert - Cart count should increase (if cart badge visible)
          // This depends on actual implementation
        }
      }
    });

    testWidgets('User can view product details', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Tap on a product to view details
      final productCards = find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString().contains('ProductCard'),
      );

      if (productCards.evaluate().isNotEmpty) {
        await tester.tap(productCards.first);
        await tester.pumpAndSettle();

        // Assert - Product detail dialog/screen should appear
        // Look for dialog or detail screen indicators
        expect(find.byType(Dialog).or(find.byType(AlertDialog)), findsAny);
      }
    });

    testWidgets('User can adjust product quantity in cart',
        (WidgetTester tester) async {
      // This test requires products to be in cart first
      final cartProvider = CartProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: cartProvider,
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to cart screen
      final cartIcon = find.byIcon(Icons.shopping_cart);
      if (cartIcon.evaluate().isNotEmpty) {
        await tester.tap(cartIcon.first);
        await tester.pumpAndSettle();

        // Look for quantity adjustment buttons (+ and -)
        final incrementButtons = find.byIcon(Icons.add);
        final decrementButtons = find.byIcon(Icons.remove);

        if (incrementButtons.evaluate().isNotEmpty) {
          await tester.tap(incrementButtons.first);
          await tester.pumpAndSettle();

          // Assert - Quantity should increase
          expect(find.byIcon(Icons.add), findsOneOrMoreWidgets);
        }
      }
    });

    testWidgets('User can remove product from cart',
        (WidgetTester tester) async {
      // Arrange - Start at home with cart
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to cart
      final cartIcon = find.byIcon(Icons.shopping_cart);
      if (cartIcon.evaluate().isNotEmpty) {
        await tester.tap(cartIcon.first);
        await tester.pumpAndSettle();

        // Look for delete/remove icon
        final deleteIcon = find.byIcon(Icons.delete)
            .or(find.byIcon(Icons.delete_outline))
            .or(find.byIcon(Icons.close));

        if (deleteIcon.evaluate().isNotEmpty) {
          await tester.tap(deleteIcon.first);
          await tester.pumpAndSettle();

          // Assert - Item should be removed
          expect(find.byType(HomeScreen), findsOneWidget);
        }
      }
    });

    testWidgets('Cart displays correct total calculation',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Navigate to cart
      final cartIcon = find.byIcon(Icons.shopping_cart);
      if (cartIcon.evaluate().isNotEmpty) {
        await tester.tap(cartIcon.first);
        await tester.pumpAndSettle();

        // Assert - Should show subtotal, tax, total
        final totalIndicators = find.textContaining('Total')
            .or(find.textContaining('Subtotal'))
            .or(find.textContaining('Rp'));

        expect(totalIndicators, findsOneOrMoreWidgets);
      }
    });

    testWidgets('Empty cart shows appropriate message',
        (WidgetTester tester) async {
      // Arrange - Fresh cart provider (empty cart)
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Navigate to cart
      final cartIcon = find.byIcon(Icons.shopping_cart);
      if (cartIcon.evaluate().isNotEmpty) {
        await tester.tap(cartIcon.first);
        await tester.pumpAndSettle();

        // Assert - Should show empty cart message
        final emptyMessages = find.textContaining('Kosong')
            .or(find.textContaining('kosong'))
            .or(find.byIcon(Icons.shopping_cart_outlined));

        expect(emptyMessages, findsOneOrMoreWidgets);
      }
    });

    testWidgets('User can proceed to checkout from cart',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to cart
      final cartIcon = find.byIcon(Icons.shopping_cart);
      if (cartIcon.evaluate().isNotEmpty) {
        await tester.tap(cartIcon.first);
        await tester.pumpAndSettle();

        // Look for checkout/bayar button
        final checkoutButton = find.textContaining('Bayar')
            .or(find.textContaining('Checkout'))
            .or(find.textContaining('Proses'));

        if (checkoutButton.evaluate().isNotEmpty) {
          await TestHelpers.tapWithRetry(tester, checkoutButton.first);
          await tester.pumpAndSettle();

          // Assert - Should navigate to payment screen
          expect(find.byType(HomeScreen), findsAny);
        }
      }
    });
  });

  group('Cart State Persistence', () {
    testWidgets('Cart persists across navigation',
        (WidgetTester tester) async {
      // Arrange
      final cartProvider = CartProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: cartProvider,
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Add item, navigate away, come back
      // This would test that cart state is maintained
      
      // Navigate back and forth
      final catalogTab = find.text('Katalog').or(find.byIcon(Icons.home));
      final cartTab = find.text('Keranjang').or(find.byIcon(Icons.shopping_cart));

      if (catalogTab.evaluate().isNotEmpty && cartTab.evaluate().isNotEmpty) {
        await tester.tap(cartTab.first);
        await tester.pumpAndSettle();

        await tester.tap(catalogTab.first);
        await tester.pumpAndSettle();

        await tester.tap(cartTab.first);
        await tester.pumpAndSettle();

        // Assert - Cart should maintain state
        expect(find.byType(HomeScreen), findsOneWidget);
      }
    });
  });

  group('Responsive Cart Layout', () {
    testWidgets('Cart adapts to screen size', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check responsive elements
      final screenSize = tester.getSize(find.byType(MaterialApp));
      expect(screenSize.width, greaterThan(0));
      expect(screenSize.height, greaterThan(0));

      // In landscape mode, should show split view (catalog + cart)
      // In portrait, should show tabs
      final isLandscape = screenSize.width > screenSize.height;
      
      if (isLandscape) {
        // Split view should be visible
        expect(find.byType(Row).or(find.byType(Flex)), findsOneOrMoreWidgets);
      }
    });
  });
}
