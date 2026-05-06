import 'package:flutter/material.dart';
import 'views/intro_view.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';

class AnimatedAuthScreen extends StatefulWidget {
  const AnimatedAuthScreen({super.key});

  @override
  State<AnimatedAuthScreen> createState() => _AnimatedAuthScreenState();
}

class _AnimatedAuthScreenState extends State<AnimatedAuthScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0C6478), Color(0xFF213A58)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                IntroView(onStart: () => _navigateToPage(1)),
                LoginView(
                  onRegisterTap: () => _navigateToPage(2),
                  onBack: () => _navigateToPage(0),
                ),
                RegisterView(
                  onLoginTap: () => _navigateToPage(1),
                  onBack: () => _navigateToPage(1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
