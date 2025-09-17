import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  static const String _localeKey = 'selected_language';

  Locale _currentLocale = const Locale('en', 'US');

  Locale get currentLocale => _currentLocale;

  static const Map<String, Locale> supportedLocales = {
    'English': Locale('en', 'US'),
    'Hindi': Locale('hi', 'IN'),
    'Telugu': Locale('te', 'IN'),
  };

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_localeKey) ?? 'English';

    if (supportedLocales.containsKey(savedLanguage)) {
      _currentLocale = supportedLocales[savedLanguage]!;
      notifyListeners();
    }
  }

  Future<void> changeLocale(String languageCode) async {
    if (supportedLocales.containsKey(languageCode)) {
      _currentLocale = supportedLocales[languageCode]!;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);

      notifyListeners();
    }
  }

  String getLanguageNameFromLocale(Locale locale) {
    return supportedLocales.entries
        .firstWhere((entry) => entry.value == locale,
            orElse: () => const MapEntry('English', Locale('en', 'US')))
        .key;
  }
}
