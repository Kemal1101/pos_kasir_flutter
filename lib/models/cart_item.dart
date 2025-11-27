import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String sizeColor; // Contoh: "White | L" atau "Black | 45"

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.sizeColor,
  });

  // Getter untuk total harga item ini
  double get totalAmount => product.price * quantity;
}