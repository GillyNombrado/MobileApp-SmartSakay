// lib/core/responsive_layout.dart
//
// Lightweight screen-size helpers for SmartSakay.
// Usage:
//   final layout = ResponsiveLayout.of(context);
//   if (layout.isWide) { ... }

import 'package:flutter/widgets.dart';

/// Canonical breakpoints used throughout the app.
class Breakpoints {
  Breakpoints._();

  /// Anything below this is considered a mobile viewport.
  static const double mobile = 600.0;

  /// Anything below this is considered a tablet viewport.
  static const double tablet = 900.0;

  /// Max width for a centred auth "card" on wide screens.
  static const double authCardMaxWidth = 450.0;
}

/// Snapshot of layout-relevant values computed from [MediaQueryData].
class ResponsiveLayout {
  final double screenWidth;
  final double screenHeight;
  final EdgeInsets padding;

  const ResponsiveLayout({
    required this.screenWidth,
    required this.screenHeight,
    required this.padding,
  });

  // ── Factories ──────────────────────────────────────────────────────────────

  factory ResponsiveLayout.of(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    // Horizontal padding grows from 24 → 40 px as the viewport widens.
    final double hPad = w >= Breakpoints.mobile ? 40.0 : 24.0;
    final EdgeInsets pad = EdgeInsets.symmetric(horizontal: hPad, vertical: 24);

    return ResponsiveLayout(screenWidth: w, screenHeight: h, padding: pad);
  }

  // ── Convenience getters ────────────────────────────────────────────────────

  bool get isMobile => screenWidth < Breakpoints.mobile;
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;
  bool get isWide => screenWidth >= Breakpoints.tablet;

  /// Max width for the auth form — full-width on mobile, capped on wide screens.
  double get authFormMaxWidth =>
      isMobile ? double.infinity : Breakpoints.authCardMaxWidth;

  /// Logo diameter that scales proportionally with the viewport.
  double get logoDiameter {
    if (isMobile) return 72.0;
    if (isTablet) return 88.0;
    return 104.0;
  }

  /// Title font size.
  double get titleFontSize {
    if (isMobile) return 28.0;
    if (isTablet) return 32.0;
    return 36.0;
  }
}
