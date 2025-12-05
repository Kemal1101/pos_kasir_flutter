import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart'; // Pastikan path ini benar

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Consumer digunakan untuk mendapatkan jumlah item keranjang (badge) secara dinamis
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Penting agar semua item terlihat
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: currentIndex,
          onTap: onTap,
          items: <BottomNavigationBarItem>[
            // 1. Produk
            const BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Produk',
            ),
            
            // 2. Keranjang (dengan Badge Dinamis)
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none, // Memungkinkan badge keluar dari batas ikon
                children: [
                  const Icon(Icons.shopping_bag_outlined),
                  // Tampilkan badge hanya jika ada item di keranjang
                  if (cart.itemCount > 0)
                    Positioned(
                      right: -10,
                      top: -5,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.5) // Border putih kecil agar menonjol
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          // Menampilkan total jumlah kuantitas item
                          cart.itemCount.toString(), 
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ],
              ),
              label: 'Keranjang',
            ),
            
            // 3. Logout
            const BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
        );
      },
    );
  }
}