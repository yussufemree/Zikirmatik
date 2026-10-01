import 'dart:convert';

enum VibrationStrength { off, light, medium, strong }

enum AppThemeMode { emerald, midnight, gold, stone }

class AppSettings {
  final VibrationStrength vibrationStrength;
  final bool soundEnabled;
  final bool milestoneVibration;
  final bool fullScreenTap;
  final bool keepScreenOn;
  final AppThemeMode themeMode;
  final String languageCode;

  AppSettings({
    this.vibrationStrength = VibrationStrength.medium,
    this.soundEnabled = true,
    this.milestoneVibration = true,
    this.fullScreenTap = false,
    this.keepScreenOn = false,
    this.themeMode = AppThemeMode.emerald,
    this.languageCode = 'tr',
  });

  Map<String, dynamic> toMap() {
    return {
      'vibrationStrength': vibrationStrength.index,
      'soundEnabled': soundEnabled,
      'milestoneVibration': milestoneVibration,
      'fullScreenTap': fullScreenTap,
      'keepScreenOn': keepScreenOn,
      'themeMode': themeMode.index,
      'languageCode': languageCode,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      vibrationStrength: VibrationStrength.values[
          (map['vibrationStrength'] as int?) ?? VibrationStrength.medium.index],
      soundEnabled: map['soundEnabled'] ?? true,
      milestoneVibration: map['milestoneVibration'] ?? true,
      fullScreenTap: map['fullScreenTap'] ?? false,
      keepScreenOn: map['keepScreenOn'] ?? false,
      themeMode: AppThemeMode
          .values[(map['themeMode'] as int?) ?? AppThemeMode.emerald.index],
      languageCode: map['languageCode'] ?? 'tr',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettings.fromJson(String source) =>
      AppSettings.fromMap(json.decode(source));

  AppSettings copyWith({
    VibrationStrength? vibrationStrength,
    bool? soundEnabled,
    bool? milestoneVibration,
    bool? fullScreenTap,
    bool? keepScreenOn,
    AppThemeMode? themeMode,
    String? languageCode,
  }) {
    return AppSettings(
      vibrationStrength: vibrationStrength ?? this.vibrationStrength,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      milestoneVibration: milestoneVibration ?? this.milestoneVibration,
      fullScreenTap: fullScreenTap ?? this.fullScreenTap,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
