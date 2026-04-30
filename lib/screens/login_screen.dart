// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../auth_service.dart';
import '../history_manager.dart';
import '../toast_helper.dart';
import 'map_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Empty field check
    if (username.isEmpty || password.isEmpty) {
      ToastHelper.show(context, 'Input required', isError: true);
      return;
    }

    final error = AuthService.instance.login(username, password);

    if (error == 'user_not_found') {
      ToastHelper.show(context, 'Username does not exist.', isError: true);
      return;
    }
    if (error == 'wrong_password') {
      ToastHelper.show(context, 'Invalid username or password.', isError: true);
      return;
    }

    addHistory('Login: $username');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MapScreen()),
    );
  }

  Widget logo() => Image.asset('assets/Energy-removebg-preview.png', width: 60);

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

  Widget _actionButton(String text, VoidCallback onTap,
      {bool filled = true}) {
    return _HoverButton(text: text, onTap: onTap, filled: filled);
  }

  @override
  Widget build(BuildContext context) {
    addHistory('Login Screen');

    return Scaffold(
      backgroundColor: const Color(0xFF1EC6A4),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              logo(),
              const SizedBox(height: 10),
              const Text(
                'Welcome Back!',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
              inputField('Username', _usernameController),
              inputField('Password', _passwordController, obscureText: true),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _actionButton('Login', _handleLogin),
                  const SizedBox(width: 12),
                  _actionButton(
                    'Sign Up',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    ),
                    filled: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable hover-aware button
// ---------------------------------------------------------------------------

class _HoverButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool filled;

  const _HoverButton({
    required this.text,
    required this.onTap,
    this.filled = true,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // Filled button: white → light grey on hover → slightly darker on press
    // Outlined button: transparent → white10 on hover → white20 on press
    final Color bg = widget.filled
        ? (_pressed
            ? const Color(0xFFD0D0D0)
            : _hovered
                ? const Color(0xFFE8E8E8)
                : Colors.white)
        : (_pressed
            ? const Color.fromRGBO(255, 255, 255, 0.22)
            : _hovered
                ? const Color.fromRGBO(255, 255, 255, 0.12)
                : Colors.transparent);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: widget.filled
                ? null
                : Border.all(color: Colors.white, width: 1.5),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.filled ? Colors.black87 : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}