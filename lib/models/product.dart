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

  // Compatibility getters
  String get id => productId.toString();
  double get price => sellingPrice;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] is int 
          ? json['product_id'] 
          : int.parse(json['product_id'].toString()),
      categoriesId: json['categories_id'] != null
          ? (json['categories_id'] is int 
              ? json['categories_id'] 
              : int.parse(json['categories_id'].toString()))
          : null,
      name: json['name'] as String,
      category: json['category']?.toString() ?? 'Uncategorized',
      costPrice: double.parse(json['cost_price'].toString()),
      sellingPrice: double.parse(json['selling_price'].toString()),
      productImages: json['product_images'] as String?,
      stock: json['stock'] is int 
          ? json['stock'] 
          : int.parse(json['stock'].toString()),
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'categories_id': categoriesId,
      'name': name,
      'category': category,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'product_images': productImages,
      'stock': stock,
      'description': description,
    };
  }

  // Daftar produk dari database
  static final List<Product> sampleProducts = [
    Product(
      productId: 1,
      name: 'Air Mineral 600ml',
      category: 'Minuman',
      sellingPrice: 5000,
      costPrice: 3500,
      stock: 197,
      description: 'Air mineral kemasan 600ml',
    ),
    Product(
      productId: 2,
      name: 'Indomie Goreng',
      category: 'Sembako',
      sellingPrice: 3500,
      costPrice: 2500,
      stock: 495,
      description: 'Mie instan rasa goreng',
    ),
    Product(
      productId: 3,
      name: 'Gula Pasir 1kg',
      category: 'Sembako',
      sellingPrice: 15000,
      costPrice: 12000,
      stock: 100,
      description: 'Gula pasir putih 1kg',
    ),
    Product(
      productId: 4,
      name: 'Minyak Goreng 1L',
      category: 'Sembako',
      sellingPrice: 20000,
      costPrice: 16000,
      stock: 120,
      description: 'Minyak goreng 1 liter',
    ),
    Product(
      productId: 5,
      name: 'Deterjen 800g',
      category: 'Kebutuhan Rumah',
      sellingPrice: 17000,
      costPrice: 13000,
      stock: 80,
      description: 'Deterjen cuci 800g',
    ),
    Product(
      productId: 6,
      name: 'Sabun Mandi 100g',
      category: 'Perawatan Pribadi',
      sellingPrice: 4000,
      costPrice: 2500,
      stock: 200,
      description: 'Sabun mandi 100g',
    ),
    Product(
      productId: 7,
      name: 'Biskuit Coklat 150g',
      category: 'Snack',
      sellingPrice: 12000,
      costPrice: 8000,
      stock: 144,
      description: 'Biskuit coklat kemasan 150g',
    ),
    Product(
      productId: 8,
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
    'Sembako',
    'Minuman',
    'Snack',
    'Kebutuhan Rumah',
    'Perawatan Pribadi',
  ];
}