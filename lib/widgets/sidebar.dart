import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const Sidebar({
    super.key,
    required this.onItemSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.grey[200],
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "OY Dashboard",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),

          // Menü öğeleri
          _buildMenuItem(Icons.person, "Profil", 0),
          _buildMenuItem(Icons.analytics, "Ayak Analizi", 1),
          _buildMenuItem(Icons.shopping_bag, "Siparişler", 2),
          _buildMenuItem(Icons.storefront, "Mağaza", 3),
          _buildMenuItem(Icons.help_outline, "Destek", 4),
          _buildMenuItem(Icons.speed, "Basınç Ölçüm", 5), // <-- yeni sekme
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    final bool isActive = selectedIndex == index;

    return Container(
      color: isActive ? Colors.teal.withOpacity(0.15) : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.teal : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.teal : Colors.black,
          ),
        ),
        onTap: () => onItemSelected(index),
      ),
    );
  }
}