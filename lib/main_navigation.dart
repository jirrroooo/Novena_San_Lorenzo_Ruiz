import 'package:flutter/material.dart';
import 'package:novena_lorenzo/features/about/screens/about_screen.dart';
import 'package:novena_lorenzo/features/himno/screens/himno_screen.dart';
import 'package:novena_lorenzo/features/prayers/screens/prayers_screen_home.dart';
import 'package:novena_lorenzo/homepage.dart';
import 'package:novena_lorenzo/features/novena_bikol/screens/novena_bikol_home.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List screens = [
    HomePage(),
    NovenaBikolHome(),
    HimnoScreen(),
    PrayersScreenHome(),
    AboutScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.church), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded), label: "Novena"),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note_rounded), label: "Hymn"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fireplace_rounded), label: "Prayers"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[400],
        unselectedItemColor: Colors.grey[700],
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
