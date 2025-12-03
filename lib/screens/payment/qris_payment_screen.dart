// lib/screens/payment/qris_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_kasir_flutter/widgets/qris_success_payment_popup.dart';


class QrisPaymentScreen extends StatelessWidget {
  final double total;

  const QrisPaymentScreen({super.key, required this.total});

  String _formatCurrency(double value) {
    return value
        .toInt()
        .toString()
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, "paid"),        ),
        centerTitle: true,
        title: const Text(
          "QRIS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8A56F0),
                Color(0xFFE558A0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // QRIS CONTAINER
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE558A0),
                    Color(0xFF8A56F0),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "QRIS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "PT Dewi Sukses Kaya Raya",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 3),
                  const Text(
                    "NMID: ID102109328762GA01",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // QR CODE
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Image.asset(
                      "assets/images/qr_sample.png",
                      width: 220,
                      height: 220,
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TOTAL
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Rp ${_formatCurrency(total)}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7B2CBF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // DOWNLOAD DISABLED
            Container(
              height: 55,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  "DOWNLOAD (DISABLED)",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // CONFIRM BUTTON
            GestureDetector(
              onTap: () => _showSuccessPopup(context),
              child: Container(
                height: 58,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6A4CF1),
                      Color(0xFF5936CC),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "CONFIRM",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// POPUP SUCCESS (REPLACED: uses Dialog to avoid layout errors)
  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LottieBuilder.asset(
                  'assets/lottie/check_success.json',
                  width: 120,
                  repeat: false,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Payment Success!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3AFF),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A3AFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // tutup dialog
                    Navigator.pop(context); // kembali ke payment screen
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
