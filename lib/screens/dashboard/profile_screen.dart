import 'package:flutter/material.dart';
import 'package:oy_site/models/app_user.dart';

class ProfileScreen extends StatelessWidget {
  final AppUser currentUser;

  const ProfileScreen({
    super.key,
    required this.currentUser,
  });

  String _buildClinicText() {
    final clinicName = (currentUser.clinicName ?? '').trim();
    final clinicType = (currentUser.clinicType ?? '').trim();

    if (clinicName.isEmpty && clinicType.isEmpty) {
      return 'Bağlı klinik bilgisi yok';
    }

    if (clinicName.isNotEmpty && clinicType.isNotEmpty) {
      return '$clinicName ($clinicType)';
    }

    return clinicName.isNotEmpty ? clinicName : clinicType;
  }

  String _buildPhoneText() {
    final phone = (currentUser.phone ?? '').trim();
    return phone.isEmpty ? 'Telefon bilgisi yok' : phone;
  }

  String _buildTitleText() {
    final title = (currentUser.title ?? '').trim();
    return title.isEmpty ? 'Unvan bilgisi yok' : title;
  }

  String _buildCommissionProfileText() {
    final value = (currentUser.commissionProfileName ?? '').trim();
    return value.isEmpty ? 'Komisyon profili tanımlı değil' : value;
  }

  String _buildStatusText() {
    return currentUser.isActive ? 'Aktif kullanıcı' : 'Pasif kullanıcı';
  }

  Color _buildStatusColor() {
    return currentUser.isActive ? Colors.green : Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 70, color: Colors.white),
            ),

            const SizedBox(height: 20),

            Text(
              currentUser.displayName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              currentUser.email,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              currentUser.roleName,
              style: TextStyle(
                color: Colors.teal.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            _buildInfoCard(
              icon: Icons.badge,
              title: 'Ad Soyad',
              value: currentUser.fullName,
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.workspace_premium,
              title: 'Unvan',
              value: _buildTitleText(),
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.email,
              title: 'E-posta',
              value: currentUser.email,
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.phone,
              title: 'Telefon',
              value: _buildPhoneText(),
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.admin_panel_settings,
              title: 'Rol',
              value: '${currentUser.roleName} (${currentUser.roleCode})',
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.local_hospital,
              title: 'Klinik',
              value: _buildClinicText(),
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.payments_outlined,
              title: 'Komisyon Profili',
              value: _buildCommissionProfileText(),
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.verified_user,
              title: 'Hesap Durumu',
              value: _buildStatusText(),
              valueColor: _buildStatusColor(),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            _buildSettingsButton(
              icon: Icons.lock,
              text: 'Şifre Değiştir',
              onTap: () {},
            ),

            const SizedBox(height: 12),

            _buildSettingsButton(
              icon: Icons.logout,
              text: 'Çıkış yap',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 35, color: Colors.teal),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
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
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}