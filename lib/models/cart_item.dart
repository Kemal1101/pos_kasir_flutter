import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String sizeColor;
  bool isSelected;
  final int? saleItemId;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.sizeColor = 'Default',
    this.isSelected = true,
    this.saleItemId,
  });

  // Getter untuk total harga item ini
  double get totalAmount => product.sellingPrice * quantity;
  double get totalPrice => totalAmount; // Alias for compatibility
}