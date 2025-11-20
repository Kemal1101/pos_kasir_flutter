import 'package:flutter/material.dart';
import '../models/product.dart';


class ProductDetailPage extends StatelessWidget {
final Product product;
final void Function(Product) onAdd;


const ProductDetailPage({Key? key, required this.product, required this.onAdd}) : super(key: key);


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text(product.name)),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
Hero(tag: 'prod_${product.id}', child: Image.asset(product.image, height: 220, fit: BoxFit.contain)),
const SizedBox(height: 20),
Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
Text(product.price, style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
const SizedBox(height: 12),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text('Stock: ${product.stock}'),
ElevatedButton.icon(
onPressed: () {
onAdd(product);
final snack = SnackBar(content: Text('${product.name} ditambahkan ke keranjang'));
ScaffoldMessenger.of(context).showSnackBar(snack);
},
icon: const Icon(Icons.add_shopping_cart),
label: const Text('Tambah ke Keranjang'),
)
],
),
const SizedBox(height: 18),
const Expanded(
child: SingleChildScrollView(
child: Text('Deskripsi produk singkat. Tambahkan detail, ukuran, bahan, dan informasi lain di sini.'),
),
)
],
),
),
);
}
}