import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../screens/main_scaffold.dart';
import '../screens/placeholder_screen.dart';
import '../screens/about/about_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppConstants.homeRoute,
      builder: (context, state) => const MainScaffold(initialIndex: 0),
    ),
    GoRoute(
      path: AppConstants.browseRoute,
      builder: (context, state) => const MainScaffold(initialIndex: 1),
    ),
    GoRoute(
      path: AppConstants.searchRoute,
      builder: (context, state) => const MainScaffold(initialIndex: 2),
    ),
    GoRoute(
      path: AppConstants.favouritesRoute,
      builder: (context, state) => const MainScaffold(initialIndex: 3),
    ),
    GoRoute(
      path: AppConstants.settingsRoute,
      builder: (context, state) => const MainScaffold(initialIndex: 4),
    ),
    GoRoute(
      path: AppConstants.aboutRoute,
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '${AppConstants.detailRoute}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';

        return PlaceholderScreen(
          title: 'Detail: $id',
          icon: Icons.info_outline,
        );
      },
    ),
  ],
  errorBuilder: (context, state) => const PlaceholderScreen(
    title: 'Page not found',
    icon: Icons.error_outline,
  ),
);
