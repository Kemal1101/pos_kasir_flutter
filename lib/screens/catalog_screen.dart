import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_dialog.dart'; // Memastikan import ini menunjuk ke file di dalam folder 'screens'

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Daftar kategori produk yang akan ditampilkan di TabBar
  final List<String> categories = ['All', 'Scarf', 'Sneaker', 'Hoodie', 'Electronics', 'Fashion'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          // Search Bar
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari Produk...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none),
                fillColor: Color(0xFFF5F5F5),
                filled: true,
              ),
            ),
          ),

          // Category/Filter Tab Bar
          _buildCategoryFilter(),
          const SizedBox(height: 16),

          // Product Grid View
          Expanded(
            child: Consumer<CartProvider>(
              builder: (ctx, cart, child) {
                final List<Product> filteredProducts = cart.catalog.where((p) {
                  final selectedCategory = categories[_tabController.index];
                  final matchesCategory = selectedCategory == 'All' || p.category == selectedCategory;
                  final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
                  return matchesCategory && matchesSearch;
                }).toList();

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        showDialog(
                          context: context, // Menggunakan context yang benar dari builder
                          builder: (ctx) => ProductDetailDialog(product: product),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        indicator: const BoxDecoration(),
        tabs: categories.map((category) {
          final bool isSelected = categories.indexOf(category) == _tabController.index;
          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(category, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
            ),
          );
        }).toList(),
      ),
    );
  }
}