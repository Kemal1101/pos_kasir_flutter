// cart_item.dart
import 'product_model.dart';
import 'package:intl/intl.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Total price, otomatis double
  double get totalPrice => product.price * quantity;

  /// Format harga ke "Rp 250.000"
  String get formattedPrice => _formatNumber(product.price);

  String get formattedTotalPrice => _formatNumber(totalPrice);

  /// Helper untuk format number
  String _formatNumber(double number) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(number);
  }
}
