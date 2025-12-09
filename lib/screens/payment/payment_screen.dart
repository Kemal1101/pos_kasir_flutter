// lib/screens/payment/payment_screen.dart
import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../utils/responsive_helper.dart';
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
  double get total => subtotal;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final screenWidth = ResponsiveHelper.screenWidth(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Order Summary",
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
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
      body: isLandscape && !isMobile
          ? _buildLandscapeLayout(context, screenWidth)
          : _buildPortraitLayout(context, isMobile),
    );
  }

  /// Layout untuk landscape (tablet/desktop)
  Widget _buildLandscapeLayout(BuildContext context, double screenWidth) {
    return Row(
      children: [
        // Left: Cart items
        Expanded(
          flex: 2,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: widget.cartItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = widget.cartItems[index];
              return _buildCartItem(item, false);
            },
          ),
        ),
        // Divider
        Container(
          width: 1,
          color: Colors.grey[300],
        ),
        // Right: Summary & Payment
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildSummarySection(context, false),
                  ),
                ),
                _buildPaymentButton(context, false),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Layout untuk portrait (mobile)
  Widget _buildPortraitLayout(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            itemCount: widget.cartItems.length,
            separatorBuilder: (_, __) => SizedBox(height: isMobile ? 8 : 12),
            itemBuilder: (context, index) {
              final item = widget.cartItems[index];
              return _buildCartItem(item, isMobile);
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 8 : 12,
                ),
                child: _buildSummarySection(context, isMobile),
              ),
              _buildPaymentButton(context, isMobile),
            ],
          ),
        ),
      ],
    );
  }

  /// Build summary section (coupon + totals)
  Widget _buildSummarySection(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Discount Coupon",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: couponController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter coupon code here ex: 20OFF",
              hintStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 13),
              ),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _buildRow(
          context,
          "Subtotal",
          "Rp ${_formatNumber(subtotal)}",
          bold: true,
          color: const Color(0xFF5B4EC3),
          isMobile: isMobile,
        ),
        const SizedBox(height: 8),
        _buildRow(
          context,
          "Total",
          "Rp ${_formatNumber(total)}",
          bold: true,
          color: const Color(0xFF5B4EC3),
          isMobile: isMobile,
        ),
      ],
    );
  }

  /// Build payment button
  Widget _buildPaymentButton(BuildContext context, bool isMobile) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: SizedBox(
          width: double.infinity,
          height: isMobile ? 50 : 56,
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
                child: Text(
                  'SELECT PAYMENT METHOD',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item, bool isMobile) {
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
      padding: EdgeInsets.all(isMobile ? 10 : 14),
      child: Row(
        children: [
          Container(
            width: isMobile ? 50 : 64,
            height: isMobile ? 50 : 64,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.image,
              size: isMobile ? 28 : 36,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: isMobile ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5B4EC3),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  "Rp ${_formatNumber(item.product.price)} x ${item.quantity}",
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "Rp ${_formatNumber(item.totalPrice)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5B4EC3),
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool bold = false,
    Color? color,
    bool isMobile = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 3 : 4,
        horizontal: isMobile ? 2 : 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
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
