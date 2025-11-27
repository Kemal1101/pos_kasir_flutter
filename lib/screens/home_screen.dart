import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
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
              onPressed: () {
                // Tambahkan logika logout aplikasi di sini
                print('Logout berhasil!');
                Navigator.of(ctx).pop();
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
      title: const Text('SuperCashier', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      actions: <Widget>[
        const CircleAvatar(backgroundColor: Color(0xFFE0C1F8), child: Icon(Icons.person, color: Color(0xFF673AB7))),
        const Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('Dewi, Cashier', style: TextStyle(color: Colors.black54, fontSize: 14)))),
        IconButton(icon: const Icon(Icons.notifications_none, color: Colors.deepPurple), onPressed: () {}),
      ],
      bottom: PreferredSize(preferredSize: const Size.fromHeight(1.0), child: Container(color: Colors.grey[200], height: 1.0)),
    );
  }
}