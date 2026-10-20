import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_translations.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _prefKey = 'selected_language';
  String _currentLocale = 'hi'; // Default Hindi-first as requested

  String get currentLocale => _currentLocale;
  bool get isHindi => _currentLocale == 'hi';

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_prefKey);
      if (savedLocale != null && (savedLocale == 'hi' || savedLocale == 'en')) {
        _currentLocale = savedLocale;
        notifyListeners();
      }
    } catch (_) {
      // Fallback to default Hindi
    }
  }

  Future<void> setLanguage(String localeCode) async {
    if (localeCode == _currentLocale) return;
    _currentLocale = localeCode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, localeCode);
    } catch (_) {}
  }

  void toggleLanguage() {
    final next = _currentLocale == 'hi' ? 'en' : 'hi';
    setLanguage(next);
  }

  String tr(String key) {
    return AppTranslations.get(key, _currentLocale);
  }
}
