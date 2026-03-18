import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OYDashboardApp());
}

class OYDashboardApp extends StatelessWidget {
  const OYDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OY Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),

      // Başlangıç ekranı
      home: const LoginScreen(),

      // Route yapısı (Dashboard email ister)
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final email = settings.arguments as String?;

          return MaterialPageRoute(
            builder: (_) => DashboardScreen(currentUserEmail: email ?? "unknown@example.com"),
          );
        }

        return MaterialPageRoute(builder: (_) => const LoginScreen());
      },
    );
  }
}
