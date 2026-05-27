import 'package:flutter/material.dart';

import 'placeholder_screen.dart';

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
      screen: PlaceholderScreen(title: 'Home', icon: Icons.home),
    ),
    _ScaffoldTab(
      label: 'Browse',
      icon: Icons.explore,
      screen: PlaceholderScreen(title: 'Browse', icon: Icons.explore),
    ),
    _ScaffoldTab(
      label: 'Search',
      icon: Icons.search,
      screen: PlaceholderScreen(title: 'Search', icon: Icons.search),
    ),
    _ScaffoldTab(
      label: 'Favourites',
      icon: Icons.favorite,
      screen: PlaceholderScreen(title: 'Favourites', icon: Icons.favorite),
    ),
    _ScaffoldTab(
      label: 'Settings',
      icon: Icons.settings,
      screen: PlaceholderScreen(title: 'Settings', icon: Icons.settings),
    ),
  ];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _validInitialIndex(widget.initialIndex);
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
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class _ScaffoldTab {
  const _ScaffoldTab({
    required this.label,
    required this.icon,
    required this.screen,
  });

  final String label;
  final IconData icon;
  final Widget screen;
}
