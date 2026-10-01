import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Wraps the application in a realistic smartphone bezel when viewed on
/// wider screens (such as laptops or desktop browsers).
/// On native mobile devices or narrow screens, it seamlessly renders full screen.
class MobileFrame extends StatelessWidget {
  final Widget child;

  const MobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // On native mobile platforms (Android / iOS devices), render native full screen
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      return child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // If the viewport is already mobile-sized (<= 520px wide), render full screen
        if (constraints.maxWidth <= 520) {
          return child;
        }

        // On laptop/desktop screens, render inside a modern smartphone casing
        final double phoneHeight = (constraints.maxHeight - 48).clamp(650.0, 844.0);
        final double phoneWidth = (phoneHeight * 0.47).clamp(360.0, 395.0);

        return Scaffold(
          backgroundColor: const Color(0xFF070B10),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Laptop preview badge
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.phone_iphone_rounded, size: 16, color: Color(0xFF10B981)),
                          SizedBox(width: 8),
                          Text(
                            "Mobil Cihaz Görünümü (390 x 844)",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Phone Chassis Mockup
                    Container(
                      width: phoneWidth,
                      height: phoneHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E1318),
                        borderRadius: BorderRadius.circular(48),
                        border: Border.all(
                          color: const Color(0xFF2D3748),
                          width: 8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 50,
                            spreadRadius: 8,
                            offset: const Offset(0, 20),
                          ),
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            blurRadius: 70,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Stack(
                          children: [
                            // The Flutter App Screen
                            Positioned.fill(child: child),

                            // Dynamic Island / Camera Notch Pill (purely visual)
                            Positioned(
                              top: 8,
                              left: 0,
                              right: 0,
                              child: IgnorePointer(
                                child: Center(
                                  child: Container(
                                    width: 100,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          margin: const EdgeInsets.only(right: 12),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF1F2937),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
