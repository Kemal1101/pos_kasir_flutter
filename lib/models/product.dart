class Product {
  final int productId;
  final int? categoriesId;
  final String name;
  final String category;
  final double sellingPrice;
  final double costPrice;
  final int stock;
  final String? productImages;
  final String description;

  Product({
    required this.productId,
    this.categoriesId,
    required this.name,
    required this.category,
    required this.sellingPrice,
    required this.costPrice,
    required this.stock,
    this.productImages,
    this.description = '',
  });

  // Daftar produk dari database
  static final List<Product> sampleProducts = [
    Product(
      id: 'PRD001',
      name: 'Air Mineral 600ml',
      category: 'Minuman',
      sellingPrice: 5000,
      costPrice: 3500,
      stock: 197,
      description: 'Air mineral kemasan 600ml',
    ),
    Product(
      id: 'PRD002',
      name: 'Indomie Goreng',
      category: 'Sembako',
      sellingPrice: 3500,
      costPrice: 2500,
      stock: 495,
      description: 'Mie instan rasa goreng',
    ),
    Product(
      id: 'PRD003',
      name: 'Gula Pasir 1kg',
      category: 'Sembako',
      sellingPrice: 15000,
      costPrice: 12000,
      stock: 100,
      description: 'Gula pasir putih 1kg',
    ),
    Product(
      id: 'PRD004',
      name: 'Minyak Goreng 1L',
      category: 'Sembako',
      sellingPrice: 20000,
      costPrice: 16000,
      stock: 120,
      description: 'Minyak goreng 1 liter',
    ),
    Product(
      id: 'PRD005',
      name: 'Deterjen 800g',
      category: 'Kebutuhan Rumah',
      sellingPrice: 17000,
      costPrice: 13000,
      stock: 80,
      description: 'Deterjen cuci 800g',
    ),
    Product(
      id: 'PRD006',
      name: 'Sabun Mandi 100g',
      category: 'Perawatan Pribadi',
      sellingPrice: 4000,
      costPrice: 2500,
      stock: 200,
      description: 'Sabun mandi 100g',
    ),
    Product(
      id: 'PRD007',
      name: 'Biskuit Coklat 150g',
      category: 'Snack',
      sellingPrice: 12000,
      costPrice: 8000,
      stock: 144,
      description: 'Biskuit coklat kemasan 150g',
    ),
    Product(
      id: 'PRD008',
      name: 'Hydro Coco',
      category: 'Minuman',
      sellingPrice: 8000,
      costPrice: 5500,
      stock: 97,
      description: 'Minuman kelapa 250ml',
    ),
  ];

  static const List<String> categories = [
    'All',
    'Minuman',
    'Sembako',
    'Kebutuhan Rumah',
    'Perawatan Pribadi',
    'Snack',
  ];
}