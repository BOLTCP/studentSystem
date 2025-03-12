import 'package:flutter/material.dart';

Widget buildBottomNavigation(
    int selectedIndex, Function(int) onItemTappedTeacherDashboard) {
  return BottomNavigationBar(
    currentIndex: selectedIndex,
    onTap: onItemTappedTeacherDashboard,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
        backgroundColor: Colors.blue,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
        backgroundColor: Colors.blue,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: 'Notifications',
        backgroundColor: Colors.blue,
      ),
    ],
  );
}
