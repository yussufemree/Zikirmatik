import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_settings.dart';
import '../services/localization_service.dart';
import '../services/qibla_service.dart';
import '../services/sound_haptic_service.dart';

class QiblaScreen extends StatefulWidget {
  final String languageCode;
  final SoundHapticService soundHapticService;

  const QiblaScreen({
    super.key,
    required this.languageCode,
    required this.soundHapticService,
  });

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  late CityLocation _currentCity;
  double _currentHeading = 0.0; // Simulated or device heading in degrees
  late double _qiblaAngle;
  late double _distanceKm;
  bool _hasTriggeredHaptic = false;

  @override
  void initState() {
    super.initState();
    _currentCity = QiblaService.defaultCity;
    _recalculate();
  }

  void _recalculate() {
    _qiblaAngle = QiblaService.calculateQiblaDirection(
      _currentCity.latitude,
      _currentCity.longitude,
    );
    _distanceKm = QiblaService.calculateDistanceKm(
      _currentCity.latitude,
      _currentCity.longitude,
    );
  }

  void _onCitySelected(CityLocation city) {
    setState(() {
      _currentCity = city;
      _recalculate();
      _hasTriggeredHaptic = false;
    });
  }

  void _showCityPicker() {
    final lang = widget.languageCode;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocalizationService.get('selectCity', lang),
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white54),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: QiblaService.popularCities.length,
                  itemBuilder: (context, index) {
                    final city = QiblaService.popularCities[index];
                    final isSelected = city.name == _currentCity.name;
                    final cityAngle = QiblaService.calculateQiblaDirection(
                      city.latitude,
                      city.longitude,
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                              : Colors.white10,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on_rounded,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white38,
                          size: 22,
                        ),
                        title: Text(
                          city.name,
                          style: GoogleFonts.outfit(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          city.country,
                          style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12),
                        ),
                        trailing: Text(
                          "${cityAngle.toStringAsFixed(0)}°",
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(ctx);
                          _onCitySelected(city);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final lang = widget.languageCode;

    // Angle difference between current heading and Qibla angle
    final double diff = (_currentHeading - _qiblaAngle).abs();
    final double angleDiff = diff > 180 ? 360 - diff : diff;
    final bool isAligned = angleDiff <= 4.0;

    if (isAligned && !_hasTriggeredHaptic) {
      _hasTriggeredHaptic = true;
      widget.soundHapticService.triggerHaptic(VibrationStrength.medium);
    } else if (!isAligned && _hasTriggeredHaptic) {
      _hasTriggeredHaptic = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.get('tabQibla', lang)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            // Selected City Card with Change Button
            InkWell(
              onTap: _showCityPicker,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_currentCity.name}, ${_currentCity.country}",
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${_currentCity.latitude.toStringAsFixed(2)}° N, ${_currentCity.longitude.toStringAsFixed(2)}° E",
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primary.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        LocalizationService.get('change', lang),
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Alignment Status Alert Banner
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isAligned
                    ? primary.withValues(alpha: 0.22)
                    : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isAligned ? primary : Colors.white12,
                  width: isAligned ? 2.0 : 1.0,
                ),
                boxShadow: isAligned
                    ? [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isAligned ? Icons.check_circle_rounded : Icons.explore_rounded,
                    color: isAligned ? primary : secondary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isAligned
                          ? LocalizationService.get('facingQibla', lang)
                          : LocalizationService.get('turnPhone', lang),
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isAligned ? primary : Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isAligned ? primary : secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${_qiblaAngle.toStringAsFixed(0)}°",
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isAligned ? Colors.black : secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Luxury 3D Qibla Compass Dial (Draggable & Interactive)
            GestureDetector(
              onPanUpdate: (details) {
                // Allow interactive rotation by touch/drag
                setState(() {
                  _currentHeading = (_currentHeading + details.delta.dx * 0.4) % 360.0;
                  if (_currentHeading < 0) _currentHeading += 360.0;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Atmospheric Ambient Glow when aligned
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isAligned
                              ? primary.withValues(alpha: 0.35)
                              : Colors.black.withValues(alpha: 0.5),
                          blurRadius: isAligned ? 50 : 20,
                          spreadRadius: isAligned ? 10 : 0,
                        ),
                      ],
                    ),
                  ),

                  // Outer Compass Housing
                  Container(
                    width: 290,
                    height: 290,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF16231C),
                          const Color(0xFF0C1310),
                          const Color(0xFF060907),
                        ],
                      ),
                      border: Border.all(
                        color: isAligned
                            ? primary
                            : const Color(0xFF2E3D34),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Rotating Compass Rose & Numbers
                        Transform.rotate(
                          angle: -_currentHeading * (pi / 180.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Dial ticks
                              CustomPaint(
                                size: const Size(290, 290),
                                painter: _CompassDialPainter(
                                  primaryColor: primary,
                                  accentColor: secondary,
                                  isAligned: isAligned,
                                ),
                              ),

                              // Cardinal Directions
                              const Positioned(
                                top: 22,
                                child: Text("N", style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w900, fontSize: 16)),
                              ),
                              const Positioned(
                                right: 24,
                                child: Text("E", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                              const Positioned(
                                bottom: 22,
                                child: Text("S", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                              const Positioned(
                                left: 24,
                                child: Text("W", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)),
                              ),

                              // Qibla Indicator Line & Golden Kaaba Needle
                              Transform.rotate(
                                angle: _qiblaAngle * (pi / 180.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Golden pointer towards Kaaba
                                    Positioned(
                                      top: 40,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD4AF37),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.mosque_rounded,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Container(
                                            width: 3,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  const Color(0xFFD4AF37),
                                                  const Color(0xFFD4AF37).withValues(alpha: 0.1),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Center Pivot Hub
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [Color(0xFF475569), Color(0xFF0F172A)],
                            ),
                            border: Border.all(
                              color: isAligned ? primary : const Color(0xFF94A3B8),
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.navigation_rounded,
                              size: 22,
                              color: isAligned ? primary : const Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Heading adjustment slider / touch hint
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: primary,
                inactiveTrackColor: Colors.white12,
                thumbColor: primary,
                trackHeight: 3,
              ),
              child: Slider(
                value: _currentHeading,
                min: 0.0,
                max: 360.0,
                onChanged: (val) {
                  setState(() => _currentHeading = val);
                },
              ),
            ),

            // Statistics Info Cards (Angle & Distance)
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.explore_rounded, color: primary, size: 22),
                          const SizedBox(height: 8),
                          Text(
                            "${_qiblaAngle.toStringAsFixed(1)}°",
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            LocalizationService.get('qiblaHeading', lang),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.near_me_rounded, color: secondary, size: 22),
                          const SizedBox(height: 8),
                          Text(
                            "${_distanceKm.toStringAsFixed(0)} km",
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            LocalizationService.get('distanceToKaaba', lang),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Helpful usage hint
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                LocalizationService.get('qiblaHint', lang),
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.white38,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the compass degree tick marks
class _CompassDialPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;
  final bool isAligned;

  _CompassDialPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.isAligned,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final tickPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0;

    final majorTickPaint = Paint()
      ..color = isAligned ? primaryColor : accentColor
      ..strokeWidth = 2.0;

    for (int i = 0; i < 360; i += 5) {
      final isMajor = i % 30 == 0;
      final isMedium = i % 15 == 0;
      final double tickLength = isMajor ? 12.0 : (isMedium ? 8.0 : 4.0);

      final rad = (i - 90) * (pi / 180.0);
      final p1 = Offset(
        center.dx + (radius - 12) * cos(rad),
        center.dy + (radius - 12) * sin(rad),
      );
      final p2 = Offset(
        center.dx + (radius - 12 - tickLength) * cos(rad),
        center.dy + (radius - 12 - tickLength) * sin(rad),
      );

      canvas.drawLine(p1, p2, isMajor ? majorTickPaint : tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) {
    return oldDelegate.isAligned != isAligned;
  }
}
