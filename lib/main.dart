import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'constants/app_constants.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: AppConstants.homeRoute,
  routes: [
    GoRoute(
      path: AppConstants.homeRoute,
      builder: (context, state) => const HomeScreen(),
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