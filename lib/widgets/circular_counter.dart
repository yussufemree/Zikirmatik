import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/localization_service.dart';

class CircularCounter extends StatefulWidget {
  final int count;
  final int target;
  final VoidCallback onTap;
  final VoidCallback? onReset;
  final VoidCallback? onDecrement;
  final bool isFullScreen;
  final String languageCode;

  const CircularCounter({
    super.key,
    required this.count,
    required this.target,
    required this.onTap,
    this.onReset,
    this.onDecrement,
    this.isFullScreen = false,
    this.languageCode = 'tr',
  });

  @override
  State<CircularCounter> createState() => _CircularCounterState();
}

class _CircularCounterState extends State<CircularCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressAnimController;
  late Animation<double> _buttonTranslate;
  late Animation<double> _buttonShadow;
  bool _isResetDown = false;
  bool _isMinusDown = false;

  @override
  void initState() {
    super.initState();
    _pressAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    _buttonTranslate = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(parent: _pressAnimController, curve: Curves.easeInOut),
    );
    _buttonShadow = Tween<double>(begin: 8.0, end: 2.0).animate(
      CurvedAnimation(parent: _pressAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressAnimController.dispose();
    super.dispose();
  }

  void _handleMainPress() {
    _pressAnimController.forward().then((_) {
      _pressAnimController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final accentColor = theme.colorScheme.secondary;

    final countStr = widget.count.toString().padLeft(5, '0');

    return Center(
      child: Container(
        width: 275,
        height: 355,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(105),
            topRight: Radius.circular(105),
            bottomLeft: Radius.circular(115),
            bottomRight: Radius.circular(115),
          ),
          // 3D Kasa Degradesi (Işık sol üstten vuruyor)
          gradient: LinearGradient(
            begin: const Alignment(-0.6, -0.8),
            end: const Alignment(0.7, 0.9),
            colors: [
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
              theme.colorScheme.surface,
              const Color(0xFF060B08),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
          // Dış 3D Işık ve Gölge (Neumorphic)
          boxShadow: [
            // Sol-üst parlama (Highlight)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.12),
              offset: const Offset(-6, -6),
              blurRadius: 14,
            ),
            // Sağ-alt koyu derinlik gölgesi
            const BoxShadow(
              color: Colors.black87,
              offset: Offset(10, 16),
              blurRadius: 28,
              spreadRadius: 2,
            ),
            // Temanın renkli hafif ambiyans ışıltısı
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.25),
              blurRadius: 36,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.22),
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. GÖMÜLÜ 3D DİJİTAL LCD EKRAN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  // Ekran Yuvası 3D Çerçeve
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2C3E50),
                      Color(0xFF1A252F),
                      Color(0xFF111827),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      offset: Offset(0, 3),
                      blurRadius: 4,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.2,
                  ),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1E16), // Klasik LCD arka planı
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF070E0A),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Hedef Göstergesi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocalizationService.get('goal', widget.languageCode).toUpperCase(),
                            style: GoogleFonts.shareTechMono(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF387B57),
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            widget.target > 0
                                ? "${widget.target}"
                                : LocalizationService.get('free', widget.languageCode).toUpperCase(),
                            style: GoogleFonts.shareTechMono(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // 5 Basamaklı Dijital Sayaç
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Silik 88888 arka plan segmentleri
                          Text(
                            "88888",
                            style: GoogleFonts.shareTechMono(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 6.0,
                              color: const Color(0xFF173022),
                            ),
                          ),
                          // Parlayan Aktif Rakamlar
                          Text(
                            countStr,
                            style: GoogleFonts.shareTechMono(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 6.0,
                              color: const Color(0xFF4EFA9D),
                              shadows: const [
                                Shadow(
                                  color: Color(0xFF2ECC71),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 2. YAN KÜÇÜK BUTONLAR (SOL: -1, SAĞ: RESET) & ORTADA DEV 3D BUTON
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Sol Tuş: -1 Azalt (3D Çıkıntılı Buton)
                    GestureDetector(
                      onTapDown: (_) => setState(() => _isMinusDown = true),
                      onTapUp: (_) {
                        setState(() => _isMinusDown = false);
                        widget.onDecrement?.call();
                      },
                      onTapCancel: () => setState(() => _isMinusDown = false),
                      child: Transform.translate(
                        offset: Offset(0, _isMinusDown ? 2 : 0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              center: Alignment(-0.3, -0.3),
                              colors: [
                                Color(0xFFCBD5E1),
                                Color(0xFF64748B),
                                Color(0xFF334155),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white60,
                              width: 1.5,
                            ),
                            boxShadow: _isMinusDown
                                ? []
                                : const [
                                    BoxShadow(
                                      color: Colors.black87,
                                      offset: Offset(0, 4),
                                      blurRadius: 5,
                                    ),
                                  ],
                          ),
                          child: const Center(
                            child: Icon(Icons.remove,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    // ORTA: DEV 3D YAYLANAN ZİKİR DÜĞMESİ
                    AnimatedBuilder(
                      animation: _pressAnimController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _buttonTranslate.value),
                          child: GestureDetector(
                            onTap: _handleMainPress,
                            child: Container(
                              width: 120,
                              height: 120,
                              // Buton Yuvası (Recessed outer rim)
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF0F172A),
                                    Color(0xFF1E293B),
                                    Color(0xFF090D16),
                                  ],
                                ),
                                border: Border.all(
                                  color: primaryColor.withValues(alpha: 0.5),
                                  width: 3.0,
                                ),
                                boxShadow: [
                                  // Buton gölgesi (basıldığında kısalır)
                                  BoxShadow(
                                    color: Colors.black87,
                                    offset: Offset(0, _buttonShadow.value),
                                    blurRadius: _buttonShadow.value * 1.6,
                                  ),
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.35),
                                    blurRadius: 16,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: Container(
                                  // Gerçek 3D Kubbe Düğme Gövdesi
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const RadialGradient(
                                      center: Alignment(-0.35, -0.4),
                                      radius: 0.95,
                                      colors: [
                                        Colors.white,
                                        Color(0xFFE2E8F0),
                                        Color(0xFF94A3B8),
                                        Color(0xFF475569),
                                        Color(0xFF1E293B),
                                      ],
                                      stops: [0.0, 0.2, 0.55, 0.85, 1.0],
                                    ),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 78,
                                      height: 78,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          center: const Alignment(-0.2, -0.2),
                                          colors: [
                                            Colors.white
                                                .withValues(alpha: 0.95),
                                            const Color(0xFFCBD5E1),
                                            const Color(0xFF64748B),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.touch_app_rounded,
                                            size: 26,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            LocalizationService.get('press', widget.languageCode).toUpperCase(),
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.5,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Sağ Tuş: RESET (Kırmızı 3D Buton)
                    GestureDetector(
                      onTapDown: (_) => setState(() => _isResetDown = true),
                      onTapUp: (_) {
                        setState(() => _isResetDown = false);
                        widget.onReset?.call();
                      },
                      onTapCancel: () => setState(() => _isResetDown = false),
                      child: Transform.translate(
                        offset: Offset(0, _isResetDown ? 2 : 0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              center: Alignment(-0.3, -0.3),
                              colors: [
                                Color(0xFFFF8A80),
                                Color(0xFFE53935),
                                Color(0xFFB71C1C),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white70,
                              width: 1.5,
                            ),
                            boxShadow: _isResetDown
                                ? []
                                : const [
                                    BoxShadow(
                                      color: Colors.black87,
                                      offset: Offset(0, 4),
                                      blurRadius: 5,
                                    ),
                                  ],
                          ),
                          child: const Center(
                            child: Icon(Icons.refresh_rounded,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. ALT KÜÇÜK NÜANS (Kasa kabartması)
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
