// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import '../auth_service.dart';
import '../history_manager.dart';
import '../toast_helper.dart';
import 'map_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (username.isEmpty || password.isEmpty || confirm.isEmpty) {
      ToastHelper.show(context, 'Input required', isError: true);
      return;
    }
    if (username.length < 3) {
      ToastHelper.show(context, 'Username must be at least 3 characters', isError: true);
      return;
    }
    if (password.length < 6) {
      ToastHelper.show(context, 'Password must be at least 6 characters', isError: true);
      return;
    }
    if (confirm != password) {
      ToastHelper.show(context, 'Passwords do not match', isError: true);
      return;
    }

    final error = AuthService.instance.register(username, password);

    if (error == 'username_taken') {
      ToastHelper.show(context, 'Username already taken.', isError: true);
      return;
    }

    AuthService.instance.login(username, password);

    ToastHelper.show(
      context,
      'Account created! Welcome 🎉',
      isError: false,
      duration: const Duration(seconds: 2),
    );

    addHistory('Signup: $username');

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TransportScreen()),
        );
      }
    });
  }

  Widget inputField(
    String hint,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    addHistory('Signup Screen');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1EC6A4), Color(0xFF0FA3B1)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/Energy-removebg-preview.png', width: 90),
                const SizedBox(height: 10),
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                inputField('Username', _usernameController),
                inputField('Password', _passwordController, obscureText: true),
                inputField('Confirm Password', _confirmController, obscureText: true),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _handleSignup,
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SURVEY PAGES
// ---------------------------------------------------------------------------

class TransportScreen extends StatelessWidget {
  const TransportScreen({super.key});

  Widget logo() =>
      Image.asset("assets/Energy-removebg-preview.png", width: 60);

  Widget button(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        addHistory("Transport: $text");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ModeScreen()),
        );
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    addHistory("Transport Screen");
    return Scaffold(
      backgroundColor: const Color(0xFF1EC6A4),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            logo(),
            const SizedBox(height: 10),
            const Text(
              "What Guidance do you Seek?",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            button(context, "Travel"),
            button(context, "Find Route"),
            button(context, "View Map"),
          ],
        ),
      ),
    );
  }
}

class ModeScreen extends StatelessWidget {
  const ModeScreen({super.key});

  Widget logo() =>
      Image.asset("assets/Energy-removebg-preview.png", width: 60);

  Widget button(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        addHistory("Mode: $text");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MapScreen()),
        );
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    addHistory("Mode Screen");
    return Scaffold(
      backgroundColor: const Color(0xFF1EC6A4),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            logo(),
            const Text(
              "Choose transport mode",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            button(context, "Tricycle"),
            button(context, "Jeep"),
            button(context, "Bus"),
            button(context, "Train"),
          ],
        ),
      ),
    );
  }
}