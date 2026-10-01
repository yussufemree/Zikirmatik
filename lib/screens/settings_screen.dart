import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_settings.dart';
import '../services/localization_service.dart';
import '../services/sound_haptic_service.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final StorageService storageService;
  final SoundHapticService soundHapticService;
  final AppSettings settings;
  final Function(AppSettings) onSettingsChanged;

  const SettingsScreen({
    super.key,
    required this.storageService,
    required this.soundHapticService,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _settings = widget.settings;
    }
  }

  void _updateSettings(AppSettings updated) {
    setState(() => _settings = updated);
    widget.storageService.saveSettings(updated);
    widget.onSettingsChanged(updated);
  }

  void _showLanguageDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    LocalizationService.get(
                        'selectLanguage', _settings.languageCode),
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.close_rounded, color: Colors.white54),
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
                    final lang =
                        LocalizationService.supportedLanguages[index];
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
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
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
                          _updateSettings(updated);
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

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          LocalizationService.get('privacyPolicy', _settings.languageCode),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            LocalizationService.get('privacyContent', _settings.languageCode),
            style: GoogleFonts.outfit(color: Colors.white70, height: 1.5),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocalizationService.get('ok', _settings.languageCode)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    final lang = _settings.languageCode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Huzur Zikirmatik v1.0.0",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationService.get('aboutDesc', lang),
              style: GoogleFonts.outfit(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocalizationService.get('close', lang)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final lang = _settings.languageCode;

    final currentLangInfo = LocalizationService.supportedLanguages.firstWhere(
      (l) => l.code == lang,
      orElse: () => LocalizationService.supportedLanguages.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.get('tabSettings', lang)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section: DİL SEÇİMİ (Language Selection Card)
          _buildSectionHeader(LocalizationService.get('language', lang).toUpperCase()),
          Card(
            child: ListTile(
              leading: Text(currentLangInfo.flag,
                  style: const TextStyle(fontSize: 26)),
              title: Text(
                currentLangInfo.nativeName,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                "${currentLangInfo.name} • ${LocalizationService.get('language', lang)}",
                style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12),
              ),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocalizationService.get('change', lang),
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 11, color: primary),
                  ],
                ),
              ),
              onTap: _showLanguageDialog,
            ),
          ),

          const SizedBox(height: 20),

          // Section: Geri Bildirim Ayarları
          _buildSectionHeader(LocalizationService.get('feedbackSettings', lang)),
          Card(
            child: Column(
              children: [
                // Titreşim Seviyesi
                ListTile(
                  leading: Icon(Icons.vibration_rounded, color: primary),
                  title: Text(
                    LocalizationService.get('vibrationStrength', lang),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    _getVibrationName(_settings.vibrationStrength, lang),
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  trailing: DropdownButton<VibrationStrength>(
                    value: _settings.vibrationStrength,
                    dropdownColor: theme.colorScheme.surface,
                    underline: const SizedBox(),
                    items: VibrationStrength.values.map((v) {
                      return DropdownMenuItem(
                        value: v,
                        child: Text(
                          _getVibrationName(v, lang),
                          style: GoogleFonts.outfit(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        final updated =
                            _settings.copyWith(vibrationStrength: val);
                        _updateSettings(updated);
                        widget.soundHapticService.triggerHaptic(val);
                      }
                    },
                  ),
                ),
                const Divider(height: 1, color: Colors.white10),

                // Tıklama Sesi
                SwitchListTile(
                  secondary: Icon(Icons.volume_up_rounded, color: primary),
                  title: Text(
                    LocalizationService.get('clickSound', lang),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  value: _settings.soundEnabled,
                  activeThumbColor: primary,
                  onChanged: (val) {
                    final updated = _settings.copyWith(soundEnabled: val);
                    _updateSettings(updated);
                    widget.soundHapticService.playClickSound(val);
                  },
                ),
                const Divider(height: 1, color: Colors.white10),

                // Hedefte Özel Titreşim
                SwitchListTile(
                  secondary: Icon(Icons.notifications_active_rounded,
                      color: primary),
                  title: Text(
                    LocalizationService.get('milestoneVib', lang),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  value: _settings.milestoneVibration,
                  activeThumbColor: primary,
                  onChanged: (val) {
                    final updated = _settings.copyWith(milestoneVibration: val);
                    _updateSettings(updated);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: Kullanım Modu
          _buildSectionHeader(LocalizationService.get('usageSettings', lang)),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(Icons.fullscreen_rounded, color: primary),
                  title: Text(
                    LocalizationService.get('fullscreenMode', lang),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  value: _settings.fullScreenTap,
                  activeThumbColor: primary,
                  onChanged: (val) {
                    final updated = _settings.copyWith(fullScreenTap: val);
                    _updateSettings(updated);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: Tema Seçimi
          _buildSectionHeader(LocalizationService.get('themeSelection', lang)),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildThemeOption(
                    mode: AppThemeMode.emerald,
                    name: LocalizationService.get('themeEmerald', lang),
                    color: const Color(0xFF10B981),
                  ),
                  _buildThemeOption(
                    mode: AppThemeMode.midnight,
                    name: LocalizationService.get('themeMidnight', lang),
                    color: const Color(0xFF38BDF8),
                  ),
                  _buildThemeOption(
                    mode: AppThemeMode.gold,
                    name: LocalizationService.get('themeGold', lang),
                    color: const Color(0xFFD4AF37),
                  ),
                  _buildThemeOption(
                    mode: AppThemeMode.stone,
                    name: LocalizationService.get('themeStone', lang),
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section: Kurumsal & Mağaza
          _buildSectionHeader(LocalizationService.get('about', lang).toUpperCase()),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: primary),
                  title: Text(
                    LocalizationService.get('privacyPolicy', lang),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: Colors.white38),
                  onTap: _showPrivacyPolicy,
                ),
                const Divider(height: 1, color: Colors.white10),
                ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: primary),
                  title: Text(
                    LocalizationService.get('about', lang),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Text(
                    "v1.0.0",
                    style:
                        GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
                  ),
                  onTap: _showAboutDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required AppThemeMode mode,
    required String name,
    required Color color,
  }) {
    final isSelected = _settings.themeMode == mode;
    return GestureDetector(
      onTap: () {
        final updated = _settings.copyWith(themeMode: mode);
        _updateSettings(updated);
      },
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 24)
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white38,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  String _getVibrationName(VibrationStrength v, String lang) {
    switch (v) {
      case VibrationStrength.off:
        return LocalizationService.get('vibOff', lang);
      case VibrationStrength.light:
        return LocalizationService.get('vibLight', lang);
      case VibrationStrength.medium:
        return LocalizationService.get('vibMedium', lang);
      case VibrationStrength.strong:
        return LocalizationService.get('vibStrong', lang);
    }
  }
}
