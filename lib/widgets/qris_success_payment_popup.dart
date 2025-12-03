import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class QrisSuccessPaymentPopup extends StatelessWidget {
  final double amount;

  const QrisSuccessPaymentPopup({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/success.json',
              width: 130,
              repeat: false,
            ),
            const SizedBox(height: 10),

            const Text(
              'Payment Successful',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Amount: Rp ${amount.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
