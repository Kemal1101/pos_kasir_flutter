import 'package:flutter/material.dart';
import '../models/product.dart';

enum PaymentMethod { card, cash, qris }

class CartItem {
  final Product product;
  final int quantity;
  bool isSelected;

  CartItem({
    required this.product,
    required this.quantity,
    this.isSelected = false,
  });
}

class CartPage extends StatefulWidget {
  final List<Product> cart;
  final void Function(Product) onRemove;

  const CartPage({
    Key? key,
    required this.cart,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartItem> cartItems;
  PaymentMethod _selectedPayment = PaymentMethod.card;
  String _couponCode = '';
  double _discountPercentage = 0;
  bool _showCheckout = false;

  @override
  void initState() {
    super.initState();
    _initializeCartItems();
  }

  void _initializeCartItems() {
    final Map<String, CartItem> itemsMap = {};

    for (var product in widget.cart) {
      if (itemsMap.containsKey(product.id)) {
        itemsMap[product.id] = CartItem(
          product: product,
          quantity: itemsMap[product.id]!.quantity + 1,
        );
      } else {
        itemsMap[product.id] = CartItem(
          product: product,
          quantity: 1,
        );
      }
    }

    cartItems = itemsMap.values.toList();
  }

  double _parsePrice(String price) {
    return double.tryParse(price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
  }

  double _getSelectedTotal() {
    return cartItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (_parsePrice(item.product.price) * item.quantity));
  }

  int _getSelectedCount() {
    return cartItems.where((item) => item.isSelected).fold(0, (sum, item) => sum + item.quantity);
  }

  void _toggleSelectAll(bool value) {
    setState(() {
      for (var item in cartItems) {
        item.isSelected = value;
      }
    });
  }

  bool _isAllSelected() {
    return cartItems.isNotEmpty && cartItems.every((item) => item.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    if (_showCheckout && cartItems.any((item) => item.isSelected)) {
      return _buildCheckoutPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        elevation: 0,
      ),
      body: widget.cart.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Select All Header
                        Container(
                          color: Colors.grey[50],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _isAllSelected(),
                                onChanged: (value) => _toggleSelectAll(value ?? false),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Pilih Semua',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        // Cart Items
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            final product = item.product;
                            final itemTotal = _parsePrice(product.price) * item.quantity;

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: item.isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          item.isSelected = value ?? false;
                                        });
                                      },
                                    ),
                                    // Product Image
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: _buildProductImage(product),
                                    ),
                                    const SizedBox(width: 12),
                                    // Product Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.price,
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Quantity Control
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
                                                      ? () {
                                                          setState(() {
                                                            cartItems[index] = CartItem(
                                                              product: product,
                                                              quantity: item.quantity - 1,
                                                              isSelected: item.isSelected,
                                                            );
                                                          });
                                                        }
                                                      : null,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 16,
                                                      color: item.quantity > 1
                                                          ? Colors.grey[600]
                                                          : Colors.grey[300],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                                  child: Text(
                                                    '${item.quantity}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      cartItems[index] = CartItem(
                                                        product: product,
                                                        quantity: item.quantity + 1,
                                                        isSelected: item.isSelected,
                                                      );
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
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
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Delete Button & Total
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              cartItems.removeAt(index);
                                              for (int i = 0; i < item.quantity; i++) {
                                                widget.onRemove(product);
                                              }
                                            });
                                          },
                                          icon: const Icon(Icons.delete_outline),
                                          color: Colors.red,
                                          iconSize: 20,
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Rp ${itemTotal.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total (${_getSelectedCount()} item):',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${_getSelectedTotal().toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: cartItems.any((item) => item.isSelected)
                                ? () {
                                    setState(() => _showCheckout = true);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Checkout'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
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

  Widget _buildProductImage(Product product) {
    try {
      return Image.asset(product.image, fit: BoxFit.contain);
    } catch (e) {
      return Center(
        child: Icon(
          Icons.shopping_bag,
          size: 40,
          color: Colors.grey[400],
        ),
      );
    }
  }

  Widget _buildCheckoutPage() {
    final selectedItems = cartItems.where((item) => item.isSelected).toList();
    double subtotal = selectedItems.fold(
      0,
      (sum, item) => sum + (_parsePrice(item.product.price) * item.quantity),
    );
    double discount = subtotal * (_discountPercentage / 100);
    double afterDiscount = subtotal - discount;
    double tax = afterDiscount * 0.11;
    double total = afterDiscount + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _showCheckout = false),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Selected Items
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ...selectedItems.map((item) {
                    final itemTotal = _parsePrice(item.product.price) * item.quantity;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: _buildProductImage(item.product),
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
                                  const SizedBox(height: 4),
                                  Text(
                                    item.product.price,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'x${item.quantity}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${itemTotal.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const Divider(thickness: 1),
            // Discount Coupon Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discount Coupon',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter coupon code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) => setState(() => _couponCode = value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_couponCode.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Kupon "$_couponCode" diterapkan!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            setState(() => _discountPercentage = 15);
                          }
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),
            // Payment Method
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Payment Mode',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),
                  PaymentMethodCard(
                    title: 'Pay Using Card',
                    description: 'Complete the payment using credit or debit card',
                    isSelected: _selectedPayment == PaymentMethod.card,
                    onTap: () => setState(() => _selectedPayment = PaymentMethod.card),
                  ),
                  const SizedBox(height: 12),
                  PaymentMethodCard(
                    title: 'Pay on Cash',
                    description: 'Complete order payment using cash on hand',
                    isSelected: _selectedPayment == PaymentMethod.cash,
                    onTap: () => setState(() => _selectedPayment = PaymentMethod.cash),
                  ),
                  const SizedBox(height: 12),
                  PaymentMethodCard(
                    title: 'Pay Using QRIS/E-Wallet',
                    description: 'Complete the payment using QR code or e-wallet',
                    isSelected: _selectedPayment == PaymentMethod.qris,
                    onTap: () => setState(() => _selectedPayment = PaymentMethod.qris),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),
            // Total Summary
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        'Rp ${subtotal.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  if (_discountPercentage > 0) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Special Discount',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          '- Rp ${discount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax (11%)',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        '+ Rp ${tax.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 2),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rp ${total.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.pink.shade400,
                            Theme.of(context).colorScheme.primary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Payment Confirmation'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Payment Method: ${_selectedPayment.name.toUpperCase()}'),
                                  const SizedBox(height: 12),
                                  Text('Total Amount: Rp ${total.toStringAsFixed(0)}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pembayaran berhasil!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () {
                                        setState(() {
                                          _showCheckout = false;
                                          cartItems.removeWhere((item) => item.isSelected);
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'CONFIRM PAYMENT',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    Key? key,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
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