import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moodmatch_mobile_app/providers/theme_provider.dart';

void main() {
  const prefsKey = 'theme_mode';

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to ThemeMode.system when no value is saved', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(themeModeProvider.notifier);

    await notifier.loadThemeMode();

    expect(container.read(themeModeProvider), ThemeMode.system);
  });

  test('toggle from ThemeMode.light changes to ThemeMode.dark', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(themeModeProvider.notifier);

    await notifier.setMode(ThemeMode.light);
    await notifier.toggle();

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  test('toggle from ThemeMode.dark changes to ThemeMode.light', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(themeModeProvider.notifier);

    await notifier.setMode(ThemeMode.dark);
    await notifier.toggle();

    expect(container.read(themeModeProvider), ThemeMode.light);
  });

  test('setMode ThemeMode.dark persists dark', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(themeModeProvider.notifier);

    await notifier.setMode(ThemeMode.dark);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(prefsKey), 'dark');
  });

  test('setMode ThemeMode.light persists light', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(themeModeProvider.notifier);

    await notifier.setMode(ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(prefsKey), 'light');
  });
}
