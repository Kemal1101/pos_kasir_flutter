import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalAmount);

  // Pajak 11% (contoh)
  double get taxRate => 0.11;
  double get taxAmount => subtotal * taxRate;

  // Total (Subtotal + Pajak)
  double get total => subtotal + taxAmount;

  // Data dummy produk katalog (sesuai gambar)
  final List<Product> catalog = [
    Product(id: 'p1', name: 'Erigo Hoodie', price: 300000, stock: 15, imagePath: 'hoodie_supreme.png', category: 'Hoodie'),
    Product(id: 'p2', name: 'Rucas Hoodie', price: 450000, stock: 12, imagePath: 'hoodie_grey.png', category: 'Hoodie'),
    Product(id: 'p3', name: 'Adidas Samba Sneaker', price: 1245000, stock: 30, imagePath: 'sneaker_samba.png', category: 'Sneaker'),
    Product(id: 'p4', name: 'New Balance 530 Sneaker', price: 1225000, stock: 50, imagePath: 'sneaker_nb.png', category: 'Sneaker'),
    Product(id: 'p5', name: 'Red Scarf', price: 518000, stock: 100, imagePath: 'scarf_red.png', category: 'Scarf'),
    Product(id: 'p6', name: 'Grey Scarf', price: 520000, stock: 45, imagePath: 'scarf_grey.png', category: 'Scarf'),
  ];
  
  // ------------------- LOGIC ADD TO CART -------------------

  void addProductToCart(Product product, String sizeColor, {int quantity = 1}) {
    // Cari apakah item sudah ada di keranjang dengan ukuran/warna yang sama
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == product.id && item.sizeColor == sizeColor,
    );

    if (existingItemIndex >= 0) {
      // Jika sudah ada, tambahkan kuantitas sesuai input
      _items[existingItemIndex].quantity += quantity;
    } else {
      // Jika belum ada, tambahkan item baru
      _items.add(CartItem(product: product, sizeColor: sizeColor, quantity: quantity));
    }
    notifyListeners();
  }

  // ------------------- LOGIC MANIPULASI KERANJANG -------------------

  void increaseQuantity(String productId, String sizeColor) {
    final itemIndex = _items.indexWhere((item) => item.product.id == productId && item.sizeColor == sizeColor);
    if (itemIndex != -1) {
      _items[itemIndex].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId, String sizeColor) {
    final itemIndex = _items.indexWhere((item) => item.product.id == productId && item.sizeColor == sizeColor);
    if (itemIndex != -1) {
      if (_items[itemIndex].quantity > 1) {
        _items[itemIndex].quantity--;
      } else {
        // Jika kuantitas tinggal 1, hapus item dari keranjang
        _items.removeAt(itemIndex);
      }
      notifyListeners();
    }
  }

  void removeCartItem(String productId, String sizeColor) {
    _items.removeWhere(
      (item) => item.product.id == productId && item.sizeColor == sizeColor,
    );
    notifyListeners();
  }

  // Logika untuk tombol "Checkout" di panel kanan, mengarahkan ke halaman Payment
  void processCheckout() {
    if (_items.isEmpty) return;
    // Di aplikasi nyata, ini akan men-trigger navigasi ke PaymentScreen
    print('Processing checkout for ${total.toStringAsFixed(0)}');
  }

  // Membersihkan semua item dari keranjang
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}