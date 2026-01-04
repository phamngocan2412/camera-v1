import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences sharedPreferences;

  SettingsCubit({required this.sharedPreferences})
    : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final themeIndex =
        sharedPreferences.getInt('theme_mode') ??
        0; // 0: system, 1: light, 2: dark
    final languageCode = sharedPreferences.getString('language_code') ?? 'en';
    final countryCode = sharedPreferences.getString('country_code') ?? 'US';

    ThemeMode themeMode;
    switch (themeIndex) {
      case 1:
        themeMode = ThemeMode.light;
        break;
      case 2:
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    emit(
      state.copyWith(
        themeMode: themeMode,
        locale: Locale(languageCode, countryCode),
      ),
    );
  }

  Future<void> toggleTheme(bool isDark) async {
    final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: themeMode));
    await sharedPreferences.setInt('theme_mode', isDark ? 2 : 1);
  }

  Future<void> setLocale(Locale locale) async {
    emit(state.copyWith(locale: locale));
    await sharedPreferences.setString('language_code', locale.languageCode);
    await sharedPreferences.setString('country_code', locale.countryCode ?? '');
  }
}
