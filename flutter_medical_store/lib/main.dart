import 'package:flutter/material.dart';

void main() {
  runApp(const MedicalStoreApp());
}

class MedicalStoreApp extends StatelessWidget {
  const MedicalStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Medicine> _inventory = [
    Medicine(name: 'Paracetamol 500mg', price: 30, stock: 20, category: 'Pain Relief'),
    Medicine(name: 'Cough Syrup', price: 95, stock: 12, category: 'Cold & Cough'),
    Medicine(name: 'Vitamin C Tablets', price: 120, stock: 18, category: 'Supplements'),
    Medicine(name: 'Antacid Gel', price: 70, stock: 10, category: 'Digestive Care'),
    Medicine(name: 'Bandage Roll', price: 40, stock: 25, category: 'First Aid'),
    Medicine(name: 'Hand Sanitizer', price: 60, stock: 15, category: 'Hygiene'),
  ];

  final Map<String, int> _cart = {};

  List<Medicine> get _filteredInventory {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _inventory;

    return _inventory.where((medicine) {
      return medicine.name.toLowerCase().contains(query) ||
          medicine.category.toLowerCase().contains(query);
    }).toList();
  }

  void _addToCart(Medicine medicine) {
    final quantity = _cart[medicine.name] ?? 0;
    if (quantity >= medicine.stock) {
      _showMessage('Only ${medicine.stock} units available for ${medicine.name}.');
      return;
    }

    setState(() {
      _cart[medicine.name] = quantity + 1;
    });

    _showMessage('${medicine.name} added to cart.');
  }

  void _removeFromCart(String medicineName) {
    final quantity = _cart[medicineName];
    if (quantity == null) return;

    setState(() {
      if (quantity == 1) {
        _cart.remove(medicineName);
      } else {
        _cart[medicineName] = quantity - 1;
      }
    });
  }

  double get _totalPrice {
    double total = 0;
    for (final entry in _cart.entries) {
      final medicine = _inventory.firstWhere((item) => item.name == entry.key);
      total += medicine.price * entry.value;
    }
    return total;
  }

  int get _cartItemCount => _cart.values.fold(0, (sum, qty) => sum + qty);

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Store'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Badge.count(
              count: _cartItemCount,
              isLabelVisible: _cartItemCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search medicine or category',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredInventory.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final medicine = _filteredInventory[index];
                final quantityInCart = _cart[medicine.name] ?? 0;

                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(medicine.name),
                    subtitle: Text(
                      '${medicine.category} • ₹${medicine.price.toStringAsFixed(0)} • Stock: ${medicine.stock}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: quantityInCart > 0
                              ? () => _removeFromCart(medicine.name)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('$quantityInCart'),
                        IconButton(
                          onPressed: () => _addToCart(medicine),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cart items: $_cartItemCount'),
                const SizedBox(height: 4),
                Text(
                  'Total: ₹${_totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _cart.isEmpty
                        ? null
                        : () => _showMessage('Order placed successfully!'),
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Medicine {
  final String name;
  final double price;
  final int stock;
  final String category;

  const Medicine({
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
  });
}
