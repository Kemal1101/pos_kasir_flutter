import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Data dummy untuk meniru produk dari screenshot
  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Drigo Hoodie',
      'price': '306.890',
      'stock': 18,
      'image': 'assets/images/hoodie_drigo.png', // Ganti dengan jalur aset Anda
      'low_stock': false,
    },
    {
      'name': 'Rucas Hoodie',
      'price': '458.800',
      'stock': 12,
      'image': 'assets/images/hoodie_rucas.png',
      'low_stock': false,
    },
    {
      'name': 'Supreme Hoodie',
      'price': '658.800',
      'stock': 0,
      'image': 'assets/images/hoodie_supreme.png',
      'low_stock': true,
    },
    {
      'name': 'Adidas Samba Sneaker',
      'price': '1.245.890',
      'stock': 28,
      'image': 'assets/images/sneaker_adidas.png',
      'low_stock': false,
    },
    // ... tambahkan data produk lainnya
  ];

  @override
  Widget build(BuildContext context) {
    // Karena MainShell sudah menyediakan Scaffold,
    // kita hanya menggunakan Scaffold untuk layout internal (App Bar dan Body).
    return Scaffold(
      // AppBar di sini akan berfungsi sebagai Header/Dashboard
      appBar: AppBar(
        // Bagian atas dashboard (misal: tulisan SuperCashier, profile, notifikasi)
        automaticallyImplyLeading: false, // Penting agar tidak ada tombol back
        title: const Text(
          'SuperCashier',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              // Ganti dengan gambar profile user
              backgroundColor: Colors.grey,
              child: Text('D'),
            ),
          ),
        ],
        // Gradient background untuk App Bar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8e2de2), Color(0xFF4a00e0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),

      // Konten utama halaman Produk
      body: Column(
        children: [
          // 1. Bar Pencarian dan Kategori
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Input Pencarian
                TextField(
                  decoration: InputDecoration(
                    hintText: "Cari Produk...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 10),

                // Kategori
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip(label: 'All', isSelected: true),
                      _buildCategoryChip(label: 'Scarf'),
                      _buildCategoryChip(label: 'Sneaker'),
                      _buildCategoryChip(label: 'Hoodie'),
                      _buildCategoryChip(label: 'Electronica'),
                      _buildCategoryChip(label: 'Fashion'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Daftar Produk (Grid)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    0.75, // Mengatur rasio agar produk terlihat seperti di screenshot
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(products[index]);
              },
            ),
          ),
        ],
      ),
      // Floating Action Button (Tombol Keranjang Mengambang)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi ketika tombol FAB diklik (misalnya, menambahkan produk ke keranjang)
        },
        backgroundColor: Colors.pinkAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
      ),
    );
  }

  // Widget Pembantu untuk Chip Kategori
  Widget _buildCategoryChip({required String label, bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: isSelected ? Colors.deepPurple : Colors.grey[300],
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  // Widget Pembantu untuk Kartu Produk
  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          Expanded(
            child: Center(
              child: Image.asset(
                product['image'], // Pastikan aset gambar sudah ada
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Detail Produk
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${product['price']}',
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                // Teks Stock/Low Stock
                Row(
                  children: [
                    Text(
                      product['low_stock']
                          ? 'Low stock'
                          : 'Stock: ${product['stock']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: product['low_stock']
                            ? Colors.red
                            : Colors.grey[600],
                        fontWeight: product['low_stock']
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
