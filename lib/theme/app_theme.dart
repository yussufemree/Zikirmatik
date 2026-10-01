import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_settings.dart';

class AppTheme {
  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.emerald:
        return _buildTheme(
          scaffoldBg: const Color(0xFF071F17),
          cardBg: const Color(0xFF0F3628),
          primary: const Color(0xFF10B981),
          accent: const Color(0xFFE5C378),
          counterGlow: const Color(0xFF059669),
          surfaceVariant: const Color(0xFF164E3A),
        );
      case AppThemeMode.midnight:
        return _buildTheme(
          scaffoldBg: const Color(0xFF090D16),
          cardBg: const Color(0xFF131C2E),
          primary: const Color(0xFF38BDF8),
          accent: const Color(0xFFFCD34D),
          counterGlow: const Color(0xFF0284C7),
          surfaceVariant: const Color(0xFF1E293B),
        );
      case AppThemeMode.gold:
        return _buildTheme(
          scaffoldBg: const Color(0xFF14120E),
          cardBg: const Color(0xFF241F16),
          primary: const Color(0xFFD4AF37),
          accent: const Color(0xFFF59E0B),
          counterGlow: const Color(0xFFB45309),
          surfaceVariant: const Color(0xFF382F1E),
        );
      case AppThemeMode.stone:
        return _buildTheme(
          scaffoldBg: const Color(0xFF0F172A),
          cardBg: const Color(0xFF1E293B),
          primary: const Color(0xFF94A3B8),
          accent: const Color(0xFF38BDF8),
          counterGlow: const Color(0xFF64748B),
          surfaceVariant: const Color(0xFF334155),
        );
    }
  }

  static ThemeData _buildTheme({
    required Color scaffoldBg,
    required Color cardBg,
    required Color primary,
    required Color accent,
    required Color counterGlow,
    required Color surfaceVariant,
  }) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBg,
      primaryColor: primary,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: cardBg,
        surfaceContainerHighest: surfaceVariant,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardBg,
        selectedItemColor: primary,
        unselectedItemColor: Colors.white54,
        selectedLabelStyle:
            GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
