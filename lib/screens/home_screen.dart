import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../providers/cart_provider.dart';
import '../services/auth_service.dart';
import 'catalog_screen.dart';
import 'payment_screen.dart'; // Digunakan jika navigasi terjadi

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Daftar screens
  final List<Widget> _screens = [
    const CatalogScreen(), // Index 0: Produk
    const PaymentScreen(), // Index 1: Keranjang (sekarang langsung ke halaman summary)
    const CatalogScreen(), // Index 2: Placeholder untuk Logout
  ];

  void _onTap(int index) {
    // Logika untuk Logout
    if (index == 2) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                // Tutup dialog
                Navigator.of(ctx).pop();
                
                // Tampilkan loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                
                // Logout dari AuthService (hapus token)
                final authService = AuthService();
                await authService.logout();
                
                // Clear cart
                if (mounted) {
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  cartProvider.clearCart();
                }
                
                // Tutup loading dan kembali ke login
                if (mounted) {
                  Navigator.of(context).pop(); // Tutup loading
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF7B4FD8), Color(0xFFA678D8)],
          ),
        ),
      ),
      title: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Super',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'Cashier',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        const CircleAvatar(
          backgroundColor: Colors.white,
          radius: 18,
          child: Icon(Icons.person, color: Color(0xFF7B4FD8), size: 22),
        ),
        const SizedBox(width: 8),
        const Center(
          child: Text(
            'Dewi, Cashier',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
          onPressed: () {},
        ),
      ],
    );
  }
}