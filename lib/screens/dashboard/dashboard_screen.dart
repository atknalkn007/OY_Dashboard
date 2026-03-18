import 'package:flutter/material.dart';
import '/widgets/sidebar.dart';
import '/widgets/topbar.dart';

import 'profile_screen.dart';
import 'analysis_screen.dart';
import 'orders_screen.dart';
import 'store_screen.dart';
import 'support_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String currentUserEmail;

  const DashboardScreen({
    super.key,
    required this.currentUserEmail,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
        ProfileScreen(currentUserEmail: widget.currentUserEmail),
        AnalysisScreen(currentUserEmail: widget.currentUserEmail),
        OrdersScreen(currentUserEmail: widget.currentUserEmail),
        StoreScreen(currentUserEmail: widget.currentUserEmail),
        SupportScreen(currentUserEmail: widget.currentUserEmail),
      ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            onItemSelected: _onItemSelected,
            selectedIndex: _selectedIndex,
          ),

          Expanded(
            child: Column(
              children: [
                Topbar(currentUserEmail: widget.currentUserEmail),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
