import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/sale.dart';
import '../services/sale_service.dart';
import '../services/product_service.dart';

class CartProvider with ChangeNotifier {
  final SaleService _saleService = SaleService();
  final ProductService _productService = ProductService();

  // Current active sale (draft)
  Sale? _currentSale;
  Sale? get currentSale => _currentSale;

  // Products catalog from API
  List<Product> _catalog = [];
  List<Product> get catalog => _catalog;

  // Loading states
  bool _isLoadingProducts = false;
  bool _isLoadingSale = false;
  bool _isProcessing = false;

  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingSale => _isLoadingSale;
  bool get isProcessing => _isProcessing;

  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Callback for sale auto-deletion notification
  Function()? onSaleAutoDeleted;

  // Local cart items for UI (derived from current sale)
  final List<CartItem> _items = [];
  List<CartItem> get items => _items;
  List<CartItem> get cartItems => _items; // Alias for compatibility

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  // Use backend calculation instead of local calculation
  double get subtotal => _currentSale?.subtotal ?? 0.0;
  double get taxRate => 0.0; // 11%
  double get taxAmount => _currentSale?.taxAmount ?? 0.0;
  double get total => _currentSale?.totalAmount ?? 0.0;

  // ------------------- PRODUCT CATALOG -------------------

  /// Fetch products from API
  Future<void> fetchProducts({int? categoryId, String? search}) async {
    _isLoadingProducts = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _productService.getProducts(
      categoryId: categoryId,
      search: search,
    );

    _isLoadingProducts = false;

    if (result['success']) {
      _catalog = result['products'] as List<Product>;
    } else {
      _errorMessage = result['message'];
      _catalog = [];
    }

    notifyListeners();
  }

  // ------------------- SALE MANAGEMENT -------------------

  /// Initialize a new sale (draft)
  Future<bool> initializeSale() async {
    if (_currentSale != null && _currentSale!.paymentStatus == 'draft') {
      // Already have an active draft sale
      return true;
    }

    _isLoadingSale = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saleService.createSale();

    _isLoadingSale = false;

    if (result['success']) {
      _currentSale = result['sale'] as Sale;
      _syncCartFromSale();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  /// Add product to cart (creates sale if needed)
  Future<bool> addProductToCart(
    Product product,
    String sizeColor, {
    int quantity = 1,
  }) async {
    // Ensure we have an active sale
    if (_currentSale == null) {
      final initialized = await initializeSale();
      if (!initialized) return false;
    }

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saleService.addItem(
      saleId: _currentSale!.saleId,
      productId: product.productId,
      quantity: quantity,
      discountAmount: 0,
    );

    _isProcessing = false;

    if (result['success']) {
      _currentSale = result['sale'] as Sale;
      _syncCartFromSale();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  /// Remove item from cart via API
  Future<bool> removeItemFromSale(int saleItemId) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saleService.removeItem(saleItemId);

    _isProcessing = false;

    if (result['success']) {
      _currentSale = result['sale'] as Sale;
      _syncCartFromSale();
      
      // Auto-delete sale ONLY if it's still in draft status and cart is empty
      if (_items.isEmpty && _currentSale != null && _currentSale!.paymentStatus == 'draft') {
        print('Cart is empty, auto-deleting draft sale ${_currentSale!.saleId}');
        final deleted = await clearSale();
        if (deleted && onSaleAutoDeleted != null) {
          onSaleAutoDeleted!();
        }
      }
      
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  /// Sync local cart items from current sale
  void _syncCartFromSale() {
    _items.clear();
    if (_currentSale?.items != null) {
      for (var saleItem in _currentSale!.items!) {
        // Find product in catalog
        final product = _catalog.firstWhere(
          (p) => p.productId == saleItem.productId,
          orElse: () => Product(
            productId: saleItem.productId,
            name: saleItem.nameProduct,
            category: 'Unknown',
            costPrice: 0,
            sellingPrice: saleItem.subtotal / saleItem.quantity,
            stock: 0,
          ),
        );

        _items.add(CartItem(
          product: product,
          sizeColor: 'Default',
          quantity: saleItem.quantity,
          isSelected: true,
          saleItemId: saleItem.saleItemId,
        ));
      }
    }
  }

  /// Load existing sale
  Future<bool> loadSale(int saleId) async {
    _isLoadingSale = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saleService.getSale(saleId);

    _isLoadingSale = false;

    if (result['success']) {
      _currentSale = result['sale'] as Sale;
      _syncCartFromSale();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  /// Clear current sale (delete draft)
  Future<bool> clearSale() async {
    if (_currentSale == null) return true;

    if (_currentSale!.paymentStatus != 'draft') {
      print('Warning: Cannot delete sale ${_currentSale!.saleId} - status is ${_currentSale!.paymentStatus}');
      _errorMessage = 'Cannot delete completed sales';
      notifyListeners();
      return false;
    }

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saleService.deleteSale(_currentSale!.saleId);

    _isProcessing = false;

    if (result['success']) {
      _currentSale = null;
      _items.clear();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ------------------- CART ITEM MANAGEMENT -------------------

  void toggleSelect(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  void increaseQty(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQty(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  /// Delete item from cart via API by index
  Future<bool> deleteItem(int index) async {
    if (index < 0 || index >= _items.length) return false;
    
    final item = _items[index];
    if (item.saleItemId == null) {
      // If no saleItemId, just remove locally
      _items.removeAt(index);
      notifyListeners();
      return true;
    }
    
    // Call API to delete
    return await removeItemFromSale(item.saleItemId!);
  }

  void removeSelected() {
    _items.removeWhere((item) => item.isSelected);
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _items.length && newQuantity > 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _currentSale = null;
    notifyListeners();
  }

  // Aliases for compatibility
  void increaseQuantity(int index) => increaseQty(index);
  void decreaseQuantity(int index) => decreaseQty(index);
}
