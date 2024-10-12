import 'package:flutter/material.dart';

class HimnoScreen extends StatefulWidget {
  const HimnoScreen({super.key});

  @override
  State<HimnoScreen> createState() => _HimnoScreenState();
}

class _HimnoScreenState extends State<HimnoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Himno Page"),
      ),
    );
  }
}
