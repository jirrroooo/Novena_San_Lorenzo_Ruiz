import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novena_lorenzo/features/about/screens/about_screen.dart';
import 'package:novena_lorenzo/features/biography/screens/biography_screen.dart';
import 'package:novena_lorenzo/features/novena_bikol/bloc/novena_bikol_bloc.dart';
import 'package:novena_lorenzo/features/novena_bikol/repository/novena_bikol_repository.dart';
import 'package:novena_lorenzo/features/novena_english/bloc/novena_english_bloc.dart';
import 'package:novena_lorenzo/features/novena_english/repository/novena_english_repository.dart';
import 'package:novena_lorenzo/features/perpetual_novena/bloc/perpetual_novena_bloc.dart';
import 'package:novena_lorenzo/features/perpetual_novena/repository/perpetual_novena_repository.dart';
import 'package:novena_lorenzo/features/perpetual_novena/screens/perpetual_novena_screen.dart';
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
                ScriptureBloc(ScriptureRepository())),
        BlocProvider<PerpetualNovenaBloc>(
            create: (BuildContext context) =>
                PerpetualNovenaBloc(PerpetualNovenaRepository())),
        BlocProvider<NovenaBikolBloc>(
            create: (BuildContext context) =>
                NovenaBikolBloc(NovenaBikolRepository())),
        BlocProvider<NovenaEnglishBloc>(
            create: (BuildContext context) =>
                NovenaEnglishBloc(NovenaEnglishRepository()))
      ],
      child: MaterialApp(
        title: 'Novena to San Lorenzo Ruiz',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (BuildContext context) => const MainNavigation(),
          "/homepage": (BuildContext context) => const HomePage(),
          "/bicol-novena-home": (BuildContext context) => NovenaBikolHome(),
          "/bicol-novena-page": (BuildContext context) =>
              NovenaBikolPage(novenaDay: 1),
          "/english-novena-home": (BuildContext context) => NovenaEnglishHome(),
          "/english-novena-page": (BuildContext context) =>
              NovenaEnglishPage(novenaDay: 1),
          "/perpetual-novena": (BuildContext context) =>
              PerpetualNovenaScreen(),
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
