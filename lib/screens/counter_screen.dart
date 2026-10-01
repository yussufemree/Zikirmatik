import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_settings.dart';
import '../models/dhikr_model.dart';
import '../services/localization_service.dart';
import '../services/sound_haptic_service.dart';
import '../services/storage_service.dart';
import '../widgets/circular_counter.dart';
import '../widgets/daily_activity_widget.dart';
import '../widgets/milestone_dialog.dart';

class CounterScreen extends StatefulWidget {
  final StorageService storageService;
  final SoundHapticService soundHapticService;
  final DhikrModel activeDhikr;
  final AppSettings settings;
  final Function(DhikrModel) onDhikrChanged;
  final Function(AppSettings) onSettingsChanged;

  const CounterScreen({
    super.key,
    required this.storageService,
    required this.soundHapticService,
    required this.activeDhikr,
    required this.settings,
    required this.onDhikrChanged,
    required this.onSettingsChanged,
  });

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late DhikrModel _dhikr;
  late AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _dhikr = widget.activeDhikr;
    _settings = widget.settings;
  }

  @override
  void didUpdateWidget(covariant CounterScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeDhikr.id != widget.activeDhikr.id ||
        oldWidget.activeDhikr.count != widget.activeDhikr.count) {
      _dhikr = widget.activeDhikr;
    }
    if (oldWidget.settings != widget.settings) {
      _settings = widget.settings;
    }
  }

  void _increment() {
    setState(() {
      _dhikr.count++;
      _dhikr.totalCount++;
    });

    widget.soundHapticService.playClickSound(_settings.soundEnabled);
    widget.soundHapticService.triggerHaptic(_settings.vibrationStrength);

    // Save state with detailed breakdown by title
    widget.storageService.recordTap(_dhikr.id, _dhikr.title);
    _saveCurrentDhikr();

    // Check target milestone
    if (_dhikr.target > 0 && _dhikr.count == _dhikr.target) {
      if (_settings.milestoneVibration) {
        widget.soundHapticService.triggerMilestoneFeedback();
      }
      _showMilestoneDialog();
    }
  }

  void _decrement() {
    if (_dhikr.count > 0) {
      setState(() {
        _dhikr.count--;
      });
      widget.soundHapticService.triggerHaptic(VibrationStrength.light);
      _saveCurrentDhikr();
    }
  }

  void _resetCount() {
    final lang = _settings.languageCode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          LocalizationService.get('resetConfirmTitle', lang),
          style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700, color: Colors.white),
        ),
        content: Text(
          LocalizationService.get('resetConfirmBody', lang),
          style: GoogleFonts.outfit(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              LocalizationService.get('cancel', lang),
              style: GoogleFonts.outfit(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _dhikr.count = 0;
              });
              _saveCurrentDhikr();
              widget.soundHapticService.triggerHaptic(VibrationStrength.medium);
            },
            child: Text(
              LocalizationService.get('reset', lang),
              style: GoogleFonts.outfit(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _saveCurrentDhikr() {
    final all = widget.storageService.getDhikrs();
    final index = all.indexWhere((d) => d.id == _dhikr.id);
    if (index != -1) {
      all[index] = _dhikr;
      widget.storageService.saveDhikrs(all);
    }
    widget.onDhikrChanged(_dhikr);
  }

  void _showMilestoneDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => MilestoneDialog(
        dhikrTitle: _dhikr.title,
        count: _dhikr.count,
        onReset: () {
          setState(() {
            _dhikr.count = 0;
          });
          _saveCurrentDhikr();
        },
        onContinue: () {},
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocalizationService.get(
                      'selectLanguage', _settings.languageCode),
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
                itemCount: LocalizationService.supportedLanguages.length,
                itemBuilder: (context, index) {
                  final lang = LocalizationService.supportedLanguages[index];
                  final isSelected = lang.code == _settings.languageCode;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white10,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: ListTile(
                      leading: Text(
                        lang.flag,
                        style: const TextStyle(fontSize: 26),
                      ),
                      title: Text(
                        lang.nativeName,
                        style: GoogleFonts.outfit(
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        lang.name,
                        style: GoogleFonts.outfit(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle_rounded,
                              color: Theme.of(context).colorScheme.primary)
                          : null,
                      onTap: () {
                        Navigator.pop(ctx);
                        final updated =
                            _settings.copyWith(languageCode: lang.code);
                        setState(() => _settings = updated);
                        widget.storageService.saveSettings(updated);
                        widget.onSettingsChanged(updated);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVirtueBottomSheet() {
    final lang = _settings.languageCode;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    LocalizationService.getDhikrTitle(_dhikr, lang),
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close_rounded, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                _dhikr.arabic,
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              LocalizationService.get('meaning', lang),
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              LocalizationService.getDhikrMeaning(_dhikr, lang).isNotEmpty
                  ? LocalizationService.getDhikrMeaning(_dhikr, lang)
                  : LocalizationService.get('notSpecified', lang),
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              LocalizationService.get('virtue', lang),
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              LocalizationService.getDhikrVirtue(_dhikr, lang).isNotEmpty
                  ? LocalizationService.getDhikrVirtue(_dhikr, lang)
                  : LocalizationService.get('notSpecified', lang),
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final lang = _settings.languageCode;

    final currentLangInfo = LocalizationService.supportedLanguages.firstWhere(
      (l) => l.code == lang,
      orElse: () => LocalizationService.supportedLanguages.first,
    );

    return GestureDetector(
      onTap: _settings.fullScreenTap ? _increment : null,
      behavior: HitTestBehavior.opaque,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Top App Bar Controls
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Sound Toggle Button
                            IconButton(
                              icon: Icon(
                                _settings.soundEnabled
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_off_rounded,
                                color: _settings.soundEnabled
                                    ? primary
                                    : Colors.white38,
                              ),
                              onPressed: () {
                                final updated = _settings.copyWith(
                                    soundEnabled: !_settings.soundEnabled);
                                setState(() => _settings = updated);
                                widget.storageService.saveSettings(updated);
                                widget.onSettingsChanged(updated);
                              },
                              tooltip: LocalizationService.get('sound', lang),
                            ),

                            // Full Screen Tap Toggle Button
                            IconButton(
                              icon: Icon(
                                _settings.fullScreenTap
                                    ? Icons.fullscreen_rounded
                                    : Icons.fullscreen_exit_rounded,
                                color: _settings.fullScreenTap
                                    ? primary
                                    : Colors.white38,
                              ),
                              onPressed: () {
                                final updated = _settings.copyWith(
                                    fullScreenTap: !_settings.fullScreenTap);
                                setState(() => _settings = updated);
                                widget.storageService.saveSettings(updated);
                                widget.onSettingsChanged(updated);
                              },
                              tooltip: _settings.fullScreenTap
                                  ? LocalizationService.get('fullscreenOn', lang)
                                  : LocalizationService.get('fullscreenOff', lang),
                            ),

                            // Language Switcher Button (Shows Country Flag)
                            InkWell(
                              onTap: _showLanguagePicker,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: Row(
                                  children: [
                                    Text(currentLangInfo.flag,
                                        style: const TextStyle(fontSize: 16)),
                                    const SizedBox(width: 4),
                                    Text(
                                      currentLangInfo.code.toUpperCase(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Vibration Toggle
                            IconButton(
                              icon: Icon(
                                _settings.vibrationStrength !=
                                        VibrationStrength.off
                                    ? Icons.vibration_rounded
                                    : Icons.smartphone_rounded,
                                color: _settings.vibrationStrength !=
                                        VibrationStrength.off
                                    ? primary
                                    : Colors.white38,
                              ),
                              onPressed: () {
                                final next = _settings.vibrationStrength ==
                                        VibrationStrength.off
                                    ? VibrationStrength.medium
                                    : VibrationStrength.off;
                                final updated =
                                    _settings.copyWith(vibrationStrength: next);
                                setState(() => _settings = updated);
                                widget.storageService.saveSettings(updated);
                                widget.onSettingsChanged(updated);
                              },
                              tooltip:
                                  LocalizationService.get('vibration', lang),
                            ),
                          ],
                        ),
                      ),

                      // Active Dhikr Card (Title, Arabic, Info Button)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            LocalizationService.getDhikrTitle(_dhikr, lang),
                                            style: GoogleFonts.outfit(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            LocalizationService.getCategoryName(_dhikr.category, lang),
                                            style: GoogleFonts.outfit(
                                              fontSize: 11,
                                              color: secondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _showVirtueBottomSheet,
                                      icon: Icon(
                                        Icons.info_outline_rounded,
                                        color: primary,
                                        size: 22,
                                      ),
                                      tooltip: LocalizationService.get(
                                          'virtueAndMeaning', lang),
                                    ),
                                  ],
                                ),
                                if (_dhikr.arabic.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _dhikr.arabic,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.amiri(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: secondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Main Realistic 3D Zikirmatik Device
                      CircularCounter(
                        count: _dhikr.count,
                        target: _dhikr.target,
                        onTap: _increment,
                        onReset: _resetCount,
                        onDecrement: _decrement,
                        isFullScreen: _settings.fullScreenTap,
                        languageCode: lang,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
