import 'package:flutter/material.dart';

import 'package:projek_kik/views/bottomnavbar.dart';
import 'package:projek_kik/views/dashboard_page.dart';
import 'package:projek_kik/views/menupage.dart';
import 'package:projek_kik/views/profile.dart';

class MainNav extends StatefulWidget {
  final int initialIndex;

  const MainNav({
    super.key,
    required this.initialIndex,
  });

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  late int _currentIndex;

  final List<Widget> pages = [
    DashboardPage(),
    MenuPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

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