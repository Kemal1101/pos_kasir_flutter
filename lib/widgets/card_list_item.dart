import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartListItem extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;

  const CartListItem({super.key, required this.item, required this.onRemove});

  String _formatCurrency(double amount) => 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item.sizeColor, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('x${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Text(_formatCurrency(item.totalAmount), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.delete_outline, color: Colors.pink, size: 20),
          ),
        ],
      ),
    );
  }
}