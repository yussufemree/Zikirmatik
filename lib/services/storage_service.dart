import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/default_dhikrs.dart';
import '../models/app_settings.dart';
import '../models/dhikr_model.dart';

class StorageService {
  static const String _keyDhikrs = 'zikirmatik_dhikrs';
  static const String _keyActiveId = 'zikirmatik_active_id';
  static const String _keySettings = 'zikirmatik_settings';
  static const String _keyHistory = 'zikirmatik_history';
  static const String _keyTotalTaps = 'zikirmatik_total_taps';
  static const String _keyDayBreakdown = 'zikirmatik_day_breakdown';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get all dhikrs (defaults merged with saved states)
  List<DhikrModel> getDhikrs() {
    final String? rawData = _prefs.getString(_keyDhikrs);
    if (rawData == null || rawData.isEmpty) {
      final defaults = DefaultDhikrs.list;
      saveDhikrs(defaults);
      return defaults;
    }

    try {
      final List<dynamic> decoded = json.decode(rawData);
      return decoded.map((item) => DhikrModel.fromMap(item)).toList();
    } catch (e) {
      return DefaultDhikrs.list;
    }
  }

  Future<void> saveDhikrs(List<DhikrModel> dhikrs) async {
    final rawData = json.encode(dhikrs.map((d) => d.toMap()).toList());
    await _prefs.setString(_keyDhikrs, rawData);
  }

  /// Get active dhikr ID
  String getActiveDhikrId() {
    return _prefs.getString(_keyActiveId) ?? 'subhanallah';
  }

  Future<void> saveActiveDhikrId(String id) async {
    await _prefs.setString(_keyActiveId, id);
  }

  /// Settings
  AppSettings getSettings() {
    final rawData = _prefs.getString(_keySettings);
    if (rawData == null || rawData.isEmpty) {
      return AppSettings();
    }
    try {
      return AppSettings.fromJson(rawData);
    } catch (e) {
      return AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setString(_keySettings, settings.toJson());
  }

  /// Daily History: Map of "yyyy-MM-dd" to total count
  Map<String, int> getDailyHistory() {
    final rawData = _prefs.getString(_keyHistory);
    if (rawData == null || rawData.isEmpty) {
      return {};
    }
    try {
      final Map<String, dynamic> decoded = json.decode(rawData);
      return decoded.map((key, value) => MapEntry(key, (value as num).toInt()));
    } catch (e) {
      return {};
    }
  }

  /// Detailed breakdown per day: Map of "yyyy-MM-dd" -> { "Dhikr Title": count }
  Map<String, Map<String, int>> getAllDayBreakdowns() {
    final rawData = _prefs.getString(_keyDayBreakdown);
    if (rawData == null || rawData.isEmpty) {
      return {};
    }
    try {
      final Map<String, dynamic> decoded = json.decode(rawData);
      return decoded.map((dateKey, value) {
        final innerMap = (value as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, (v as num).toInt()));
        return MapEntry(dateKey, innerMap);
      });
    } catch (e) {
      return {};
    }
  }

  Map<String, int> getDayBreakdown(String dateKey) {
    final all = getAllDayBreakdowns();
    return all[dateKey] ?? {};
  }

  Future<void> recordTap(String dhikrId, [String? dhikrTitle]) async {
    // 1. Increment total lifetime taps
    final currentTotal = getTotalTaps();
    await _prefs.setInt(_keyTotalTaps, currentTotal + 1);

    // 2. Increment today's total count
    final today = _getTodayKey();
    final history = getDailyHistory();
    history[today] = (history[today] ?? 0) + 1;
    await _prefs.setString(_keyHistory, json.encode(history));

    // 3. Record breakdown by specific dhikr title
    if (dhikrTitle != null && dhikrTitle.isNotEmpty) {
      final allBreakdowns = getAllDayBreakdowns();
      final dayMap = allBreakdowns[today] ?? {};
      dayMap[dhikrTitle] = (dayMap[dhikrTitle] ?? 0) + 1;
      allBreakdowns[today] = dayMap;
      await _prefs.setString(_keyDayBreakdown, json.encode(allBreakdowns));
    }
  }

  int getTotalTaps() {
    return _prefs.getInt(_keyTotalTaps) ?? 0;
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
