// lib/screens/payment/payment_screen.dart
import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../widgets/payment_popup.dart';
import 'cash_payment_screen.dart';
import 'qris_payment_screen.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const PaymentScreen({super.key, required this.cartItems});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController couponController = TextEditingController();

  double get subtotal =>
      widget.cartItems.fold(0.0, (s, item) => s + item.totalPrice);

  double get tax => subtotal * 0.11;

  double get total => subtotal + tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Order Summary",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F56D9), Color(0xFFE94B9C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: widget.cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return _buildCartItem(item);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Discount Coupon",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: couponController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter coupon code here ex: 20OFF",
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _buildRow(
                  "Subtotal",
                  "Rp ${_formatNumber(subtotal)}",
                  bold: true,
                  color: const Color(0xFF5B4EC3),
                ),
                _buildRow(
                  "Tax (11%)",
                  "Rp ${_formatNumber(tax)}",
                  color: const Color(0xFFFF6B9D),
                ),
                const SizedBox(height: 8),
                _buildRow(
                  "Total",
                  "Rp ${_formatNumber(total)}",
                  bold: true,
                  color: const Color(0xFF5B4EC3),
                ),
              ],
            ),
          ),

          /// --- BUTTON FIXED ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  final selected = await PaymentPopup.show(context, 'qris');
                  if (selected == null) return;

                  bool? paid;

                  if (selected == 'qris') {
                    paid = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QrisPaymentScreen(total: total),
                      ),
                    );
                  } else if (selected == 'cash') {
                    paid = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CashPaymentScreen(total: total),
                      ),
                    );
                  }

                  /// FIX: hanya pop jika payment sukses
                  if (paid == true) {
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B9D), Color(0xFF5B4EC3)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'SELECT PAYMENT METHOD',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, size: 36, color: Colors.grey),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5B4EC3),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Rp ${_formatNumber(item.product.price)} x ${item.quantity}",
                ),
              ],
            ),
          ),

          Text(
            "Rp ${_formatNumber(item.totalPrice)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B4EC3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double number) {
    final s = number.toInt().toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '.');
  }
}
