import 'package:flutter/material.dart';

enum NavTab {
  home(Icons.home, 'ホーム'),
  settings(Icons.settings, '設定');

  final IconData icon;
  final String label;
  const NavTab(this.icon, this.label);
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: NavTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          label: tab.label,
        );
      }).toList(),
    );
  }
}