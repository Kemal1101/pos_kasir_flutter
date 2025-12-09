import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme.dart';

enum PaymentMethod { card, cash, qris }

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  PaymentMethod _selectedPayment = PaymentMethod.card;
  double _discountPercentage = 0;
  bool _showCheckout = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.cartItems.isEmpty) {
            return _buildEmptyCart();
          }

          if (_showCheckout) {
            return _buildCheckoutPage(cartProvider);
          }

          return _buildCartList(cartProvider);
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang kosong',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan produk untuk mulai berbelanja',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Lanjut Belanja'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(CartProvider cartProvider) {
    final selectedItems = cartProvider.cartItems.where((item) => item.isSelected).toList();
    double subtotal = selectedItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    double discount = subtotal * (_discountPercentage / 100);
    double total = subtotal - discount;

    return Row(
      children: [
        // Left side - Product list
        Expanded(
          flex: 2,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              final item = cartProvider.cartItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Checkbox(
                        value: item.isSelected,
                        onChanged: (_) => cartProvider.toggleSelect(index),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.shopping_bag, color: Colors.grey[400]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${item.product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: item.quantity > 1
                                      ? () => cartProvider.decreaseQty(index)
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.remove,
                                      size: 16,
                                      color: item.quantity > 1
                                          ? Colors.grey[600]
                                          : Colors.grey[300],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'x${item.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => cartProvider.increaseQty(index),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp ${item.totalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () async {
                          final item = cartProvider.cartItems[index];
                          if (item.saleItemId != null) {
                            // Remove via API
                            final success = await cartProvider.removeItemFromSale(item.saleItemId!);
                            if (!success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(cartProvider.errorMessage ?? 'Gagal menghapus item'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            // Fallback: remove locally
                            cartProvider.cartItems.removeAt(index);
                          }
                        },
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        iconSize: 18,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Right side - Summary
        SizedBox(
          width: 300,
          child: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedItems.length}/${cartProvider.cartItems.length}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.menu,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...selectedItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'x${item.quantity}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp ${item.totalPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Text(
                      'Rp ${subtotal.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '+ Add Discount',
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.pink,
                      ),
                    ),
                    Text(
                      'Rp ${total.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedItems.isNotEmpty
                        ? () => setState(() => _showCheckout = true)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'CHECKOUT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutPage(CartProvider cartProvider) {
    final selectedItems = cartProvider.cartItems.where((item) => item.isSelected).toList();
    double subtotal = selectedItems.fold(0, (sum, item) => sum + item.totalPrice);
    double discount = subtotal * (_discountPercentage / 100);
    double total = subtotal - discount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _showCheckout = false),
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              const Text(
                'Select Payment Mode',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Order Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          ...selectedItems.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.shopping_bag, color: Colors.grey[400]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'x${item.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Rp ${item.totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
          Text(
            'Select Payment Mode',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          _buildPaymentMethod(
            'Pay Using Card',
            'Complete the payment using credit or debit card',
            PaymentMethod.card,
          ),
          const SizedBox(height: 12),
          _buildPaymentMethod(
            'Pay on Cash',
            'Complete order payment using cash on hand',
            PaymentMethod.cash,
          ),
          const SizedBox(height: 12),
          _buildPaymentMethod(
            'Pay Using QRIS/E-Wallet',
            'Complete the payment using QR code or e-wallet',
            PaymentMethod.qris,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: TextStyle(color: Colors.grey[600])),
                    Text('Rp ${subtotal.toStringAsFixed(0)}'),
                  ],
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      'Rp ${total.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade400, AppTheme.primary],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pembayaran berhasil!')),
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    cartProvider.removeSelected();
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'CONFIRM PAYMENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(
    String title,
    String description,
    PaymentMethod method,
  ) {
    return InkWell(
      onTap: () => setState(() => _selectedPayment = method),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedPayment == method ? AppTheme.primary : Colors.grey[300]!,
            width: _selectedPayment == method ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _selectedPayment == method
              ? AppTheme.primary.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Radio<PaymentMethod>(
              value: method,
              groupValue: _selectedPayment,
              onChanged: (value) => setState(() => _selectedPayment = value!),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
}
