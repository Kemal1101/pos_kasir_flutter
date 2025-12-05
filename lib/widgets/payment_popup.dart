// lib/screens/payment/payment_popup.dart
import 'package:flutter/material.dart';

class PaymentPopup {
  /// show returns selected method id: 'card', 'qris', 'cash'
  static Future<String?> show(BuildContext context, String initialMethod) async {
    String selected = initialMethod;

    final methods = [
      {
        'id': 'card',
        'name': 'Pay Using Card',
        'description': 'Complete payment using credit or debit card using POS machine'
      },
      {
        'id': 'qris',
        'name': 'Pay Using QRIS/E-Wallet',
        'description': 'Ask customer to complete payment by scanning QR code'
      },
      {
        'id': 'cash',
        'name': 'Pay on Cash',
        'description': 'Complete order payment using cash on hand from customer'
      },
    ];

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.35,
              maxChildSize: 0.95,
              expand: false,
              builder: (_, controller) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close, size: 28, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      ...methods.map((m) {
                        final id = m['id'] as String;
                        final name = m['name'] as String;
                        final desc = m['description'] as String;
                        final isSelected = selected == id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = id;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey.shade200, width: isSelected ? 2 : 1),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    id == 'cash' ? Icons.money : (id == 'qris' ? Icons.qr_code_2 : Icons.credit_card),
                                    size: 26,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle, color: Colors.deepPurple)
                                else
                                  const SizedBox(width: 24),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 18),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, selected),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFFFF6B9D), Color(0xFF5B4EC3)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'CONFIRM PAYMENT',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
