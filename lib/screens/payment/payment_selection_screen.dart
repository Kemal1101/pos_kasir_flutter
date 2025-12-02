// lib/screens/payment/payment_selection_screen.dart
import 'package:flutter/material.dart';
import 'cash_payment_screen.dart';
import 'qris_payment_screen.dart';

class PaymentSelectionScreen extends StatelessWidget {
  final double total;
  const PaymentSelectionScreen({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Payment Method')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Total: Rp ${total.toInt()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CashPaymentScreen(total: total)),
                );
              },
              child: const Text('Bayar Cash'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QrisPaymentScreen(total: total)),
                );
              },
              child: const Text('Bayar QRIS'),
            ),
          ],
        ),
      ),
    );
  }
}
