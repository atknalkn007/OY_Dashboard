import 'package:flutter/material.dart';
import 'package:oy_site/models/app_user.dart';

class Topbar extends StatelessWidget {
  final AppUser currentUser;

  const Topbar({
    super.key,
    required this.currentUser,
  });

  String _getSubtitle() {
    final roleName = currentUser.roleName.trim();
    final clinicName = (currentUser.clinicName ?? '').trim();

    if (clinicName.isNotEmpty) {
      return '$roleName • $clinicName';
    }

    return roleName;
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _getSubtitle();

    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Kontrol Paneli',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currentUser.displayName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    currentUser.email,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              const CircleAvatar(
                radius: 18,
                child: Icon(Icons.person),
              ),
            ],
          ),
        ],
      ),
    );
  }
}