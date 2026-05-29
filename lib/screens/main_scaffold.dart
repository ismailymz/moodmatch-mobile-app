import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import 'browse_screen.dart';
import 'home_screen.dart';
import 'settings/settings_screen.dart';
import 'placeholder_screen.dart';
import 'search_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({this.initialIndex = 0, super.key});

  final int initialIndex;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  static const _tabs = [
    _ScaffoldTab(
      label: 'Home',
      icon: Icons.home,
      route: AppConstants.homeRoute,
      screen: HomeScreen(),
    ),
    _ScaffoldTab(
      label: 'Browse',
      icon: Icons.explore,
      route: AppConstants.browseRoute,
      screen: BrowseScreen(),
    ),
    _ScaffoldTab(
      label: 'Search',
      icon: Icons.search,
      route: AppConstants.searchRoute,
      screen: SearchScreen(),
    ),
    _ScaffoldTab(
      label: 'Favourites',
      icon: Icons.favorite,
      route: AppConstants.favouritesRoute,
      screen: PlaceholderScreen(title: 'Favourites', icon: Icons.favorite),
    ),
    _ScaffoldTab(
      label: 'Settings',
      icon: Icons.settings,
      route: AppConstants.settingsRoute,
      screen: SettingsScreen(),
    ),
  ];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _validInitialIndex(widget.initialIndex);
  }

  @override
  void didUpdateWidget(covariant MainScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialIndex != widget.initialIndex) {
      _selectedIndex = _validInitialIndex(widget.initialIndex);
    }
  }

  int _validInitialIndex(int initialIndex) {
    if (initialIndex < 0) {
      return 0;
    }

    if (initialIndex >= _tabs.length) {
      return _tabs.length - 1;
    }

    return initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = _tabs[_selectedIndex];

    return Scaffold(
      appBar: AppBar(title: Text(selectedTab.label)),
      body: SafeArea(child: selectedTab.screen),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: _tabs
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                label: tab.label,
              ),
            )
            .toList(),
        onTap: (index) {
          if (index == _selectedIndex) {
            return;
          }

          setState(() {
            _selectedIndex = index;
          });
          context.go(_tabs[index].route);
        },
      ),
    );
  }
}

class _ScaffoldTab {
  const _ScaffoldTab({
    required this.label,
    required this.icon,
    required this.route,
    required this.screen,
  });

  final String label;
  final IconData icon;
  final String route;
  final Widget screen;
}
