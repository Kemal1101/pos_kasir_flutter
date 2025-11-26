import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'models/product.dart';
import 'pages/product_detail_page.dart';
import 'pages/cart_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'SuperCashier',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('SuperCashier', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Text('Dewi, Cashier', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0 ? ProductListView(selectedCategory: _selectedCategory, onCategoryChange: (cat) => setState(() => _selectedCategory = cat)) : const Center(child: Text('Page not implemented')),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _selectedIndex,
        onTap: (i) {
          if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartPageRoute(),
              ),
            );
          } else {
            setState(() => _selectedIndex = i);
          }
        },
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChange;

  const ProductListView({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredProducts = selectedCategory == 'All'
        ? Product.sampleProducts
        : Product.sampleProducts.where((p) => p.category == selectedCategory).toList();

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari Produk...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        // Category Filter
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: Product.categories.length,
            itemBuilder: (context, index) {
              final cat = Product.categories[index];
              final isSelected = cat == selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) => onCategoryChange(cat),
                  backgroundColor: Colors.white,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Product Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final p = filteredProducts[index];
              final isLowStock = p.stock < 10;
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(
                      product: p,
                      onAdd: (product) => context.read<CartProvider>().addProduct(product),
                    ),
                  ),
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.grey[100],
                            child: Hero(
                              tag: 'prod_${p.id}',
                              child: Image.asset(p.image, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(p.price, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                        const SizedBox(height: 4),
                        if (isLowStock)
                          Text('Stok: ${p.stock}', style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w500))
                        else
                          Text('Stok: ${p.stock}', style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CartPageRoute extends StatelessWidget {
  const CartPageRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) => CartPage(
        cart: cart.products,
        onRemove: (product) => cart.removeProduct(product),
      ),
    );
  }
}

class CartProvider extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }
}