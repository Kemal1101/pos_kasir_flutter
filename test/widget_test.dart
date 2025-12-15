// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:pos_kasir_flutter/providers/cart_provider.dart';

import 'package:pos_kasir_flutter/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    print('\n🧪 WIDGET TEST: SuperCashier App Initialization');
    print('   Testing: App builds and starts without errors');
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => CartProvider(),
        child: const SuperCashierApp(),
      ),
    );

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify that the app builds without errors
    expect(find.byType(SuperCashierApp), findsOneWidget);
    
    print('   ✅ Result: App initialized successfully with CartProvider');
  });
}
