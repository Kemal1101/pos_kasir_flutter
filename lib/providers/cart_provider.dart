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
    print('[ADD-PRODUCT] Request to add ${product.name} with qty: $quantity');
    print('[ADD-PRODUCT] Current cart items count: ${_items.length}');
    print('[ADD-PRODUCT] Current sale: ${_currentSale?.saleId}');
    
    // Ensure we have an active sale
    if (_currentSale == null) {
      print('[ADD-PRODUCT] No current sale, creating new one...');
      final initialized = await initializeSale();
      if (!initialized) return false;
    } else if (_items.isEmpty) {
      // If cart is empty but sale exists, it means sale was likely deleted
      // Create a new sale instead of refreshing
      print('[ADD-PRODUCT] Cart is empty but sale exists, creating new sale...');
      _currentSale = null;
      final initialized = await initializeSale();
      if (!initialized) return false;
    } else {
      print('[ADD-PRODUCT] Using existing sale_id: ${_currentSale!.saleId}');
      // Only refresh if cart has items
      await _refreshCurrentSale();
      print('[ADD-PRODUCT] After refresh, cart items count: ${_items.length}');
    }

    // Check if product already exists in cart
    final existingIndex = _items.indexWhere(
      (item) => item.product.productId == product.productId,
    );

    print('[ADD-PRODUCT] Existing index for product_id ${product.productId}: $existingIndex');
    
    if (existingIndex >= 0) {
      // Product exists - increment the existing item's quantity
      final existingItem = _items[existingIndex];
      print('[ADD-PRODUCT] Product ${product.name} already exists in cart');
      print('[ADD-PRODUCT] Existing item qty: ${existingItem.quantity}, sale_item_id: ${existingItem.saleItemId}');
      
      final newQuantity = existingItem.quantity + quantity;
      print('[ADD-PRODUCT] Calculated new quantity: ${existingItem.quantity} + $quantity = $newQuantity');
      
      if (existingItem.saleItemId == null) {
        print('[ADD-PRODUCT ERROR] Existing item has no saleItemId');
        return false;
      }

      // Strategy: Delete old item, then add with new total quantity
      print('[INCREMENT] Deleting sale_item_id: ${existingItem.saleItemId}, then add with qty: $newQuantity');
      
      _isProcessing = true;
      notifyListeners();

      // Step 1: Delete existing item
      final deleteResult = await _saleService.removeItem(existingItem.saleItemId!);
      if (!deleteResult['success']) {
        _isProcessing = false;
        _errorMessage = deleteResult['message'];
        notifyListeners();
        return false;
      }

      // Step 2: Add with new quantity
      final addResult = await _saleService.addItem(
        saleId: _currentSale!.saleId,
        productId: product.productId,
        quantity: newQuantity,
        discountAmount: 0,
      );

      _isProcessing = false;

      if (addResult['success']) {
        _currentSale = addResult['sale'] as Sale;
        _syncCartFromSale();
        notifyListeners();
        return true;
      } else {
        _errorMessage = addResult['message'];
        notifyListeners();
        return false;
      }
    }

    // Product doesn't exist, add new item
    print('[ADD-PRODUCT] Adding new product ${product.name} to cart (qty: $quantity)');
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


  /// Refresh current sale data from backend
  Future<void> _refreshCurrentSale() async {
    if (_currentSale == null) return;

    final result = await _saleService.getSale(_currentSale!.saleId);
    if (result['success']) {
      _currentSale = result['sale'] as Sale;
      _syncCartFromSale();
    }
  }

  /// Remove item from cart via API
  Future<bool> removeItemFromSale(int saleItemId) async {
    print('[API] Deleting sale_item_id: $saleItemId from backend...');
    
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saleService.removeItem(saleItemId);

    _isProcessing = false;

    if (result['success']) {
      print('[API] Successfully deleted sale_item_id: $saleItemId');
      _currentSale = result['sale'] as Sale;
      _syncCartFromSale();
      
      print('[CHECK] Cart items count after delete: ${_items.length}');
      print('[CHECK] Current sale status: ${_currentSale?.paymentStatus}');
      
      // Auto-delete sale ONLY if it's still in draft status and cart is empty
      if (_items.isEmpty && _currentSale != null && _currentSale!.paymentStatus == 'draft') {
        print('[AUTO-DELETE] Cart is empty, deleting draft sale_id: ${_currentSale!.saleId}');
        final deleted = await clearSale();
        if (deleted) {
          print('[AUTO-DELETE] Sale successfully deleted. _currentSale is now: $_currentSale');
          if (onSaleAutoDeleted != null) {
            onSaleAutoDeleted!();
          }
        } else {
          print('[AUTO-DELETE ERROR] Failed to delete sale');
        }
      } else {
        print('[SKIP AUTO-DELETE] Items: ${_items.length}, Sale: ${_currentSale?.saleId}, Status: ${_currentSale?.paymentStatus}');
      }
      
      notifyListeners();
      return true;
    } else {
      print('[API ERROR] Failed to delete sale_item_id: $saleItemId - ${result['message']}');
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  /// Sync local cart items from current sale
  void _syncCartFromSale() {
    _items.clear();
    if (_currentSale?.items != null) {
      // Group items by product_id to handle potential duplicates from backend
      final Map<int, SaleItem> uniqueItems = {};
      
      for (var saleItem in _currentSale!.items!) {
        final productId = saleItem.productId;
        
        if (uniqueItems.containsKey(productId)) {
          // If duplicate exists, just keep the latest one (should not happen normally)
          print('WARNING: Duplicate sale_item found for product_id: $productId - keeping latest');
          uniqueItems[productId] = saleItem;
        } else {
          uniqueItems[productId] = saleItem;
        }
      }
      
      // Now create CartItems from unique sale items
      for (var saleItem in uniqueItems.values) {
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

  /// Complete sale (finalize payment)
  /// paymentId: 1=cash, 2=card, 5=qris
  Future<Map<String, dynamic>> completeSale({
    required int paymentId,
  }) async {
    if (_currentSale == null) {
      return {
        'success': false,
        'message': 'No active sale',
      };
    }

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saleService.completeSale(
      saleId: _currentSale!.saleId,
      paymentId: paymentId,
    );

    _isProcessing = false;

    if (result['success']) {
      final completedSale = result['sale'] as Sale;
      // Clear cart and reset current sale after successful payment
      _items.clear();
      _currentSale = null; // Reset to allow new sale
      
      // Refresh products to update stock after sale
      fetchProducts();
      
      notifyListeners();
      return {
        'success': true,
        'message': result['message'] ?? 'Payment confirmed successfully',
        'sale': completedSale,
      };
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return {
        'success': false,
        'message': result['message'],
      };
    }
  }

  /// Clear current sale (delete draft)
  Future<bool> clearSale() async {
    if (_currentSale == null) {
      print('[CLEAR-SALE] No current sale to clear');
      return true;
    }

    if (_currentSale!.paymentStatus != 'draft') {
      print('[CLEAR-SALE ERROR] Cannot delete sale ${_currentSale!.saleId} - status is ${_currentSale!.paymentStatus}');
      _errorMessage = 'Cannot delete completed sales';
      notifyListeners();
      return false;
    }

    print('[CLEAR-SALE] Deleting draft sale_id: ${_currentSale!.saleId}');
    
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saleService.deleteSale(_currentSale!.saleId);

    _isProcessing = false;

    if (result['success']) {
      print('[CLEAR-SALE SUCCESS] Sale deleted. Setting _currentSale to null');
      _currentSale = null;
      _items.clear();
      notifyListeners();
      return true;
    } else {
      print('[CLEAR-SALE ERROR] Failed to delete: ${result['message']}');
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

  // Local methods (kept for backward compatibility if needed)
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  /// Delete item from cart via API by index
  Future<bool> deleteItem(int index) async {
    if (index < 0 || index >= _items.length) {
      print('[DELETE] Invalid index: $index');
      return false;
    }
    
    final item = _items[index];
    print('[DELETE] Deleting item at index $index: ${item.product.name} (qty: ${item.quantity})');
    
    if (item.saleItemId == null) {
      print('[DELETE] No saleItemId, removing locally only');
      // If no saleItemId, just remove locally
      _items.removeAt(index);
      notifyListeners();
      return true;
    }
    
    print('[DELETE] Calling API to delete sale_item_id: ${item.saleItemId}');
    // Call API to delete
    return await removeItemFromSale(item.saleItemId!);
  }

  void removeSelected() {
    _items.removeWhere((item) => item.isSelected);
    notifyListeners();
  }

  /// Update item quantity via API
  Future<bool> updateQuantity(int index, int newQuantity) async {
    if (index < 0 || index >= _items.length || newQuantity <= 0) return false;
    
    final item = _items[index];
    if (_currentSale == null || item.saleItemId == null) return false;

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saleService.updateItemQuantity(
      saleId: _currentSale!.saleId,
      saleItemId: item.saleItemId!,
      productId: item.product.productId,
      newQuantity: newQuantity,
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

  /// Increase quantity via API
  Future<void> increaseQuantity(int index) async {
    if (index >= 0 && index < _items.length) {
      final currentQty = _items[index].quantity;
      await updateQuantity(index, currentQty + 1);
    }
  }

  /// Decrease quantity via API
  Future<void> decreaseQuantity(int index) async {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      final currentQty = item.quantity;
      
      print('[DECREASE] Item: ${item.product.name}, current qty: $currentQty, index: $index');
      
      if (currentQty <= 1) {
        // If quantity is 1 or less, delete the item completely
        print('[DECREASE] Quantity is $currentQty (<=1), will DELETE item (sale_item_id: ${item.saleItemId})');
        final deleted = await deleteItem(index);
        print('[DECREASE] Delete result: $deleted');
      } else {
        // Update to new quantity
        print('[DECREASE] Updating quantity from $currentQty to ${currentQty - 1}');
        await updateQuantity(index, currentQty - 1);
      }
    } else {
      print('[DECREASE ERROR] Invalid index: $index (items length: ${_items.length})');
    }
  }

  void clearCart() {
    _items.clear();
    _currentSale = null;
    notifyListeners();
  }
}
