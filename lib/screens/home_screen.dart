import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/auth_service.dart';
import '../utils/responsive_helper.dart';
import '../pages/login_page.dart';
import 'catalog_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 0 = Catalog, 1 = Cart (untuk mobile)

  @override
  Widget build(BuildContext context) {
    final bool showSplitView = ResponsiveHelper.shouldShowSplitView(context);
    final bool isLandscape = ResponsiveHelper.isLandscape(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SuperCashier',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.white,
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
          ),
        ),
        backgroundColor: const Color(0xFF673AB7),
        elevation: 2,
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
          // Cart badge untuk mobile view
          if (!showSplitView)
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
      body: showSplitView
          ? _buildSplitView(context, isLandscape)
          : _buildMobileView(),
      bottomNavigationBar: showSplitView ? null : _buildBottomNavBar(),
    );
  }

  /// Split view untuk tablet/desktop/landscape
  Widget _buildSplitView(BuildContext context, bool isLandscape) {
    final catalogFlex = ResponsiveHelper.getCatalogFlex(context);
    final cartFlex = ResponsiveHelper.getCartFlex(context);
    
    return Row(
      children: [
        // Left side: Catalog
        Expanded(
          flex: catalogFlex,
          child: Container(
            color: Colors.grey[100],
            child: const CatalogScreen(),
          ),
        ),
        // Divider
        Container(
          width: 1,
          color: Colors.grey[300],
        ),
        // Right side: Cart
        Expanded(
          flex: cartFlex,
          child: Container(
            color: Colors.white,
            child: const CartScreen(),
          ),
        ),
      ],
    );
  }

  /// Mobile view dengan bottom navigation
  Widget _buildMobileView() {
    return IndexedStack(
      index: _selectedIndex,
      children: const [
        CatalogScreen(),
        CartScreen(),
      ],
    );
  }

  /// Bottom navigation bar untuk mobile
  Widget? _buildBottomNavBar() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: const Color(0xFF673AB7),
          unselectedItemColor: Colors.grey,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Katalog',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Keranjang',
            ),
          ],
        );
      },
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              
              // Call AuthService logout to remove token
              final authService = AuthService();
              await authService.logout();
              
              // Clear cart data
              if (context.mounted) {
                final cartProvider = context.read<CartProvider>();
                cartProvider.clearCart();
              }
              
              // Navigate to login page and clear navigation stack
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}