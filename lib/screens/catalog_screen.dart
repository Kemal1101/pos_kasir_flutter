import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/responsive_helper.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All'; // Track selected category
  final TextEditingController _searchController = TextEditingController();

  String _formatCurrency(double amount) {
    final formatter = amount.toStringAsFixed(0);
    return formatter.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    
    // Fetch products from API when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = context.read<CartProvider>();
      cartProvider.fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    
    // Padding lebih kecil untuk landscape
    final horizontalPadding = isLandscape ? 6.0 : 12.0;
    final verticalPadding = isLandscape ? 2.0 : 12.0;
    
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            children: [
              // Search Bar - lebih compact di landscape
              Padding(
                padding: EdgeInsets.only(bottom: isLandscape ? 4.0 : 12.0),
                child: SizedBox(
                  height: isLandscape ? 32 : null,
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      fontSize: isLandscape ? 11 : 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari Produk...',
                      prefixIcon: Icon(Icons.search, size: isLandscape ? 16 : 24),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: const Color(0xFFF5F5F5),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: isLandscape ? 4 : 12,
                      ),
                      isDense: isLandscape,
                    ),
                  ),
                ),
              ),

              // Category Filter - lebih compact di landscape
              SizedBox(
                height: isLandscape ? 24 : 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Product.categories.length,
                  itemBuilder: (ctx, index) {
                    final category = Product.categories[index];
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: EdgeInsets.only(right: isLandscape ? 4.0 : 6.0),
                      child: FilterChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: isLandscape ? 10 : 12,
                          ),
                        ),
                        selected: isSelected,
                        backgroundColor: Colors.grey[200],
                        selectedColor: const Color(0xFF673AB7),
                        padding: EdgeInsets.symmetric(
                          horizontal: isLandscape ? 6 : 8,
                          vertical: isLandscape ? 0 : 4,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: isLandscape ? VisualDensity.compact : VisualDensity.standard,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: isLandscape ? 4 : 12),

            // Product List/Grid
            Expanded(
              child: Consumer<CartProvider>(
                builder: (ctx, cart, child) {
                  // Show loading indicator
                  if (cart.isLoadingProducts) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Show error message
                  if (cart.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, size: isLandscape ? 32 : 48, color: Colors.red[300]),
                          SizedBox(height: isLandscape ? 8 : 12),
                          Text(
                            cart.errorMessage!,
                            style: TextStyle(fontSize: isLandscape ? 12 : 14),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isLandscape ? 8 : 12),
                          ElevatedButton.icon(
                            onPressed: () => cart.fetchProducts(),
                            icon: Icon(Icons.refresh, size: isLandscape ? 16 : 20),
                            label: Text('Coba Lagi', style: TextStyle(fontSize: isLandscape ? 12 : 14)),
                          ),
                        ],
                      ),
                    );
                  }

                  final List<Product> filteredProducts = cart.catalog.where((p) {
                    final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
                    final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
                    return matchesSearch && matchesCategory;
                  }).toList();

                  // Gunakan List untuk semua mode (landscape maupun portrait)
                  return _buildProductList(context, cart, filteredProducts);
                },
              ),
            ),
          ],
        ),
      ),
      )
    );
  }

  /// Build product list untuk semua mode
  Widget _buildProductList(BuildContext context, CartProvider cart, List<Product> products) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final cartItemIndex = cart.items.indexWhere((item) => item.product.id == product.id);
        final quantity = cartItemIndex >= 0 ? cart.items[cartItemIndex].quantity : 0;
        
        return _buildProductListItem(context, cart, product, quantity, isLandscape);
      },
    );
  }

  /// Build single product list item
  Widget _buildProductListItem(BuildContext context, CartProvider cart, Product product, int quantity, bool isLandscape) {
    return GestureDetector(
      onTap: () => _showProductDetailDialog(context, cart, product),
      child: Container(
        margin: EdgeInsets.only(bottom: isLandscape ? 6 : 8),
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? 12 : 12,
          vertical: isLandscape ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image/Icon
            Container(
              width: isLandscape ? 45 : 60,
              height: isLandscape ? 45 : 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  product.name.substring(0, 2).toUpperCase(),
                  style: TextStyle(
                    fontSize: isLandscape ? 16 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            SizedBox(width: isLandscape ? 10 : 12),
            
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isLandscape ? 12 : 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isLandscape ? 2 : 4),
                  Row(
                    children: [
                      Text(
                        'Stok: ${product.stock}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isLandscape ? 10 : 11,
                        ),
                      ),
                      SizedBox(width: isLandscape ? 8 : 12),
                      Text(
                        'Rp ${_formatCurrency(product.sellingPrice)}',
                        style: TextStyle(
                          color: const Color(0xFF673AB7),
                          fontWeight: FontWeight.bold,
                          fontSize: isLandscape ? 11 : 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Quantity badge atau Add button
            if (quantity > 0)
              Container(
                width: isLandscape ? 28 : 32,
                height: isLandscape ? 28 : 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$quantity',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isLandscape ? 11 : 13,
                    ),
                  ),
                ),
              )
            else
              Icon(
                Icons.add_circle_outline,
                color: const Color(0xFF673AB7),
                size: isLandscape ? 24 : 28,
              ),
          ],
        ),
      ),
    );
  }

  void _showProductDetailDialog(
    BuildContext context,
    CartProvider cart,
    Product product,
  ) {
    final TextEditingController quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (ctx) {
        final screenHeight = MediaQuery.of(ctx).size.height;
        final screenWidth = MediaQuery.of(ctx).size.width;
        final isLandscape = screenWidth > screenHeight;
        final keyboardHeight = MediaQuery.of(ctx).viewInsets.bottom;
        final isKeyboardOpen = keyboardHeight > 0;
        
        // Ukuran lebih compact untuk landscape
        final imageSize = isLandscape ? 80.0 : 120.0;
        final titleFontSize = isLandscape ? 14.0 : 16.0;
        final contentFontSize = isLandscape ? 12.0 : 14.0;
        final smallFontSize = isLandscape ? 10.0 : 12.0;
        final iconSize = isLandscape ? 18.0 : 24.0;
        final buttonPaddingH = isLandscape ? 10.0 : 16.0;
        final buttonPaddingV = isLandscape ? 6.0 : 12.0;
        final spacing = isLandscape ? 8.0 : 16.0;
        
        return StatefulBuilder(
          builder: (context, setState) => Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: isLandscape ? 80 : 24,
              vertical: isLandscape ? 8 : 24,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isLandscape ? 400 : 500,
                maxHeight: screenHeight * (isKeyboardOpen ? 0.9 : 0.85),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isLandscape ? 12 : 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: spacing),
                    
                    // Content - horizontal untuk landscape
                    if (isLandscape)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Container(
                            width: imageSize,
                            height: imageSize,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                product.name.substring(0, 2).toUpperCase(),
                                style: TextStyle(
                                  fontSize: imageSize * 0.3,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Harga: Rp ${_formatCurrency(product.sellingPrice)}',
                                  style: TextStyle(
                                    fontSize: contentFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: spacing / 2),
                                Text(
                                  'Stok: ${product.stock}',
                                  style: TextStyle(
                                    fontSize: smallFontSize,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: spacing),
                                // Quantity control
                                _buildQuantityControl(
                                  quantityController, 
                                  setState, 
                                  iconSize,
                                  contentFontSize,
                                  isLandscape,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      // Portrait layout - vertical
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Image centered
                          Center(
                            child: Container(
                              width: imageSize,
                              height: imageSize,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  product.name.substring(0, 2).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: imageSize * 0.3,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: spacing),
                          Text(
                            'Harga: Rp ${_formatCurrency(product.sellingPrice)}',
                            style: TextStyle(
                              fontSize: contentFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          Text(
                            'Stok: ${product.stock}',
                            style: TextStyle(
                              fontSize: smallFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: spacing),
                          // Quantity control
                          _buildQuantityControl(
                            quantityController, 
                            setState, 
                            iconSize,
                            contentFontSize,
                            isLandscape,
                          ),
                        ],
                      ),
                    
                    SizedBox(height: spacing),
                    
                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Batal',
                            style: TextStyle(fontSize: smallFontSize),
                          ),
                        ),
                        SizedBox(width: spacing / 2),
                        ElevatedButton(
                          onPressed: () {
                            int quantity = int.tryParse(quantityController.text) ?? 0;
                            if (quantity <= 0) quantity = 1;

                            cart.addProductToCart(product, 'Default', quantity: quantity);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '$quantity x ${product.name} ditambahkan ke keranjang',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF673AB7),
                            padding: EdgeInsets.symmetric(
                              horizontal: buttonPaddingH,
                              vertical: buttonPaddingV,
                            ),
                          ),
                          child: Text(
                            'Tambah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: smallFontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuantityControl(
    TextEditingController controller,
    StateSetter setState,
    double iconSize,
    double fontSize,
    bool isCompact,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Qty: ', style: TextStyle(fontSize: fontSize)),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          iconSize: iconSize,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            int currentQuantity = int.tryParse(controller.text) ?? 1;
            if (currentQuantity > 1) {
              setState(() {
                controller.text = (currentQuantity - 1).toString();
              });
            }
          },
        ),
        SizedBox(
          width: isCompact ? 35 : 45,
          height: isCompact ? 30 : 40,
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: fontSize),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.all(isCompact ? 4 : 8),
              isDense: true,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          iconSize: iconSize,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            int currentQuantity = int.tryParse(controller.text) ?? 0;
            setState(() {
              controller.text = (currentQuantity + 1).toString();
            });
          },
        ),
      ],
    );
  }
}
