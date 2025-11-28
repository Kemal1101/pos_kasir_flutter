import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalAmount);

  // Total (sekarang sama dengan subtotal karena tidak ada pajak)
  double get total => subtotal;

  // Data produk katalog
  final List<Product> catalog = Product.sampleProducts;

  // ------------------- LOGIC ADD TO CART -------------------

  void addProductToCart(Product product, {int quantity = 1}) {
    // Cari apakah item sudah ada di keranjang
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Jika sudah ada, tambahkan kuantitas
      _items[existingItemIndex].quantity += quantity;
    } else {
      // Jika belum ada, tambahkan item baru
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  // Menambahkan CartItem langsung
  void addItem(CartItem cartItem) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == cartItem.product.id,
    );

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += cartItem.quantity;
    } else {
      _items.add(cartItem);
    }
    notifyListeners();
  }

  // ------------------- LOGIC MANIPULASI KERANJANG -------------------

  void increaseQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(int index) {
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

  // Memperbarui kuantitas item secara langsung
  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _items.length && newQuantity > 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  // Membersihkan semua item dari keranjang
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
