import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductImageWidget extends StatelessWidget {
  final Product product;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImageWidget({
    Key? key,
    required this.product,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  IconData _getIconForProduct() {
    switch (product.iconType) {
      case IconType.shirt:
        return Icons.checkroom;
      case IconType.shoes:
        return Icons.sports_soccer;
      case IconType.scarf:
        return Icons.checkroom;
      case IconType.product:
        return Icons.shopping_bag;
    }
  }

  Color _getColorForProduct() {
    switch (product.category.toLowerCase()) {
      case 'hoodie':
        return Colors.purple.shade400;
      case 'sneaker':
        return Colors.grey.shade600;
      case 'scarf':
        return Colors.pink.shade300;
      case 'electronics':
        return Colors.blue.shade500;
      case 'fashion':
        return Colors.indigo.shade500;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      // Try to load image asset first
      return Image.asset(
        product.image,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildIconFallback();
        },
      );
    } catch (e) {
      return _buildIconFallback();
    }
  }

  Widget _buildIconFallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _getColorForProduct().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          _getIconForProduct(),
          size: (height ?? 100) * 0.5,
          color: _getColorForProduct(),
        ),
      ),
    );
  }
}
