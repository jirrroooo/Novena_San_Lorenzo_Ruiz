import 'package:flutter/material.dart';

class PrayersScreenHome extends StatefulWidget {
  const PrayersScreenHome({super.key});

  @override
  State<PrayersScreenHome> createState() => _PrayersScreenHomeState();
}

class _PrayersScreenHomeState extends State<PrayersScreenHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: Text("Prayer Screen Home"),
        ));
  }
}
