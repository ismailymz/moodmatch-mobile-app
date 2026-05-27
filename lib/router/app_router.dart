import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../screens/about/about_screen.dart';
import '../screens/search_screen.dart';
import '../screens/settings/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppConstants.homeRoute,
      builder: (context, state) => const _HomeScreen(),
    ),
    GoRoute(
      path: AppConstants.searchRoute,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: AppConstants.settingsRoute,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppConstants.aboutRoute,
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Welcome to MoodMatch'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Open Search'),
              onPressed: () {
                context.push(AppConstants.searchRoute);
              },
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
              onPressed: () {
                context.push(AppConstants.settingsRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
