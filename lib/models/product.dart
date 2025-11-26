class Product {
  final String id;
  final String name;
  final String price;
  final int stock;
  final String image;
  final String category;
  final IconType iconType;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.image,
    required this.category,
    this.iconType = IconType.product,
  });

  static const categories = ["All", "Scarf", "Sneaker", "Hoodie", "Electronics", "Fashion"];

  static List<Product> sampleProducts = [
    Product(
      id: 'p1',
      name: 'Erigo Hoodie',
      price: 'Rp 300.000',
      stock: 15,
      image: 'assets/hoodie1.png',
      category: 'Hoodie',
      iconType: IconType.shirt,
    ),
    Product(
      id: 'p2',
      name: 'Rucas Hoodie',
      price: 'Rp 450.000',
      stock: 12,
      image: 'assets/hoodie2.png',
      category: 'Hoodie',
      iconType: IconType.shirt,
    ),
    Product(
      id: 'p3',
      name: 'Supreme Hoodie',
      price: 'Rp 850.000',
      stock: 3,
      image: 'assets/hoodie3.png',
      category: 'Hoodie',
      iconType: IconType.shirt,
    ),
    Product(
      id: 'p4',
      name: 'Adidas Samba Sneaker',
      price: 'Rp 1.245.000',
      stock: 30,
      image: 'assets/samba.png',
      category: 'Sneaker',
      iconType: IconType.shoes,
    ),
    Product(
      id: 'p5',
      name: 'New Balance 530 Sneaker',
      price: 'Rp 1.225.000',
      stock: 58,
      image: 'assets/nb530.png',
      category: 'Sneaker',
      iconType: IconType.shoes,
    ),
    Product(
      id: 'p6',
      name: 'Grey Scarf',
      price: 'Rp 520.000',
      stock: 42,
      image: 'assets/scarf1.png',
      category: 'Scarf',
      iconType: IconType.scarf,
    ),
    Product(
      id: 'p7',
      name: 'Red Scarf',
      price: 'Rp 518.000',
      stock: 100,
      image: 'assets/scarf2.png',
      category: 'Scarf',
      iconType: IconType.scarf,
    ),
  ];
}

enum IconType { product, shirt, shoes, scarf }