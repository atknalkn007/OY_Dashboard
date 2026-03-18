import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import '../../widgets/cart_preview.dart';
import '../../widgets/product_card.dart';
import '../../widgets/suggested_products_carousel.dart';

class StoreScreen extends StatefulWidget {
  final String currentUserEmail;

  const StoreScreen({super.key, required this.currentUserEmail});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final rawData = await rootBundle.loadString('assets/products.csv');
    final csvTable = const CsvToListConverter().convert(rawData);

    final headers = csvTable.first.cast<String>();

    final list = csvTable.skip(1).map((row) {
      return Map<String, dynamic>.fromIterables(headers, row);
    }).toList();

    setState(() => _products = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mağaza"),
        backgroundColor: Colors.teal,
      ),
      body: _products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Sepet Önizleme
                  const CartPreview(),

                  const SizedBox(height: 30),

                  // 🔹 Önerilen ürünler
                  const Text(
                    "Sizin İçin Önerdiklerimiz",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SuggestedProductsCarousel(),

                  const SizedBox(height: 30),

                  // 🔹 Tüm ürünler başlığı
                  const Text(
                    "Tüm Ürünler",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // 🔹 Grid olarak ürün listesi
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.68,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, i) {
                      final p = _products[i];

                      return ProductCard(
                        name: p['name'],
                        price: double.parse(p['price'].toString()),
                        category: p['category'],
                        image: p['image'],
                        onAddToCart: () {
                          print("Sepete eklendi: ${p['name']}");
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
