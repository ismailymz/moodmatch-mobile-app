import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../screens/main_scaffold.dart';
import '../screens/placeholder_screen.dart';
import '../models/content_item.dart';
import '../screens/detail_screen.dart';
import '../screens/welcome_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppConstants.welcomeRoute,
      builder: (context, state) => const WelcomeScreen(),
    ),
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
      builder: (context, state) =>
          const PlaceholderScreen(title: 'About', icon: Icons.info_outline),
    ),
    GoRoute(
      path: '${AppConstants.detailRoute}/:id',
      builder: (context, state) {
        // Sayfaya gönderilen ekstra objeyi (ContentItem) alıyoruz
        final item = state.extra as ContentItem?;

        if (item == null) {
          return const PlaceholderScreen(
            title: 'Error: Item not found',
            icon: Icons.error,
          );
        }
        return DetailScreen(item: item);
      },
    ),
  ],
  errorBuilder: (context, state) => const PlaceholderScreen(
    title: 'Page not found',
    icon: Icons.error_outline,
  ),
);
