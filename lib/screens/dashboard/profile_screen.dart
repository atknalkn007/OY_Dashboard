import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String currentUserEmail;

  const ProfileScreen({
    super.key,
    required this.currentUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 70, color: Colors.white),
            ),

            const SizedBox(height: 20),

            Text(
              currentUserEmail,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Text(
              "Kullanıcı Bilgileri ve Hesap Ayarları",
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 30),

            // --- PROFILE INFO CARD ---
            _buildInfoCard(
              icon: Icons.email,
              title: "E-posta",
              value: currentUserEmail,
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.calendar_month,
              title: "Son Analiz",
              value: "Henüz analiz verisi çekilmedi",
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.shopping_bag,
              title: "Toplam Sipariş",
              value: "0 adet",
            ),

            const SizedBox(height: 16),

            // --- SETTINGS ---
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            _buildSettingsButton(
              icon: Icons.lock,
              text: "Şifre Değiştir",
              onTap: () {},
            ),

            const SizedBox(height: 12),

            _buildSettingsButton(
              icon: Icons.logout,
              text: "Çıkış yap",
              onTap: () {
                Navigator.pop(context); // login'e döner
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- PROFILE INFO CARD ---
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 35, color: Colors.teal),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SETTINGS BUTTON ---
  Widget _buildSettingsButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
