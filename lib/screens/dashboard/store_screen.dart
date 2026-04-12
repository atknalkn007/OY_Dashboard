import 'package:flutter/material.dart';
import 'package:oy_site/screens/dashboard/store_product_detail_screen.dart';

class StoreScreen extends StatelessWidget {
  final String currentUserEmail;

  const StoreScreen({
    super.key,
    required this.currentUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    final measurement = StoreMeasurementSummary(
      sessionCode: 'SES-2026-0408',
      analysisDate: DateTime(2026, 4, 8),
      locationLabel: 'OptiYou İzmir',
      shortMessage:
          'Bu sayfadaki ürünler son ölçüm verilerinize göre hazırlanacaktır.',
    );

    final products = [
      StoreProduct(
        id: 'custom-insole',
        title: 'Kişisel İç Tabanlık',
        shortDescription:
            'Günlük kullanım için kişiye özel destek ve konfor sağlar.',
        fullDescription:
            'Kişisel İç Tabanlık, son ölçüm verilerinize göre ayağınıza özel olarak tasarlanır. Günlük kullanımda basınç dağılımını iyileştirmeye, konforu artırmaya ve ayak yapınıza uygun destek sunmaya yardımcı olur.',
        usageTitle: 'Kimler için uygun?',
        usageDescription:
            'Uzun süre ayakta kalan, günlük konforunu artırmak isteyen ve kişisel destek ihtiyacı bulunan kullanıcılar için uygundur.',
        whyRecommended:
            'Son ölçümünüzde kemer desteği ihtiyacı ve yük dağılımında dengesizlik görüldüğü için bu ürün önerilmektedir.',
        priceLabel: '4.000 TL',
        icon: Icons.accessibility_new,
        imagePath: 'assets/images/products/custom_insole.png',
      ),
      StoreProduct(
        id: 'sport-insole',
        title: 'Spor İç Tabanlığı',
        shortDescription:
            'Hareketli yaşam ve spor kullanımı için dinamik destek sunar.',
        fullDescription:
            'Spor İç Tabanlığı, yürüyüş, antrenman ve aktif kullanım için destekleyici yapı sunar. Ayağın yük dağılımını daha dengeli hale getirmeye yardımcı olurken hareket sırasında konforun korunmasını hedefler.',
        usageTitle: 'Kimler için uygun?',
        usageDescription:
            'Daha aktif yaşam tarzına sahip, spor yapan veya gün içinde daha yüksek hareket yoğunluğuna sahip kullanıcılar için uygundur.',
        whyRecommended:
            'Son ölçümünüzde hareket sırasında destek ihtiyacı öngörüldüğü için spor kullanımı için bu ürün önerilmektedir.',
        priceLabel: '4.500 TL',
        icon: Icons.directions_run,
        imagePath: 'assets/images/products/sport_insole.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mağaza'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildMeasurementCard(
                  measurement: measurement,
                  compact: true,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ürünler',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aşağıdaki ürünler son ölçüm verilerinize göre hazırlanır.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: products.map((product) {
                    return StoreProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreProductDetailScreen(
                              product: product,
                              measurement: measurement,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildMeasurementCard({
  required StoreMeasurementSummary measurement,
  required bool compact,
}) {
  return Container(
    width: compact ? 420 : double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
        ),
      ],
      border: Border.all(
        color: Colors.teal.withOpacity(0.12),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.teal.withOpacity(0.12),
              child: const Icon(
                Icons.fact_check_outlined,
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Son Ölçüm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        buildMeasurementKeyValueRow('Session', measurement.sessionCode),
        buildMeasurementKeyValueRow('Tarih', measurement.formattedDate),
        buildMeasurementKeyValueRow('Yer', measurement.locationLabel),
        const SizedBox(height: 10),
        Text(
          measurement.shortMessage,
          style: TextStyle(
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}

Widget buildMeasurementKeyValueRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        SizedBox(
          width: 68,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

class StoreProductCard extends StatelessWidget {
  final StoreProduct product;
  final VoidCallback onTap;

  const StoreProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 330,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.grey.shade100,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          product.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(
                          product.icon,
                          size: 14,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.shortDescription,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              product.priceLabel,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black38,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StoreMeasurementSummary {
  final String sessionCode;
  final DateTime analysisDate;
  final String locationLabel;
  final String shortMessage;

  const StoreMeasurementSummary({
    required this.sessionCode,
    required this.analysisDate,
    required this.locationLabel,
    required this.shortMessage,
  });

  String get formattedDate {
    return '${analysisDate.day.toString().padLeft(2, '0')}.'
        '${analysisDate.month.toString().padLeft(2, '0')}.'
        '${analysisDate.year}';
  }
}

class StoreProduct {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String usageTitle;
  final String usageDescription;
  final String whyRecommended;
  final String priceLabel;
  final IconData icon;
  final String imagePath;

  const StoreProduct({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.usageTitle,
    required this.usageDescription,
    required this.whyRecommended,
    required this.priceLabel,
    required this.icon,
    required this.imagePath,
  });
}