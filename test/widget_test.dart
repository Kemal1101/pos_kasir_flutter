// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:pos_kasir_flutter/providers/cart_provider.dart';
import 'package:pos_kasir_flutter/screens/catalog_screen.dart';

import 'package:pos_kasir_flutter/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App starts and displays CatalogScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => CartProvider(),
        child: const SuperCashierApp(),
      ),
    );

    // Verify that the HomeScreen's AppBar title is present.
    expect(find.text('SuperCashier'), findsOneWidget);
    // Verify that the CatalogScreen is being displayed.
    expect(find.byType(CatalogScreen), findsOneWidget);
  });
}
