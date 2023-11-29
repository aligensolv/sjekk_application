import 'package:flutter/material.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/presentation/screens/settings_screen.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import 'home_screen.dart';
import 'more_screen.dart';


class BottomScreenNavigator extends StatefulWidget {
  static const String route = '/';
  @override
  _HomeScreenNavigatorState createState() => _HomeScreenNavigatorState();
}

class _HomeScreenNavigatorState extends State<BottomScreenNavigator> {
  int _currentIndex = 0; // Index for the selected tab

  // List of screens to be displayed in the bottom navigation bar
  final List<Widget> _screens = [
    HomeScreen(), // Add your Home Screen widget here
    SettingsScreen(),
    MoreScreen(), // Add your More Screen widget here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,

      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab index
          });
        },
        selectedItemColor: secondaryColor,
        backgroundColor: scaffoldColor,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

