import 'package:flutter/material.dart';
import '../models/product.dart';


class CartPage extends StatelessWidget {
final List<Product> cart;
final void Function(Product) onRemove;


const CartPage({Key? key, required this.cart, required this.onRemove}) : super(key: key);


@override
Widget build(BuildContext context) {
double total = 0; // price parsing omitted; use server-side price numbers in real app
return Scaffold(
appBar: AppBar(title: const Text('Keranjang')),
body: Padding(
padding: const EdgeInsets.all(12),
child: cart.isEmpty
? const Center(child: Text('Keranjang kosong'))
: Column(
children: [
Expanded(
child: ListView.builder(
itemCount: cart.length,
itemBuilder: (context, i) {
final p = cart[i];
return Card(
child: ListTile(
leading: Image.asset(p.image, width: 56, fit: BoxFit.contain),
title: Text(p.name),
subtitle: Text(p.price),
trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => onRemove(p)),
),
);
},
),
),
ElevatedButton(
onPressed: () {},
child: const SizedBox(width: double.infinity, child: Center(child: Padding(padding: EdgeInsets.all(12.0), child: Text('Bayar')))),
)
],
),
),
);
}
}