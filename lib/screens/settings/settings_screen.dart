import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use the dark app theme'),
              value: isDarkMode,
              onChanged: (value) {
                final nextMode = value ? ThemeMode.dark : ThemeMode.light;
                ref.read(themeModeProvider.notifier).setMode(nextMode);
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              subtitle: const Text('App information and credits'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push(AppConstants.aboutRoute);
              },
            ),
          ),
        ],
      ),
    );
  }
}
