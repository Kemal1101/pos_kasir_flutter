import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod = 0; // 0: Card, 1: Cash, 2: QRIS

  String _formatCurrency(double amount) {
    // Gunakan NumberFormat untuk format yang lebih baik (perlu intl package)
    // final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    // return formatter.format(amount);
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Order Details Section
            _buildOrderDetailsPanel(cartProvider),
            
            const Divider(height: 1, thickness: 1),
            
            // Payment Panel Section
            _buildPaymentPanel(cartProvider),
          ],
        ),
      ),
    );
  }
  // --- Widget Builders: Order Details (Kiri) ---

  Widget _buildOrderDetailsPanel(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Customer Info Card
          _buildCustomerInfoCard(),
          const SizedBox(height: 24),
          const Text('Order Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildOrderDetailsHeader(),
          const Divider(),
          // Item List menggunakan data dari CartProvider
          ...cart.items.map((item) => _buildOrderItemRow(item)).toList(),
          const SizedBox(height: 24),
          // Discount Coupon Section
          _buildDiscountCouponSection(),
        ],
      ),
    );
  }
  
  // Widget _buildCustomerInfoCard, _buildOrderDetailsHeader, _buildOrderItemRow, _buildDiscountCouponSection
  // di sini akan diisi dengan kode dari respons "ORDER SUMMARY.jpg", disederhanakan agar fokus ke alur.

  Widget _buildOrderItemRow(item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: item.product.productImages != null && item.product.productImages!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.product.productImages!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image, color: Colors.grey[400]);
                      },
                    ),
                  )
                : Icon(Icons.image, color: Colors.grey[400]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'x${item.quantity}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(item.totalAmount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () async {
                  final cartProvider = context.read<CartProvider>();
                  if (item.saleItemId != null) {
                    await cartProvider.removeItemFromSale(item.saleItemId!);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.product.name} dihapus dari keranjang'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red[400],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ... (Sisa implementasi widget panel kiri) ...

  Widget _buildCustomerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Color(0xFF673AB7), child: Text('AK', style: TextStyle(color: Colors.white))),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Anup Kumar', style: TextStyle(fontWeight: FontWeight.bold)), Row(children: [Text('7088706543', style: TextStyle(color: Colors.grey[600], fontSize: 12)), const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('•', style: TextStyle(color: Colors.grey, fontSize: 12))), const Text('15% Discount Offer', style: TextStyle(color: Colors.red, fontSize: 12))]),]),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(20)), child: const Text('Regular', style: TextStyle(color: Colors.green, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 62), // Image width + spacing
          const Expanded(
            child: Text(
              'ITEM',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'AMOUNT',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountCouponSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Discount Coupon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: TextField(decoration: InputDecoration(hintText: 'Enter coupon code here ex: 2OOFFD5', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),),), const SizedBox(width: 8), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[100], foregroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), elevation: 0), child: const Text('Apply'),),],),
        ],
      ),
    );
  }

  // --- Widget Builders: Payment Panel (Kanan) ---

  Widget _buildPaymentPanel(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Select Payment Mode', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildPaymentOption(value: 0, title: 'Pay Using Card', subtitle: 'Complete the payment using credit or debit card'),
          const SizedBox(height: 12),
          _buildPaymentOption(value: 1, title: 'Pay on Cash', subtitle: 'Complete order payment using cash on hand'),
          const SizedBox(height: 12),
          _buildPaymentOption(value: 2, title: 'Pay Using QRIS/E-Wallet', subtitle: 'Ask customer to scan QR code'),
          const SizedBox(height: 24),
          _buildPaymentSummary(cart),
          const SizedBox(height: 24),
          _buildConfirmPaymentButton(cart),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({required int value, required String title, required String subtitle}) {
    final bool isSelected = _selectedPaymentMethod == value;
    return InkWell(
      onTap: () {setState(() {_selectedPaymentMethod = value;});},
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<int>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (int? newValue) {
                setState(() {_selectedPaymentMethod = newValue!;});
              },
              activeColor: Colors.deepPurple,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary(CartProvider cart) {
    Widget _buildSummaryRow(String label, String value, {Color? valueColor, bool isTotal = false}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: isTotal ? 12.0 : 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14, color: isTotal ? Colors.black : Colors.grey[700])),
            Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, fontSize: isTotal ? 18 : 14, color: valueColor ?? (isTotal ? Colors.deepPurple : Colors.black))),
          ],
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryRow('Subtotal', _formatCurrency(cart.subtotal)),
        _buildSummaryRow('Special Discount', _formatCurrency(0), valueColor: Colors.red),
        _buildSummaryRow('Tax (${(cart.taxRate * 100).toStringAsFixed(0)}%)', '+ ${_formatCurrency(cart.taxAmount)}', valueColor: Colors.red),
        const Divider(thickness: 1.5, height: 20),
        _buildSummaryRow('Total', _formatCurrency(cart.total), isTotal: true),
      ],
    );
  }

  Widget _buildConfirmPaymentButton(CartProvider cart) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(colors: [Colors.pink[400]!, Colors.deepPurple[400]!], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: cart.total > 0 ? () {
            // Logika konfirmasi pembayaran
            print('Payment confirmed via option $_selectedPaymentMethod for ${_formatCurrency(cart.total)}');
            // Kosongkan keranjang setelah pembayaran berhasil
            context.read<CartProvider>().clearCart();
            // Kembali ke halaman sebelumnya (CatalogScreen)
            Navigator.of(context).pop(); 
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pembayaran berhasil!'), duration: Duration(seconds: 2),));
          } : null,
          borderRadius: BorderRadius.circular(10),
          child: const Center(child: Text('CONFIRM PAYMENT', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}