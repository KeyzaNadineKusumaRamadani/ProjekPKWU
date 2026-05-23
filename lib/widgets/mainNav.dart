import 'package:flutter/material.dart';
import 'package:projek_kik/views/bottomnavbar.dart';
import 'package:projek_kik/views/dashboard_page.dart';
import 'package:projek_kik/views/menupage.dart';
import 'package:projek_kik/views/profile.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key, required int initialIndex});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    DashboardPage(),
    MenuPage(),
    ProfilePage(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        cartCount: 0,
        onTap: _onNavTap,
      ),
    );
  }
}