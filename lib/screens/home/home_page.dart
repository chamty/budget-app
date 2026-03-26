import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../setting/setting_page.dart';
import '../home/home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<HomeContentState> homeKey = GlobalKey();

  final List<GlobalKey<NavigatorState>> _navKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildTabNavigator(0, HomeContent(key: homeKey)),
          _buildTabNavigator(1, const SettingPage()),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (_selectedIndex == index) {
            _navKeys[index].currentState?.popUntil((r) => r.isFirst);
          }
          setState(() => _selectedIndex = index);

          if (index == 0) {
            homeKey.currentState?.reload();
          }
        },
      ),
    );
  }

  Widget _buildTabNavigator(int index, Widget rootPage) {
    return Navigator(
      key: _navKeys[index],
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => rootPage,
      ),
    );
  }
}