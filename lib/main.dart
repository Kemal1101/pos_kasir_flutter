import 'package:flutter/material.dart';
child: Padding(
padding: const EdgeInsets.all(10.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Expanded(
child: Hero(
tag: 'prod_${p.id}',
child: Image.asset(p.image, fit: BoxFit.contain),
),
),
const SizedBox(height: 8),
Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
const SizedBox(height: 4),
Text(p.price, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
const SizedBox(height: 4),
Text('Stok: ${p.stock}', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
],
),
),
),
);
},
),
),
)
],
),
),
floatingActionButton: FloatingActionButton(
onPressed: () => Navigator.pushNamed(context, '/cart'),
child: const Icon(Icons.shopping_cart),
),
bottomNavigationBar: BottomNavigationBar(
items: const [
BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Produk'),
BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Laporan'),
BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
],
currentIndex: 0,
onTap: (i) {},
),
);
}
}