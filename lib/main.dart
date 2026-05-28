import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'constants/app_constants.dart';
import 'screens/browse_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: AppConstants.homeRoute,
      builder: (context, state) => const _HomeScreen(),
    ),
    GoRoute(
      path: AppConstants.browseRoute,
      builder: (context, state) => const BrowseScreen(),
    ),
    GoRoute(
      path: AppConstants.searchRoute,
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: const _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Welcome to MoodMatch'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.browse_gallery),
            label: const Text('Browse'),
            onPressed: () {
              context.go(AppConstants.browseRoute);
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.search),
            label: const Text('Search'),
            onPressed: () {
              context.go(AppConstants.searchRoute);
            },
          ),
        ],
      ),
    );
  }
}