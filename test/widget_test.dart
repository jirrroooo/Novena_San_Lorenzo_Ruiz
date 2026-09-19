import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novena_lorenzo/app/app.dart';
import 'package:novena_lorenzo/app/main_navigation.dart';
import 'package:novena_lorenzo/core/content/devotion_calendar.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';
import 'package:novena_lorenzo/features/about/about_screen.dart';
import 'package:novena_lorenzo/features/home/home_screen.dart';
import 'package:novena_lorenzo/features/biography/biography_repository.dart';
import 'package:novena_lorenzo/features/himno/himno_repository.dart';
import 'package:novena_lorenzo/features/novena_bikol/novena_bikol_repository.dart';
import 'package:novena_lorenzo/features/novena_english/novena_english_repository.dart';
import 'package:novena_lorenzo/features/perpetual_novena/perpetual_novena_repository.dart';
import 'package:novena_lorenzo/features/prayers/prayer_repository.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  group('content', () {
    test('Bicol novena has nine complete days', () async {
      final novena = await const NovenaBikolRepository().load();
      expect(novena.days, hasLength(9));
      for (final day in novena.days) {
        expect(day.reflection, isNotEmpty);
        expect(day.petitions, isNotEmpty, reason: 'day ${day.order}');
      }
    });

    test('English novena has nine days in order', () async {
      final novena = await const NovenaEnglishRepository().load();
      expect(
        [for (final d in novena.days) d.order],
        [1, 2, 3, 4, 5, 6, 7, 8, 9],
      );
    });

    test('perpetual novena exists in both languages', () async {
      for (final t in Translation.values) {
        final n = await const PerpetualNovenaRepository().load(t);
        expect(n.prayer, isNotEmpty);
      }
    });

    test('prayers, hymn and biography load', () async {
      expect(await const PrayerRepository().load(), isNotEmpty);
      expect((await const HimnoRepository().load()).verses, isNotEmpty);
      expect((await const BiographyRepository().load()).facts, isNotEmpty);
    });
  });

  group('devotion calendar', () {
    test('novena runs September 19 to 27', () {
      expect(DevotionCalendar.novenaDay(DateTime(2026, 9, 18)), isNull);
      expect(DevotionCalendar.novenaDay(DateTime(2026, 9, 19)), 1);
      expect(DevotionCalendar.novenaDay(DateTime(2026, 9, 27)), 9);
      expect(DevotionCalendar.novenaDay(DateTime(2026, 9, 28)), isNull);
      expect(DevotionCalendar.isFeastDay(DateTime(2026, 9, 28)), isTrue);
    });
  });

  group('settings', () {
    test('text size and theme persist', () async {
      final settings = await AppSettings.load();
      expect(settings.textScale, AppSettings.defaultTextScale);
      await settings.setTextScale(1.3);
      await settings.setThemeMode(ThemeMode.dark);

      final reloaded = await AppSettings.load();
      expect(reloaded.textScale, 1.3);
      expect(reloaded.themeMode, ThemeMode.dark);
    });
  });

  testWidgets('app opens on the home tab and switches tabs', (tester) async {
    final settings = await tester.runAsync(AppSettings.load);
    await tester.pumpWidget(NovenaApp(settings: settings!));
    await tester.pump();

    expect(find.byType(MainNavigation), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.text('More'));
    await tester.pump();
    expect(find.byType(AboutScreen), findsOneWidget);
    expect(find.text('Settings & About'), findsWidgets);
  });
}
