import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LiquidGlassRouteCard extends StatelessWidget {
  final String routeName;
  final String origin;
  final String destination;
  final double fare;
  final VoidCallback onTap;

  const LiquidGlassRouteCard({
    super.key,
    required this.routeName,
    required this.origin,
    required this.destination,
    required this.fare,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF).withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFFFFFF).withOpacity(0.15),
                width: 0.5,
              ),
            ),
            child: CupertinoButton(
              padding: const EdgeInsets.all(16),
              onPressed: () {
                HapticFeedback.selectionClick();
                onTap();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routeName,
                          style: GoogleFonts.inter(
                            color: CupertinoColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$origin → $destination',
                          style: GoogleFonts.inter(
                            color: CupertinoColors.systemGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₱${fare.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      color: CupertinoColors.systemGreen,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
