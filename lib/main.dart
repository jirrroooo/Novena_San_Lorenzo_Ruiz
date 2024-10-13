import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/features/about/screens/about_screen.dart';
import 'package:novena_lorenzo/features/biography/screens/biography_screen.dart';
import 'package:novena_lorenzo/features/himno/screens/himno_screen.dart';
import 'package:novena_lorenzo/features/novena_english/screens/novena_english_home.dart';
import 'package:novena_lorenzo/features/novena_english/screens/novena_english_page.dart';
import 'package:novena_lorenzo/features/prayers/screens/prayer_screen_page.dart';
import 'package:novena_lorenzo/features/prayers/screens/prayers_screen_home.dart';
import 'package:novena_lorenzo/homepage.dart';
import 'package:novena_lorenzo/main_navigation.dart';
import 'package:novena_lorenzo/features/novena_bikol/screens/novena_bikol_home.dart';
import 'package:novena_lorenzo/features/novena_bikol/screens/novena_bikol_page.dart';
import 'package:novena_lorenzo/widgets/scripture/bloc/scripture_bloc.dart';
import 'package:novena_lorenzo/widgets/scripture/repository/scripture_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScriptureBloc>(
            create: (BuildContext context) =>
                ScriptureBloc(ScriptureRepository()))
      ],
      child: MaterialApp(
        title: 'Novena to San Lorenzo Ruiz',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (BuildContext context) => const MainNavigation(),
          "/homepage": (BuildContext context) => const HomePage(),
          "/bikol-novena-home": (BuildContext context) => NovenaBikolHome(),
          "/bikol-novena-page": (BuildContext context) =>
              NovenaBikolPage(novenaDay: 1),
          "/english-novena-home": (BuildContext context) => NovenaEnglishHome(),
          "/english-novena-page": (BuildContext context) =>
              NovenaEnglishPage(novenaDay: 1),
          "/himno": (BuildContext context) => HimnoScreen(),
          "/prayers-home": (BuildContext context) => PrayersScreenHome(),
          "/prayers-page": (BuildContext context) => PrayerScreenPage(),
          "/about": (BuildContext context) => AboutScreen(),
          "/biography": (BuildContext context) => BiographyScreen(),
        },
      ),
    );
  }
}
