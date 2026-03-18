import 'package:flutter/material.dart';
import 'package:oy_site/screens/dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;

  final String allowedEmail = "testuser@example.com";

  void _login() {
    final email = _emailController.text.trim();

    if (email == allowedEmail) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(currentUserEmail: email),
        ),
      );
    } else {
      setState(() {
        _errorMessage = "Geçersiz e-posta. Sadece test kullanıcı girişi aktiftir.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Giriş Yap",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "E-posta",
                  hintText: "testuser@example.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: _errorMessage,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Giriş Yap",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
