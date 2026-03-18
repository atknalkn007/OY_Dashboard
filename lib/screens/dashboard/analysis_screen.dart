import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import 'package:oy_site/models/foot_profile.dart';
import 'package:oy_site/services/recommendation_engine.dart';

import '../../widgets/measurement_card.dart';
import '../../widgets/trend_chart.dart';
import '../../widgets/recommendation_side_card.dart';

class AnalysisScreen extends StatefulWidget {
  final String currentUserEmail;

  const AnalysisScreen({super.key, required this.currentUserEmail});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<FootProfile> _profiles = [];
  Map<String, Map<String, dynamic>> _products = {};

  bool _isLoadingAnalysis = true;
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _loadCsvData();
    _loadProducts();
  }

  // ─────────────────────────────────────────────
  //  TARİH PARSER (2025/3/15 13:41 formatı)
  // ─────────────────────────────────────────────
  DateTime _parseScanTime(String raw) {
    try {
      final parts = raw.split(' ');
      final dateP = parts[0].split('/');
      final timeP = parts[1].split(':');

      return DateTime(
        int.parse(dateP[0]),
        int.parse(dateP[1]),
        int.parse(dateP[2]),
        int.parse(timeP[0]),
        int.parse(timeP[1]),
      );
    } catch (e) {
      debugPrint("⛔ ScanTime parse ERROR: $raw");
      return DateTime.now();
    }
  }

  // ─────────────────────────────────────────────
  //  CSV YÜKLEYİCİ
  // ─────────────────────────────────────────────
  Future<void> _loadCsvData() async {
    debugPrint("\n========== CSV LOAD START ==========");

    try {
      final rawData = await rootBundle.loadString('assets/foot_measurements.csv');
      final csvTable = const CsvToListConverter(eol: '\n').convert(rawData);

      if (csvTable.isEmpty) {
        debugPrint("❌ CSV EMPTY");
        setState(() => _isLoadingAnalysis = false);
        return;
      }

      final headers = csvTable.first.cast<String>();
      final rows = csvTable.skip(1).map((row) {
        return Map<String, dynamic>.fromIterables(headers, row);
      }).toList();

      // Kullanıcıya göre filtrele
      final userEmail = widget.currentUserEmail.trim().toLowerCase();

      final userRows = rows.where((r) {
        return (r["user_email"] ?? "")
            .toString()
            .trim()
            .toLowerCase() == userEmail;
      }).toList();

      debugPrint("→ USER ROW COUNT = ${userRows.length}");

      // Sol–sağ ayırıcı map’ler
      final leftRows = <String, Map<String, dynamic>>{};
      final rightRows = <String, Map<String, dynamic>>{};

      for (final row in userRows) {
        final rawSide = (row["foot_type"] ?? "").toString().trim().toUpperCase();
        final scanTimeRaw = (row["ScanTime"] ?? "").toString().trim();

        if (scanTimeRaw.isEmpty) continue;

        String? side;
        if (rawSide == "L") side = "left";
        if (rawSide == "R") side = "right";

        if (side == null) {
          debugPrint("⚠ UNKNOWN foot_type: $rawSide");
          continue;
        }

        if (side == "left") {
          leftRows[scanTimeRaw] = row;
        } else {
          rightRows[scanTimeRaw] = row;
        }
      }

      debugPrint("→ LEFT COUNT = ${leftRows.length}");
      debugPrint("→ RIGHT COUNT = ${rightRows.length}");

      // Eşleşmiş çiftlerden FootProfile oluştur
      final List<FootProfile> profiles = [];

      for (final timeKey in leftRows.keys) {
        if (rightRows.containsKey(timeKey)) {
          final l = leftRows[timeKey]!;
          final r = rightRows[timeKey]!;

          final parsedDate = _parseScanTime(timeKey);

          final profile = FootProfile.fromPair(l, r).copyWithDate(parsedDate);
          profiles.add(profile);
        }
      }

      profiles.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        _profiles = profiles;
        _isLoadingAnalysis = false;
      });

      debugPrint("→ PROFILE COUNT = ${profiles.length}");
      debugPrint("========== CSV LOAD END ==========\n");

    } catch (e) {
      debugPrint("❌ CSV LOAD ERROR: $e");
      setState(() => _isLoadingAnalysis = false);
    }
  }

  // ─────────────────────────────────────────────
  //  PRODUCT CSV LOAD
  // ─────────────────────────────────────────────
  Future<void> _loadProducts() async {
    try {
      final raw = await rootBundle.loadString("assets/products.csv");
      final table = const CsvToListConverter(eol: '\n').convert(raw);

      if (table.isEmpty) {
        setState(() => _isLoadingProducts = false);
        return;
      }

      final headers = table.first.cast<String>();

      final productMap = <String, Map<String, dynamic>>{};
      for (final row in table.skip(1)) {
        final item = Map<String, dynamic>.fromIterables(headers, row);
        final id = item["product_id"]?.toString();

        if (id != null && id.isNotEmpty) {
          productMap[id] = item;
        }
      }

      setState(() {
        _products = productMap;
        _isLoadingProducts = false;
      });
    } catch (e) {
      debugPrint("❌ PRODUCT CSV ERROR: $e");
      setState(() => _isLoadingProducts = false);
    }
  }

  // ─────────────────────────────────────────────
  //  UI
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_isLoadingAnalysis) return _loadingScreen();
    if (_profiles.isEmpty) return _emptyScreen();

    final latest = _profiles.last;

    // Trend veri serileri
    final archLeft = _profiles.map((p) => p.leftArchHeight).toList();
    final archRight = _profiles.map((p) => p.rightArchHeight).toList();

    final lenLeft = _profiles.map((p) => p.leftLength).toList();
    final lenRight = _profiles.map((p) => p.rightLength).toList();

    // Öneri motoru
    Map<String, dynamic>? mainProduct;
    List<Map<String, dynamic>> addonProducts = [];
    String reason = "";

    if (!_isLoadingProducts && _products.isNotEmpty) {
      final pack = RecommendationEngine.generate(latest);

      mainProduct = _products[pack.mainProductId];
      addonProducts = pack.addonProductIds
          .map((id) => _products[id])
          .whereType<Map<String, dynamic>>()
          .toList();
      reason = pack.reason;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayak Analizi"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sol taraf
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _buildHistoryCards(),
                  const SizedBox(height: 24),
                  TrendChart(
                    title: "Kavis Yüksekliği Zaman İçinde",
                    pointsLeft: archLeft,
                    pointsRight: archRight,
                  ),
                  const SizedBox(height: 24),
                  TrendChart(
                    title: "Ayak Uzunluğu Zaman İçinde",
                    pointsLeft: lenLeft,
                    pointsRight: lenRight,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 24),

            // Sağ taraf (öneri kartı)
            SizedBox(
              width: 320,
              child: (_isLoadingProducts || mainProduct == null)
                  ? const SizedBox.shrink()
                  : RecommendationSideCard(
                      mainProduct: mainProduct,
                      addons: addonProducts,
                      reason: reason,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  Widget _loadingScreen() => Scaffold(
        appBar: AppBar(title: const Text("Ayak Analizi")),
        body: const Center(child: CircularProgressIndicator()),
      );

  Widget _emptyScreen() => Scaffold(
        appBar: AppBar(title: const Text("Ayak Analizi")),
        body: const Center(child: Text("Bu kullanıcıya ait analiz bulunamadı.")),
      );

  Widget _buildHistoryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ölçüm Geçmişi",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _profiles
                .map((p) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: MeasurementCard(
                        profile: p,
                        products: _products,
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
