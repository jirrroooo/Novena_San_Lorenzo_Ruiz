import 'package:flutter/material.dart';

class PrayerScreenPage extends StatefulWidget {
  const PrayerScreenPage({super.key});

  @override
  State<PrayerScreenPage> createState() => _PrayerScreenPageState();
}

class _PrayerScreenPageState extends State<PrayerScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Text("Prayer Screen Page"),
      ),
    );
  }
}
