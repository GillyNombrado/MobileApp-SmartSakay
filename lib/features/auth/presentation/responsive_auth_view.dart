// lib/features/auth/presentation/responsive_auth_view.dart
//
// High-fidelity, responsive iOS-native Auth UI for SmartSakay.
// • Dark theme  (Pure Black scaffold)
// • Glassmorphism inputs with BackdropFilter
// • Center + ConstrainedBox for wide-screen containment (max 450 px)
// • Hover scale/opacity on buttons (web-friendly)
// • isLoading guard with CupertinoActivityIndicator
// • MouseRegion cursor: SystemMouseCursors.click on all tappables

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive_layout.dart';
import '../../../core/database/drift_database.dart';
import '../../transit/data/transit_service.dart';
import '../../transit/presentation/cupertino_route_list_view.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

class ResponsiveAuthView extends StatefulWidget {
  const ResponsiveAuthView({super.key});

  @override
  State<ResponsiveAuthView> createState() => _ResponsiveAuthViewState();
}

// ── State ─────────────────────────────────────────────────────────────────────

class _ResponsiveAuthViewState extends State<ResponsiveAuthView> {
  // Controllers
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // UI state
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Handlers ────────────────────────────────────────────────────────────────

  Future<void> _handleSignIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    
    // Simulate auth logic
    await Future.delayed(const Duration(milliseconds: 1500)); 
    if (!mounted) return;
    
    setState(() => _isLoading = false);

