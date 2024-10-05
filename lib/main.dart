import 'package:flutter/material.dart';
import 'package:novena_lorenzo/homepage.dart';
import 'package:novena_lorenzo/novena_bikol/screens/novena_bikol_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static const List screens = [
    HomePage(),
    NovenaBikolHome(),
    HomePage(),
    HomePage(),
    HomePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Novena to San Lorenzo Ruiz',
        debugShowCheckedModeBanner: false,
        // routes: {"/": (BuildContext context) => const HomePage()},
        // initialRoute: "/",
        home: Scaffold(
          body: screens.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_rounded), label: "Novena"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.music_note_rounded), label: "Hymn"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.church), label: "Prayers"),
              BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.black54,
            showUnselectedLabels: true,
            onTap: _onItemTapped,
          ),
        ));
  }
}
