import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String sizeColor; // Contoh: "White | L" atau "Black | 45"
  bool isSelected;
  int? saleItemId; // ID dari backend sale_items table (untuk delete)

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.sizeColor,
    this.isSelected = true,
    this.saleItemId,
  });

  // Getter untuk total harga item ini
  double get totalAmount => product.price * quantity;
  
  // Alias for compatibility with cart_page.dart
  double get totalPrice => totalAmount;
}