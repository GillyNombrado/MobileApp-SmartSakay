import 'package:flutter/material.dart';
import '../history_manager.dart';
import 'auth/animated_auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    addHistory("Splash Screen");

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AnimatedAuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1EC6A4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/Energy-removebg-preview.png",
              width: 140,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.directions_bus, size: 100, color: Colors.white);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "SMART SAKAY",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(blurRadius: 10, color: Colors.black26, offset: Offset(2, 2))
                ],
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Your Smart Transport Guide",
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}