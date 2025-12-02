// main_shell.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../pages/home_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 0;

  // Daftar halaman konten (Produk dan Keranjang)
  final List<Widget> _pages = const [
    HomePage(), // Index 0: Produk
  ];

  // --- FUNGSI LOGOUT SEBENARNYA ---
  void _executeLogout() async {
    // 1. Panggil service untuk menghapus token/session
    try {
      await _authService.logout();
    } catch (e) {
      debugPrint("Gagal logout: $e");
    }

    // 2. Arahkan kembali ke halaman login
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  // --- FUNGSI POP-UP KONFIRMASI ---
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Keluar Aplikasi?'),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari SuperCashier?',
          ),
          actions: <Widget>[
            TextButton(
              // Tombol Batal
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              // Tombol Konfirmasi Logout
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Ya, Logout',
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        );
      },
    ).then((confirmed) {
      // Jika pengguna menekan 'Ya, Logout' (confirmed == true)
      if (confirmed == true) {
        _executeLogout(); // Jalankan fungsi logout yang sebenarnya
      }
    });
  }

  // --- FUNGSI PENGATUR ONTAP ---
  void _onItemTapped(int index) {
    // Cek jika item yang diklik adalah 'Logout' (Index 2)
    if (index == 2) {
      // Panggil dialog konfirmasi, bukan langsung logout
      _showLogoutConfirmationDialog(context);
    } else {
      // Jika Produk (0) atau Keranjang (1), ubah state
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      // BottomNavigationBar tetap sama
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
