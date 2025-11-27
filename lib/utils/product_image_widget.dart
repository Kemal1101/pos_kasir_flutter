import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductImageWidget extends StatelessWidget {
  final Product product;

  const ProductImageWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          _getIconForProduct(),
          size: 80,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  IconData _getIconForProduct() {
    // Use category to determine icon
    switch (product.category.toLowerCase()) {
      case 'hoodie':
        return Icons.checkroom;
      case 'sneaker':
        return Icons.directions_run;
      case 'scarf':
        return Icons.checkroom;
      default:
        return Icons.shopping_bag;
    }
  }
}
