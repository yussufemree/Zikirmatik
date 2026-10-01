import 'package:flutter/services.dart';
import '../models/app_settings.dart';

class SoundHapticService {
  static final SoundHapticService _instance = SoundHapticService._internal();
  factory SoundHapticService() => _instance;
  SoundHapticService._internal();

  /// Haptic feedback based on user configuration
  Future<void> triggerHaptic(VibrationStrength strength) async {
    switch (strength) {
      case VibrationStrength.off:
        break;
      case VibrationStrength.light:
        await HapticFeedback.lightImpact();
        break;
      case VibrationStrength.medium:
        await HapticFeedback.mediumImpact();
        break;
      case VibrationStrength.strong:
        await HapticFeedback.heavyImpact();
        break;
    }
  }

  /// Milestone feedback when reaching 33, 99, 100 or target
  Future<void> triggerMilestoneFeedback() async {
    // Distinct double vibration for milestone
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.heavyImpact();
  }

  /// Click sound feedback
  Future<void> playClickSound(bool soundEnabled) async {
    if (!soundEnabled) return;
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {
      // Ignored if sound isn't available
    }
  }
}
