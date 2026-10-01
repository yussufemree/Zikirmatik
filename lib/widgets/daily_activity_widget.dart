import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/localization_service.dart';
import '../services/storage_service.dart';

class DailyActivityWidget extends StatelessWidget {
  final StorageService storageService;
  final String languageCode;
  final bool compact;

  const DailyActivityWidget({
    super.key,
    required this.storageService,
    required this.languageCode,
    this.compact = false,
  });

  void _showDayDetails(
      BuildContext context, DateTime date, String dateKey, int totalCount) {
    final breakdown = storageService.getDayBreakdown(dateKey);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    final dateFormatted =
        "${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year} ${_getDayName(date.weekday, languageCode)}";

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocalizationService.get(
                            'dayBreakdownTitle', languageCode),
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateFormatted,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.close_rounded, color: Colors.white54),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Total for the day
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocalizationService.get('dayTotal', languageCode),
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      "$totalCount",
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (breakdown.isEmpty && totalCount == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      LocalizationService.get('noDataForDate', languageCode),
                      style: GoogleFonts.outfit(color: Colors.white38),
                    ),
                  ),
                )
              else if (breakdown.isEmpty && totalCount > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      LocalizationService.get('totalDhikrOnDate', languageCode)
                          .replaceAll('{count}', '$totalCount'),
                      style: GoogleFonts.outfit(color: Colors.white70),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: breakdown.entries.map((entry) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${entry.value}",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: secondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 16),
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

    final history = storageService.getDailyHistory();
    final now = DateTime.now();

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 14, vertical: compact ? 10 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 15, color: primary),
                    const SizedBox(width: 6),
                    Text(
                      LocalizationService.get('dailyActivity', languageCode),
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  LocalizationService.get('tapForDetails', languageCode),
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 7 Days Horizontal Tracker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final date = now.subtract(Duration(days: 6 - index));
                final dateKey =
                    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                final isToday = index == 6;
                final count = history[dateKey] ?? 0;
                final dayName = _getDayName(date.weekday, languageCode);

                return InkWell(
                  onTap: () =>
                      _showDayDetails(context, date, dateKey, count),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 38,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isToday
                          ? primary.withValues(alpha: 0.18)
                          : count > 0
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isToday
                            ? primary
                            : count > 0
                                ? primary.withValues(alpha: 0.4)
                                : Colors.white12,
                        width: isToday ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          dayName,
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: isToday
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: isToday ? primary : Colors.white60,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${date.day}",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: count > 0
                                ? (isToday ? primary : secondary)
                                : Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            count > 999 ? "${(count / 1000).toStringAsFixed(1)}k" : "$count",
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: count > 0
                                  ? Colors.black87
                                  : Colors.white38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday, String lang) {
    // 1: Mon ... 7: Sun
    if (lang == 'ar' || lang == 'ur' || lang == 'fa') {
      const days = ['إثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت', 'أحد'];
      return days[(weekday - 1) % 7];
    } else if (lang == 'en' || lang == 'de') {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[(weekday - 1) % 7];
    } else if (lang == 'fr') {
      const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      return days[(weekday - 1) % 7];
    } else if (lang == 'it') {
      const days = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
      return days[(weekday - 1) % 7];
    } else if (lang == 'ru') {
      const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
      return days[(weekday - 1) % 7];
    } else if (lang == 'id' || lang == 'ms') {
      const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      return days[(weekday - 1) % 7];
    }
    // Turkish default
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return days[(weekday - 1) % 7];
  }
}
