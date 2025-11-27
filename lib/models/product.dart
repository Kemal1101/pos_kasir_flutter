class Product {
  final int productId;
  final int? categoriesId;
  final String name;
  final String? description;
  final double costPrice;
  final double sellingPrice;
  final String? productImages;
  final int stock;
  final String? barcode;
  
  // For UI compatibility
  String get category => categoriesId?.toString() ?? 'Uncategorized';
  String get imagePath => productImages ?? '';
  double get price => sellingPrice;
  String get id => productId.toString();

  Product({
    required this.productId,
    this.categoriesId,
    required this.name,
    this.description,
    required this.costPrice,
    required this.sellingPrice,
    this.productImages,
    required this.stock,
    this.barcode,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] as int,
      categoriesId: json['categories_id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      costPrice: double.parse(json['cost_price'].toString()),
      sellingPrice: double.parse(json['selling_price'].toString()),
      productImages: json['product_images'] as String?,
      stock: json['stock'] as int,
      barcode: json['barcode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'categories_id': categoriesId,
      'name': name,
      'description': description,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'product_images': productImages,
      'stock': stock,
      'barcode': barcode,
    };
  }
}