import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    delay();
  }

  Future<void> delay() async {
    await Future.delayed(Duration(seconds: 3));

    Navigator.pushReplacementNamed(context, "/main-navigation");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        color: Colors.red[400],
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    "./assets/logo.png",
                    height: 300,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "NOVENA TO ST. LORENZO RUIZ",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
