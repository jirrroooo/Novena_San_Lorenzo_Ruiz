import 'package:flutter/material.dart';
import 'package:novena_lorenzo/app/main_navigation.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/features/novena_bikol/novena_bikol_screens.dart';
import 'package:novena_lorenzo/features/novena_english/novena_english_screens.dart';
import 'package:novena_lorenzo/features/perpetual_novena/perpetual_novena_screen.dart';

class NovenaApp extends StatelessWidget {
  const NovenaApp({super.key, required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      settings: settings,
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, _) => MaterialApp(
          title: 'St. Lorenzo Ruiz Novena',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settings.themeMode,
          home: const MainNavigation(),
          routes: {
            NovenaBikolHome.routeName: (_) => const NovenaBikolHome(),
            NovenaEnglishHome.routeName: (_) => const NovenaEnglishHome(),
            PerpetualNovenaScreen.routeName: (_) =>
                const PerpetualNovenaScreen(),
          },
        ),
      ),
    );
  }
}
