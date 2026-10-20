import 'package:flutter/services.dart';

class HapticHelper {
  /// Provides subtle tactile click feedback on taps, button presses, and tab switches
  static void lightTap() {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
  }

  static void lightImpact() => lightTap();

  /// Provides stronger tactile confirmation for important actions (e.g. photo capture, diagnosis completed)
  static void mediumConfirm() {
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  static void mediumImpact() => mediumConfirm();
}
