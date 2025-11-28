import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  // Getter untuk total harga item ini
  double get totalAmount => product.sellingPrice * quantity;
}