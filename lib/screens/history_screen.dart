import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dhikr_model.dart';
import '../services/localization_service.dart';
import '../services/storage_service.dart';
import '../widgets/daily_activity_widget.dart';

class HistoryScreen extends StatelessWidget {
  final StorageService storageService;
  final String languageCode;

  const HistoryScreen({
    super.key,
    required this.storageService,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    final int totalLifetime = storageService.getTotalTaps();
    final Map<String, int> history = storageService.getDailyHistory();
    final List<DhikrModel> dhikrs = storageService.getDhikrs();

    // Sort dhikrs by total count
    final sortedDhikrs = List<DhikrModel>.from(dhikrs)
      ..sort((a, b) => b.totalCount.compareTo(a.totalCount));

    final today = _getTodayKey();
    final int todayCount = history[today] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.get('tabHistory', languageCode)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards (Total & Today)
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.all_inclusive_rounded,
                              color: primary, size: 28),
                          const SizedBox(height: 10),
                          Text(
                            "$totalLifetime",
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            LocalizationService.get('total', languageCode),
                            style: GoogleFonts.outfit(
                              fontSize: 12,
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
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.today_rounded,
                              color: secondary, size: 28),
                          const SizedBox(height: 10),
                          Text(
                            "$todayCount",
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            LocalizationService.get('today', languageCode),
                            style: GoogleFonts.outfit(
                              fontSize: 12,
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

            const SizedBox(height: 16),

            // Daily Activity Widget (Tıklanabilir Günlük Zikir Takvimi)
            DailyActivityWidget(
              storageService: storageService,
              languageCode: languageCode,
              compact: false,
            ),

            const SizedBox(height: 20),

            // Section: Zikir Dağılımı
            Text(
              LocalizationService.get('topDhikrs', languageCode),
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            ...sortedDhikrs.take(8).map((d) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    LocalizationService.getDhikrTitle(d, languageCode),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    "${LocalizationService.get('goal', languageCode)}: ${d.target}",
                    style:
                        GoogleFonts.outfit(color: Colors.white54, fontSize: 12),
                  ),
                  trailing: Text(
                    "${d.totalCount}",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: secondary,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
