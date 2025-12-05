import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/responsive_helper.dart';
import 'payment/payment_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String _formatCurrency(double amount) {
    final formatter = amount.toStringAsFixed(0);
    return formatter.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final padding = ResponsiveHelper.getScreenPadding(context);
    
    return Consumer<CartProvider>(
      builder: (ctx, cart, child) {
        if (cart.items.isEmpty) {
          return _buildEmptyCart(context, isMobile);
        }

        return Column(
          children: [
            // Header untuk mobile
            if (isMobile)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Row(
                  children: [
                    const Icon(Icons.shopping_cart, color: Color(0xFF673AB7)),
                    const SizedBox(width: 8),
                    Text(
                      'Keranjang (${cart.itemCount} item)',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            
            Expanded(
              child: ListView.builder(
                padding: padding,
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return _buildCartItem(context, cart, item, index, isMobile);
                },
              ),
            ),
            
            // Checkout button at bottom
            _buildCheckoutButton(context, cart, isMobile),
          ],
        );
      },
    );
  }

  /// Build empty cart state
  Widget _buildEmptyCart(BuildContext context, bool isMobile) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final iconSize = isLandscape ? 40.0 : (isMobile ? 60.0 : 80.0);
    final titleSize = isLandscape ? 14.0 : (isMobile ? 16.0 : 18.0);
    final subtitleSize = isLandscape ? 10.0 : (isMobile ? 12.0 : 13.0);
    final spacing = isLandscape ? 8.0 : (isMobile ? 12.0 : 16.0);
    final buttonSpacing = isLandscape ? 16.0 : (isMobile ? 30.0 : 40.0);
    final padding = isLandscape ? 12.0 : (isMobile ? 16.0 : 24.0);
    
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(padding),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: iconSize,
                color: Colors.grey[400],
              ),
              SizedBox(height: spacing),
              Text(
                'Keranjang Kosong',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: isLandscape ? 2 : 4),
              Text(
                'Tambahkan produk untuk memulai',
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: buttonSpacing),
              Container(
                margin: EdgeInsets.symmetric(horizontal: isLandscape ? 8 : (isMobile ? 16 : 24)),
                padding: EdgeInsets.symmetric(
                  horizontal: isLandscape ? 10 : (isMobile ? 12 : 16),
                  vertical: isLandscape ? 8 : (isMobile ? 10 : 12),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0 Item',
                      style: TextStyle(
                        fontSize: isLandscape ? 12 : (isMobile ? 16 : 18),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Rp 0',
                          style: TextStyle(
                            fontSize: isLandscape ? 11 : (isMobile ? 14 : 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: isLandscape ? 6 : (isMobile ? 8 : 12)),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: isLandscape ? 14 : (isMobile ? 18 : 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build single cart item
  Widget _buildCartItem(BuildContext context, CartProvider cart, dynamic item, int index, bool isMobile) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final padding = isLandscape ? 8.0 : (isMobile ? 10.0 : 12.0);
    final verticalPadding = isLandscape ? 4.0 : (isMobile ? 6.0 : 8.0);
    final horizontalPadding = isLandscape ? 8.0 : (isMobile ? 8.0 : 16.0);
    final nameFontSize = isLandscape ? 11.0 : (isMobile ? 12.0 : 13.0);
    final priceFontSize = isLandscape ? 10.0 : (isMobile ? 11.0 : 12.0);
    final totalFontSize = isLandscape ? 11.0 : (isMobile ? 12.0 : 13.0);
    final indexWidth = isLandscape ? 20.0 : (isMobile ? 24.0 : 30.0);
    final indexFontSize = isLandscape ? 10.0 : (isMobile ? 12.0 : 14.0);
    
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              // No urut
              SizedBox(
                width: indexWidth,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: indexFontSize,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              // Product name, price, dan quantity control
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: nameFontSize,
                      ),
                      maxLines: isLandscape ? 1 : (isMobile ? 2 : 1),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isLandscape ? 2 : 4),
                    Text(
                      'Rp ${_formatCurrency(item.product.sellingPrice)}',
                      style: TextStyle(
                        fontSize: priceFontSize,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: isLandscape ? 4 : 6),
                    // Quantity control
                    _buildQuantityControl(context, cart, item, index, isMobile, isLandscape),
                  ],
                ),
              ),
              // Total price and delete button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rp ${_formatCurrency(item.totalAmount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: totalFontSize,
                      color: const Color(0xFF673AB7),
                    ),
                  ),
                  SizedBox(height: isLandscape ? 4 : 8),
                  _buildDeleteButton(context, cart, item, index, isLandscape),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build quantity control widget
  Widget _buildQuantityControl(BuildContext context, CartProvider cart, dynamic item, int index, bool isMobile, bool isLandscape) {
    final iconSize = isLandscape ? 12.0 : (isMobile ? 14.0 : 16.0);
    final fieldWidth = isLandscape ? 30.0 : (isMobile ? 35.0 : 40.0);
    final fieldHeight = isLandscape ? 22.0 : (isMobile ? 26.0 : 30.0);
    final fontSize = isLandscape ? 10.0 : (isMobile ? 11.0 : 12.0);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: item.quantity > 1
              ? () => cart.decreaseQuantity(index)
              : () => cart.removeItem(index),
          color: Colors.red,
          iconSize: iconSize,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        SizedBox(
          width: fieldWidth,
          height: fieldHeight,
          child: TextFormField(
            key: ValueKey(item.quantity),
            initialValue: item.quantity.toString(),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (value) {
              final newQuantity = int.tryParse(value);
              if (newQuantity != null && newQuantity > 0) {
                cart.updateQuantity(index, newQuantity);
              } else if (newQuantity != null && newQuantity <= 0) {
                cart.removeItem(index);
              }
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => cart.increaseQuantity(index),
          color: Colors.green,
          iconSize: iconSize,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  /// Build delete button
  Widget _buildDeleteButton(BuildContext context, CartProvider cart, dynamic item, int index, bool isLandscape) {
    final iconSize = isLandscape ? 14.0 : 18.0;
    final buttonPadding = isLandscape ? 3.0 : 4.0;
    
    return InkWell(
      onTap: () async {
        if (item.saleItemId != null) {
          final success = await cart.deleteItem(index);
          if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(cart.errorMessage ?? 'Gagal menghapus item'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          cart.removeItem(index);
        }
      },
      child: Container(
        padding: EdgeInsets.all(buttonPadding),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.delete_outline,
          size: iconSize,
          color: Colors.red[400],
        ),
      ),
    );
  }

  /// Build checkout button
  Widget _buildCheckoutButton(BuildContext context, CartProvider cart, bool isMobile) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final containerPadding = isLandscape ? 8.0 : (isMobile ? 12.0 : 16.0);
    final horizontalPadding = isLandscape ? 10.0 : (isMobile ? 12.0 : 16.0);
    final verticalPadding = isLandscape ? 8.0 : (isMobile ? 12.0 : 14.0);
    final itemFontSize = isLandscape ? 12.0 : (isMobile ? 16.0 : 18.0);
    final priceFontSize = isLandscape ? 11.0 : (isMobile ? 14.0 : 16.0);
    final iconSize = isLandscape ? 14.0 : (isMobile ? 18.0 : 20.0);
    final spacing = isLandscape ? 6.0 : (isMobile ? 8.0 : 12.0);
    
    return Container(
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: cart.items.isEmpty
              ? null
              : () async {
                  final paymentSuccess = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => PaymentScreen(
                        cartItems: cart.items,
                      ),
                    ),
                  );

                  if (paymentSuccess == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Pembayaran berhasil! Terima kasih.'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cart.itemCount} Item',
                  style: TextStyle(
                    fontSize: itemFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Rp ${_formatCurrency(cart.total)}',
                      style: TextStyle(
                        fontSize: priceFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
