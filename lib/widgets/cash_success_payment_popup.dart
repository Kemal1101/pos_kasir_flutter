import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CashSuccessPaymentPopup {
  static Future<void> show(
    BuildContext context, {
    required double total,
    required double cashReceived,
    required double change,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lottie/check_success.json',
                    width: 140, height: 140),

                const SizedBox(height: 12),
                const Text(
                  'Pembayaran Sukses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Detail transaksi
                Text("Total: Rp$total"),
                Text("Diterima: Rp$cashReceived"),
                Text("Kembalian: Rp$change"),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
