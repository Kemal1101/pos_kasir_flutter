// lib/main.dart
import 'package:flutter/material.dart';
import 'models/cart_item_model.dart';
import 'models/product_model.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/payment/payment_selection_screen.dart';
import 'screens/payment/qris_payment_screen.dart';
import 'screens/payment/cash_payment_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      Product(id: "1", name: 'Sneaker X', price: 250000.0, image: 'assets/images/sneaker.png'),
      Product(id: "2", name: 'Brigo Hoodie', price: 180000.0, image: 'assets/images/hoodie.png'),
      Product(id: "3", name: 'Red Scarf', price: 120000.0, image: 'assets/images/scarf.png'),
    ];

    final cartItems = [
      CartItem(product: products[0], quantity: 1),
      CartItem(product: products[1], quantity: 2),
      CartItem(product: products[2], quantity: 1),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SuperCashier',
      routes: {
        '/payment_selection': (context) {
          final total = ModalRoute.of(context)!.settings.arguments as double;
          return PaymentSelectionScreen(total: total);
        },
        '/qris_payment': (context) {
          final total = ModalRoute.of(context)!.settings.arguments as double;
          return QrisPaymentScreen(total: total);
        },
        '/cash_payment': (context) {
          final total = ModalRoute.of(context)!.settings.arguments as double;
          return CashPaymentScreen(total: total);
        },
      },
      home: PaymentScreen(cartItems: cartItems),
    );
  }
}
