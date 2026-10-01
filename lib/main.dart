import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/app_settings.dart';
import 'models/dhikr_model.dart';
import 'screens/counter_screen.dart';
import 'screens/dhikr_list_screen.dart';
import 'screens/history_screen.dart';
import 'screens/qibla_screen.dart';
import 'screens/settings_screen.dart';
import 'services/localization_service.dart';
import 'services/sound_haptic_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

import 'widgets/mobile_frame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for immersive sleek appearance
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final storageService = StorageService();
  await storageService.init();

  runApp(ZikirmatikApp(storageService: storageService));
}

class ZikirmatikApp extends StatefulWidget {
  final StorageService storageService;

  const ZikirmatikApp({super.key, required this.storageService});

  @override
  State<ZikirmatikApp> createState() => _ZikirmatikAppState();
}

class _ZikirmatikAppState extends State<ZikirmatikApp> {
  late AppSettings _settings;
  late List<DhikrModel> _dhikrs;
  late DhikrModel _activeDhikr;
  final SoundHapticService _soundHapticService = SoundHapticService();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _settings = widget.storageService.getSettings();
    _dhikrs = widget.storageService.getDhikrs();

    final activeId = widget.storageService.getActiveDhikrId();
    _activeDhikr = _dhikrs.firstWhere(
      (d) => d.id == activeId,
      orElse: () => _dhikrs.isNotEmpty ? _dhikrs.first : _dhikrs[0],
    );
  }

  void _onDhikrChanged(DhikrModel updated) {
    setState(() {
      _activeDhikr = updated;
      final index = _dhikrs.indexWhere((d) => d.id == updated.id);
      if (index != -1) {
        _dhikrs[index] = updated;
      }
    });
  }

  void _onSelectDhikr(DhikrModel selected) {
    setState(() {
      _activeDhikr = selected;
      _currentIndex = 0; // Switch to counter tab
    });
    widget.storageService.saveActiveDhikrId(selected.id);
  }

  void _onSettingsChanged(AppSettings updated) {
    setState(() {
      _settings = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = _settings.languageCode;
    final isRtl = LocalizationService.isRtl(lang);

    return MaterialApp(
      title: LocalizationService.get('appName', lang),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(_settings.themeMode),
      home: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: MobileFrame(
          child: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: [
                CounterScreen(
                  storageService: widget.storageService,
                  soundHapticService: _soundHapticService,
                  activeDhikr: _activeDhikr,
                  settings: _settings,
                  onDhikrChanged: _onDhikrChanged,
                  onSettingsChanged: _onSettingsChanged,
                ),
                DhikrListScreen(
                  storageService: widget.storageService,
                  activeDhikr: _activeDhikr,
                  languageCode: lang,
                  onSelectDhikr: _onSelectDhikr,
                ),
                QiblaScreen(
                  languageCode: lang,
                  soundHapticService: _soundHapticService,
                ),
                HistoryScreen(
                  storageService: widget.storageService,
                  languageCode: lang,
                ),
                SettingsScreen(
                  storageService: widget.storageService,
                  soundHapticService: _soundHapticService,
                  settings: _settings,
                  onSettingsChanged: _onSettingsChanged,
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
                _soundHapticService.triggerHaptic(VibrationStrength.light);
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.radio_button_checked_rounded),
                  label: LocalizationService.get('tabCounter', lang),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.format_list_bulleted_rounded),
                  label: LocalizationService.get('tabDhikrs', lang),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.explore_rounded),
                  label: LocalizationService.get('tabQibla', lang),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.bar_chart_rounded),
                  label: LocalizationService.get('tabHistory', lang),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_rounded),
                  label: LocalizationService.get('tabSettings', lang),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
