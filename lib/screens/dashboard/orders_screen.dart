import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  final String currentUserEmail;

  const OrdersScreen({super.key, required this.currentUserEmail});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final rawData = await rootBundle.loadString('assets/orders.csv');
      final csvTable = const CsvToListConverter(eol: '\n').convert(rawData);

      final headers = csvTable.first.cast<String>();
      print("CSV HEADERS: $headers");

      final List<Map<String, dynamic>> allOrders =
          csvTable.skip(1).map((row) {
        return Map<String, dynamic>.fromIterables(headers, row);
      }).toList();

      print("FIRST ORDER MAP: ${allOrders.first}");

      final email = widget.currentUserEmail.trim().toLowerCase();

      final filtered = allOrders.where((order) {
        final orderMail = order['user_email']?.toString().trim().toLowerCase();
        return orderMail == email;
      }).toList();

      setState(() {
        _orders = filtered;
        _isLoading = false;
      });
    } catch (e) {
      print("Order CSV ERROR: $e");
      setState(() {
        _isLoading = false;
        _orders = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Siparişlerim"),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(
                  child: Text(
                    "Bu kullanıcıya ait sipariş bulunamadı.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final o = _orders[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: OrderCard(
                        orderId: o['order_id']?.toString() ?? "-",
                        date: o['date']?.toString() ?? "-",
                        productName: o['product_name']?.toString() ?? "-",
                        price:
                            double.tryParse(o['price']?.toString() ?? "0") ??
                                0.0,
                        status: o['status']?.toString() ?? "unknown",
                        trackingCode:
                            o['tracking_code']?.toString() ?? "—",
                        userEmail: o['user_email']?.toString() ?? "",
                      ),
                    );
                  },
                ),
    );
  }
}
