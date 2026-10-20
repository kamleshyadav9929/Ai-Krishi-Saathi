import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

enum AlertSeverity {
  critical, // 🔴 गंभीर चेतावनी (Immediate Danger to Crop / High Risk)
  warning,  // 🟡 सतर्कता (Moderate Risk / Pest Favorable Weather)
  info,     // 🔵 सूचना (Advisory)
  safe,     // 🟢 अनुकूल मौसम (Safe Window for Agricultural Operations)
}

enum AlertCategory {
  weather,     // वर्षा, ओलावृष्टि, पाला, शीतलहर, लू
  pestDisease, // कीट-पतंगे व फंगल/बैक्टीरियल रोग
}

class WeatherAlertModel {
  final String id;
  final String titleHindi;
  final String titleEnglish;
  final AlertSeverity severity;
  final AlertCategory category;
  final String conditionSummaryHindi;
  final String conditionSummaryEnglish;
  final List<String> affectedCropsHindi;
  final List<String> affectedCropsEnglish;
  final List<String> dosHindi;       // क्या करें (Actionable steps)
  final List<String> dosEnglish;
  final List<String> dontsHindi;     // क्या न करें (Critical things to avoid)
  final List<String> dontsEnglish;
  final String audioAdvisoryHindi;  // Clear audio script for TTS
  final String audioAdvisoryEnglish;
  final IconData icon;
  final DateTime issuedAt;

  WeatherAlertModel({
    required this.id,
    required this.titleHindi,
    required this.titleEnglish,
    required this.severity,
    required this.category,
    required this.conditionSummaryHindi,
    required this.conditionSummaryEnglish,
    required this.affectedCropsHindi,
    required this.affectedCropsEnglish,
    required this.dosHindi,
    required this.dosEnglish,
    required this.dontsHindi,
    required this.dontsEnglish,
    required this.audioAdvisoryHindi,
    required this.audioAdvisoryEnglish,
    required this.icon,
    DateTime? issuedAt,
  }) : issuedAt = issuedAt ?? DateTime.now();

  String get severityLabelHindi {
    switch (severity) {
      case AlertSeverity.critical:
        return 'गंभीर चेतावनी (Red Alert)';
      case AlertSeverity.warning:
        return 'सतर्कता अलर्ट (Yellow Alert)';
      case AlertSeverity.info:
        return 'कृषि सलाह (Advisory)';
      case AlertSeverity.safe:
        return 'मौसम अनुकूल (Safe Window)';
    }
  }

  String get shortSeverityLabelHindi {
    switch (severity) {
      case AlertSeverity.critical:
        return 'रेड अलर्ट';
      case AlertSeverity.warning:
        return 'येलो अलर्ट';
      case AlertSeverity.info:
        return 'सलाह';
      case AlertSeverity.safe:
        return 'अनुकूल';
    }
  }

  String get severityLabelEnglish {
    switch (severity) {
      case AlertSeverity.critical:
        return 'Critical Alert';
      case AlertSeverity.warning:
        return 'Warning Alert';
      case AlertSeverity.info:
        return 'Advisory';
      case AlertSeverity.safe:
        return 'Favorable';
    }
  }

  String get shortSeverityLabelEnglish {
    switch (severity) {
      case AlertSeverity.critical:
        return 'Red Alert';
      case AlertSeverity.warning:
        return 'Yellow Alert';
      case AlertSeverity.info:
        return 'Advisory';
      case AlertSeverity.safe:
        return 'Favorable';
    }
  }

  Color get severityColor {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFDC2626); // High red
      case AlertSeverity.warning:
        return const Color(0xFFD97706); // Warm amber
      case AlertSeverity.info:
        return const Color(0xFF2563EB); // Royal blue
      case AlertSeverity.safe:
        return const Color(0xFF15803D); // Growth emerald
    }
  }

  Color get severityBgColor {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFFEF2F2); // Soft red tint
      case AlertSeverity.warning:
        return const Color(0xFFFFFBEB); // Soft amber tint
      case AlertSeverity.info:
        return const Color(0xFFEFF6FF); // Soft blue tint
      case AlertSeverity.safe:
        return const Color(0xFFF0FDF4); // Soft emerald tint
    }
  }

  static IconData defaultIcon(AlertCategory category, AlertSeverity severity) {
    if (category == AlertCategory.pestDisease) {
      return LucideIcons.bug;
    }
    switch (severity) {
      case AlertSeverity.critical:
        return LucideIcons.cloud_lightning;
      case AlertSeverity.warning:
        return LucideIcons.cloud_rain;
      case AlertSeverity.info:
        return LucideIcons.cloud_sun;
      case AlertSeverity.safe:
        return LucideIcons.sprout;
    }
  }
}
