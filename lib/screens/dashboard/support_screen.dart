import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  final String currentUserEmail;

  const SupportScreen({super.key, required this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Destek Merkezi"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.support_agent, size: 80, color: Colors.indigo),
            const SizedBox(height: 20),

            Text(
              "Merhaba, $currentUserEmail",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            const Text(
              "Yardıma mı ihtiyacın var? Aşağıdaki seçeneklerden birini seçebilirsin.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            _buildSupportCard(
              context,
              icon: Icons.question_answer,
              title: "Sık Sorulan Sorular",
              subtitle: "En çok sorulan soruların cevaplarına göz at.",
              onTap: () {},
            ),

            const SizedBox(height: 16),

            _buildSupportCard(
              context,
              icon: Icons.bug_report,
              title: "Sorun Bildir",
              subtitle:
                  "Yaşadığın bir problemi detaylı şekilde bize ilet.",
              onTap: () {},
            ),

            const SizedBox(height: 16),

            _buildSupportCard(
              context,
              icon: Icons.email,
              title: "Bize Ulaş",
              subtitle: "support@oy.com adresine mail gönderebilirsin.",
              onTap: () {},
            ),

            const SizedBox(height: 24),

            const Text(
              "En kısa sürede geri dönüş yapacağız.",
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0, 2),
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.teal),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
