import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailDialog extends StatefulWidget {
  final Product product;

  const ProductDetailDialog({super.key, required this.product});

  @override
  State<ProductDetailDialog> createState() => _ProductDetailDialogState();
}

class _ProductDetailDialogState extends State<ProductDetailDialog> {
  int _quantity = 1;
  bool _isAdding = false;

  void _increaseQuantity() {
    if (_quantity < widget.product.stock) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<void> _addToCart() async {
    setState(() {
      _isAdding = true;
    });

    final cartProvider = context.read<CartProvider>();
    final success = await cartProvider.addProductToCart(
      widget.product,
      'Default',
      quantity: _quantity,
    );

    setState(() {
      _isAdding = false;
    });

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_quantity}x ${widget.product.name} ditambahkan ke keranjang.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cartProvider.errorMessage ?? 'Gagal menambahkan ke keranjang'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatCurrency(double amount) => 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = screenWidth > screenHeight;
    final isSmallScreen = screenHeight < 500;
    
    // Ukuran dinamis berdasarkan orientasi
    final imageSize = isLandscape ? 100.0 : (isSmallScreen ? 120.0 : 200.0);
    final titleFontSize = isLandscape ? 16.0 : 22.0;
    final priceFontSize = isLandscape ? 14.0 : 20.0;
    final quantityFontSize = isLandscape ? 18.0 : 24.0;
    final iconSize = isLandscape ? 24.0 : 32.0;
    final padding = isLandscape ? 12.0 : 24.0;
    final spacing = isLandscape ? 8.0 : 24.0;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 100 : 40,
        vertical: isLandscape ? 12 : 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isLandscape ? 500 : 400,
          maxHeight: screenHeight * 0.9,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: isLandscape 
              ? _buildLandscapeLayout(imageSize, titleFontSize, priceFontSize, quantityFontSize, iconSize, spacing)
              : _buildPortraitLayout(imageSize, titleFontSize, priceFontSize, quantityFontSize, iconSize, spacing),
        ),
      ),
    );
  }

  /// Layout untuk landscape - horizontal
  Widget _buildLandscapeLayout(double imageSize, double titleFontSize, double priceFontSize, double quantityFontSize, double iconSize, double spacing) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gambar Produk
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildProductImage(imageSize),
        ),
        const SizedBox(width: 16),
        
        // Info dan kontrol
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Produk
              Text(
                widget.product.name,
                style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Harga dan Stok
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatCurrency(widget.product.price),
                    style: TextStyle(fontSize: priceFontSize, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  Text(
                    'Stok: ${widget.product.stock}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Kontrol Kuantitas
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _decreaseQuantity,
                    icon: const Icon(Icons.remove_circle_outline),
                    iconSize: iconSize,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: _quantity > 1 ? Colors.black87 : Colors.grey,
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      '$_quantity',
                      style: TextStyle(fontSize: quantityFontSize, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: _increaseQuantity,
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: iconSize,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: _quantity < widget.product.stock ? Colors.deepPurple : Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tombol Tambah ke Keranjang
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isAdding ? null : _addToCart,
                  icon: _isAdding
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.add_shopping_cart, size: 18),
                  label: Text(_isAdding ? 'Menambahkan...' : 'Tambah ke Keranjang'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Layout untuk portrait - vertical
  Widget _buildPortraitLayout(double imageSize, double titleFontSize, double priceFontSize, double quantityFontSize, double iconSize, double spacing) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gambar Produk
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildProductImage(imageSize),
          ),
        ),
        SizedBox(height: spacing),

        // Nama Produk
        Text(
          widget.product.name,
          style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Harga dan Stok
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatCurrency(widget.product.price),
              style: TextStyle(fontSize: priceFontSize, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            Text(
              'Stok: ${widget.product.stock}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const Divider(height: 32),

        // Kontrol Kuantitas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _decreaseQuantity,
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: iconSize,
              color: _quantity > 1 ? Colors.black87 : Colors.grey,
            ),
            Container(
              width: 80,
              alignment: Alignment.center,
              child: Text(
                '$_quantity',
                style: TextStyle(fontSize: quantityFontSize, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: _increaseQuantity,
              icon: const Icon(Icons.add_circle_outline),
              iconSize: iconSize,
              color: _quantity < widget.product.stock ? Colors.deepPurple : Colors.grey,
            ),
          ],
        ),
        SizedBox(height: spacing),

        // Tombol Tambah ke Keranjang
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isAdding ? null : _addToCart,
            icon: _isAdding
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.add_shopping_cart),
            label: Text(_isAdding ? 'Menambahkan...' : 'Tambah ke Keranjang'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  /// Build product image widget
  Widget _buildProductImage(double size) {
    if (widget.product.productImages != null && widget.product.productImages!.isNotEmpty) {
      return Image.network(
        widget.product.productImages!,
        height: size,
        width: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: size,
            width: size,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: size,
            width: size,
            color: Colors.grey[200],
            child: Icon(
              Icons.image_not_supported,
              size: size * 0.4,
              color: Colors.grey[400],
            ),
          );
        },
      );
    } else {
      return Container(
        height: size,
        width: size,
        color: Colors.grey[200],
        child: Icon(
          Icons.image,
          size: size * 0.4,
          color: Colors.grey[400],
        ),
      );
    }
  }
}