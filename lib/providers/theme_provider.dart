import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    unawaited(loadThemeMode());
  }

  static const String _prefsKey = 'theme_mode';
  static const String _systemValue = 'system';
  static const String _lightValue = 'light';
  static const String _darkValue = 'dark';

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_prefsKey);

    state = _themeModeFromString(savedMode);
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _themeModeToString(mode));
  }

  Future<void> toggle() async {
    final nextMode = switch (state) {
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.system => ThemeMode.dark,
    };

    await setMode(nextMode);
  }

  static ThemeMode _themeModeFromString(String? value) {
    return switch (value) {
      _lightValue => ThemeMode.light,
      _darkValue => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static String _themeModeToString(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => _lightValue,
      ThemeMode.dark => _darkValue,
      ThemeMode.system => _systemValue,
    };
  }
}
