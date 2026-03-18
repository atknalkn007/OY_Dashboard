import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key, required String currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Kontrol Paneli",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