    // Initialize DB and Service, then Navigate
    final db = AppDatabase();
    final transitService = TransitService(db);

    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => CupertinoRouteListView(
          transitService: transitService,
        ),
      ),
    );
  }

  void _handleForgotPassword() {
    // TODO: push ForgotPasswordView
  }

  void _handleCreateAccount() {
    // TODO: push SignUpView
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final layout = ResponsiveLayout.of(context);

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: CupertinoColors.systemBlue,
        textTheme: CupertinoTextThemeData(
          textStyle: GoogleFonts.inter(
            color: CupertinoColors.white,
            letterSpacing: -0.4,
          ),
        ),
      ),
      home: CupertinoPageScaffold(
        // No static navigation bar — we use a sliver one inside the scroll view.
        child: _AuthBody(
          layout: layout,
          emailCtrl: _emailCtrl,
          passwordCtrl: _passwordCtrl,
          isLoading: _isLoading,
          obscurePassword: _obscurePassword,
          onToggleObscure: () =>
              setState(() => _obscurePassword = !_obscurePassword),
          onSignIn: _handleSignIn,
          onForgotPassword: _handleForgotPassword,
          onCreateAccount: _handleCreateAccount,
        ),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _AuthBody extends StatelessWidget {
  final ResponsiveLayout layout;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final bool isLoading;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;
  final VoidCallback onForgotPassword;
  final VoidCallback onCreateAccount;

  const _AuthBody({
    required this.layout,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.isLoading,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignIn,
    required this.onForgotPassword,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Navigation Bar ─────────────────────────────────────────────────
        CupertinoSliverNavigationBar(
          largeTitle: Text(
            'SmartSakay',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              letterSpacing: -1.0,
              color: CupertinoColors.white,
            ),
          ),
          backgroundColor: const Color(0xFF000000),
          border: null,
        ),

        // ── Form Content ───────────────────────────────────────────────────
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: layout.authFormMaxWidth),
              child: Padding(
                padding: layout.padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Logo ───────────────────────────────────────────────
                    _LogoSection(layout: layout),
                    const SizedBox(height: 40),

                    // ── Input Section ──────────────────────────────────────
                    _GlassyTextField(
                      controller: emailCtrl,
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(
                        CupertinoIcons.mail,
                        size: 18,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _GlassyTextField(
                      controller: passwordCtrl,
                      placeholder: 'Password',
                      obscureText: obscurePassword,
                      prefix: const Icon(
                        CupertinoIcons.lock,
                        size: 18,
                        color: CupertinoColors.systemGrey,
                      ),
                      suffix: _ObscureToggle(
                        obscured: obscurePassword,
                        onToggle: onToggleObscure,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Forgot Password ────────────────────────────────────
                    Align(
                      alignment: Alignment.centerRight,
                      child: _TextLink(
                        label: 'Forgot Password?',
                        onTap: onForgotPassword,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Action Section ─────────────────────────────────────
                    isLoading
                        ? const Center(
                            child: CupertinoActivityIndicator(radius: 14),
                          )
                        : _PrimaryButton(
                            label: 'Sign In',
                            onTap: onSignIn,
                          ),
                    const SizedBox(height: 20),

                    // ── Create Account ─────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.inter(
                            color: CupertinoColors.systemGrey,
                            fontSize: 14,
                            letterSpacing: -0.4,
                          ),
                        ),
                        _TextLink(
                          label: 'Create Account',
                          onTap: onCreateAccount,
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // ── Footer ─────────────────────────────────────────────
                    Text(
                      'SmartSakay v1.0.0  •  © 2026',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: CupertinoColors.systemGrey2,
                        fontSize: 12,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Logo Section ──────────────────────────────────────────────────────────────

class _LogoSection extends StatelessWidget {
  final ResponsiveLayout layout;

  const _LogoSection({required this.layout});

  @override
  Widget build(BuildContext context) {
    final size = layout.logoDiameter;

    return Column(
      children: [
        // Glowing logo container
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF1EC6A4), Color(0xFF0A84FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1EC6A4).withOpacity(0.4),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(
            CupertinoIcons.location_fill,
            color: CupertinoColors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Welcome back.',
          style: GoogleFonts.inter(
            fontSize: layout.titleFontSize,
            fontWeight: FontWeight.w700,
            color: CupertinoColors.white,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Sign in to continue your journey.',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: CupertinoColors.systemGrey,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}

// ── Glassy Text Field ─────────────────────────────────────────────────────────

class _GlassyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefix;
  final Widget? suffix;

  const _GlassyTextField({
    required this.controller,
    required this.placeholder,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6.resolveFrom(context).withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: CupertinoColors.systemGrey.withOpacity(0.2),
              width: 0.5,
            ),
          ),
          child: CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            obscureText: obscureText,
            keyboardType: keyboardType,
            prefix: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: prefix,
            ),
            suffix: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: suffix,
                  )
                : null,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            placeholderStyle: GoogleFonts.inter(
              color: CupertinoColors.systemGrey,
              fontSize: 15,
              letterSpacing: -0.4,
            ),
            style: GoogleFonts.inter(
              color: CupertinoColors.white,
              fontSize: 15,
              letterSpacing: -0.4,
            ),
            decoration: const BoxDecoration(), // remove default decoration
          ),
        ),
      ),
    );
  }
}

// ── Password Obscure Toggle ───────────────────────────────────────────────────

class _ObscureToggle extends StatelessWidget {
  final bool obscured;
  final VoidCallback onToggle;

  const _ObscureToggle({required this.obscured, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onToggle,
        child: Icon(
          obscured ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
          color: CupertinoColors.systemGrey,
          size: 20,
        ),
      ),
    );
  }
}

// ── Primary Button ────────────────────────────────────────────────────────────

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.015 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: _hovered ? 0.92 : 1.0,
            duration: const Duration(milliseconds: 180),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A84FF), Color(0xFF0066CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0A84FF).withOpacity(0.35),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                widget.label,
                style: GoogleFonts.inter(
                  color: CupertinoColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Text Link ─────────────────────────────────────────────────────────────────

class _TextLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _TextLink({required this.label, required this.onTap});

  @override
  State<_TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<_TextLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: GoogleFonts.inter(
            color: _hovered
                ? CupertinoColors.systemBlue.withOpacity(0.75)
                : CupertinoColors.systemBlue,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.4,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
