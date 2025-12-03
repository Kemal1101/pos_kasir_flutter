import 'package:flutter/material.dart';
import 'catalog_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SuperCashier',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF673AB7),
        elevation: 2,
      ),
      body: Row(
        children: [
          // Left side: Catalog (2/3 width)
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[100],
              child: const CatalogScreen(),
            ),
          ),
          // Divider
          Container(
            width: 1,
            color: Colors.grey[300],
          ),
          // Right side: Cart (1/3 width)
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: const CartScreen(),
            ),
          ),
        ],
      ),
    );
  }
}