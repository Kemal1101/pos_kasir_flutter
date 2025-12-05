import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/responsive_helper.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod = 0; // 0: Kartu Debit, 1: Tunai, 2: QRIS

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        if (cart.items.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Pembayaran'),
              backgroundColor: const Color(0xFF673AB7),
              toolbarHeight: isLandscape ? 40 : kToolbarHeight,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: isLandscape ? 48 : 80, color: Colors.grey[400]),
                  SizedBox(height: isLandscape ? 8 : 16),
                  Text(
                    'Keranjang Anda kosong',
                    style: TextStyle(
                      fontSize: isLandscape ? 14 : 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: isLandscape ? 12 : 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF673AB7),
                    ),
                    child: const Text('Lanjut Belanja', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Pembayaran'),
            backgroundColor: const Color(0xFF673AB7),
            elevation: 0,
            toolbarHeight: isLandscape ? 40 : kToolbarHeight,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Order Summary Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isLandscape ? 8 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Items
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(isLandscape ? 8 : 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daftar Pesanan',
                                  style: TextStyle(
                                    fontSize: isLandscape ? 12 : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: isLandscape ? 6 : 12),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cart.items.length,
                                  separatorBuilder: (_, __) => Divider(height: isLandscape ? 8 : 12),
                                  itemBuilder: (_, index) {
                                    final item = cart.items[index];
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.product.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: isLandscape ? 11 : 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '${item.quantity}x ${_formatCurrency(item.product.sellingPrice)}',
                                                style: TextStyle(fontSize: isLandscape ? 10 : 12, color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatCurrency(item.totalAmount),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isLandscape ? 11 : 14,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isLandscape ? 8 : 16),

                        // Summary
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(isLandscape ? 8 : 12),
                            child: Column(
                              children: [
                                // Subtotal tidak perlu ditampilkan lagi karena sama dengan Total
                                _buildSummaryRow(
                                  'Total',
                                  cart.total,
                                  isBold: true,
                                  fontSize: isLandscape ? 12 : 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isLandscape ? 8 : 16),

                        // Payment Methods
                        Text(
                          'Metode Pembayaran',
                          style: TextStyle(fontSize: isLandscape ? 12 : 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: isLandscape ? 6 : 12),
                        _buildPaymentMethodOption(0, 'Kartu Debit', Icons.credit_card, isLandscape),
                        _buildPaymentMethodOption(1, 'Tunai', Icons.money, isLandscape),
                        _buildPaymentMethodOption(2, 'QRIS', Icons.qr_code, isLandscape),
                      ],
                    ),
                  ),
                ),

                // Checkout Button
                Container(
                  padding: EdgeInsets.all(isLandscape ? 8 : 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF673AB7),
                        padding: EdgeInsets.symmetric(vertical: isLandscape ? 8 : 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Proses Pembayaran',
                        style: TextStyle(
                          fontSize: isLandscape ? 12 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false, double fontSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          _formatCurrency(amount),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption(int value, String label, IconData icon, bool isLandscape) {
    return Container(
      margin: EdgeInsets.only(bottom: isLandscape ? 4 : 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: _selectedPaymentMethod == value ? const Color(0xFF673AB7) : Colors.grey[300]!,
          width: isLandscape ? 1 : 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: _selectedPaymentMethod == value ? const Color(0xFF673AB7).withOpacity(0.05) : Colors.transparent,
      ),
      child: RadioListTile<int>(
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (int? newValue) {
          setState(() {
            _selectedPaymentMethod = newValue ?? 0;
          });
        },
        title: Row(
          children: [
            Icon(
              icon, 
              color: _selectedPaymentMethod == value ? const Color(0xFF673AB7) : Colors.grey,
              size: isLandscape ? 18 : 24,
            ),
            SizedBox(width: isLandscape ? 8 : 12),
            Text(
              label,
              style: TextStyle(fontSize: isLandscape ? 11 : 14),
            ),
          ],
        ),
        activeColor: const Color(0xFF673AB7),
        dense: isLandscape,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isLandscape ? 8 : 16,
          vertical: isLandscape ? 0 : 4,
        ),
        visualDensity: isLandscape ? VisualDensity.compact : VisualDensity.standard,
      ),
    );
  }

  void _processPayment() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    
    // Map payment method to payment_id: 0=card(2), 1=cash(1), 2=qris(5)
    final paymentId = _selectedPaymentMethod == 1 ? 1 : (_selectedPaymentMethod == 2 ? 5 : 2);
    final paymentName = ["Kartu Debit", "Tunai", "QRIS"][_selectedPaymentMethod];
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Complete sale via API
    final result = await cart.completeSale(
      paymentId: paymentId,
    );

    // Close loading
    if (mounted) Navigator.pop(context);

    if (result['success']) {
      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Pembayaran Berhasil'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total: ${_formatCurrency(cart.total)}'),
                const SizedBox(height: 8),
                Text('Metode: $paymentName'),
                const SizedBox(height: 12),
                const Text('Terima kasih telah berbelanja!'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, true); // Return to cart with success
                },
                child: const Text('Selesai'),
              ),
            ],
          ),
        );
      }
    } else {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Pembayaran gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
