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
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final rawData = await rootBundle.loadString('assets/products.csv');
      final csvTable = const CsvToListConverter(
        shouldParseNumbers: false,
        eol: '\n',
      ).convert(rawData);

      if (csvTable.isEmpty) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final headers = csvTable.first.cast<String>();
      final list = csvTable
          .skip(1)
          .where((row) => row.length == headers.length)
          .map((row) =>
              Map<String, dynamic>.fromIterables(headers, row))
          .toList();

      if (mounted) setState(() {
        _products = list;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('StoreScreen: product load error: $e');
      if (mounted) setState(() {
        _isLoading = false;
        _loadError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mağaza"),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      const Text('Ürünler yüklenemedi.',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(_loadError!,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                )
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
