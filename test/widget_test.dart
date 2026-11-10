import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novena_lorenzo/app/app.dart';
import 'package:novena_lorenzo/app/main_navigation.dart';
import 'package:novena_lorenzo/core/content/devotion_calendar.dart';
import 'package:novena_lorenzo/core/services/link_service.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
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
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// Records launched URLs; [opens] says whether an app handled them.
class _FakeLauncher extends UrlLauncherPlatform {
  _FakeLauncher({required this.opens});

  final bool opens;
  final List<String> launched = [];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    return opens;
  }
}

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

    test('next day of devotion is the coming 28th', () {
      expect(
        DevotionCalendar.nextDevotionDay(DateTime(2026, 11, 9)),
        DateTime(2026, 11, 28),
      );
      expect(
        DevotionCalendar.nextDevotionDay(DateTime(2026, 11, 28)),
        DateTime(2026, 11, 28),
      );
      expect(
        DevotionCalendar.nextDevotionDay(DateTime(2026, 12, 29)),
        DateTime(2027, 1, 28),
      );
    });

    test('next novena starts on September 19', () {
      expect(
        DevotionCalendar.nextNovenaStart(DateTime(2026, 8, 30)),
        DateTime(2026, 9, 19),
      );
      expect(
        DevotionCalendar.nextNovenaStart(DateTime(2026, 9, 30)),
        DateTime(2027, 9, 19),
      );
      expect(
        DevotionCalendar.daysBetween(
          DateTime(2026, 11, 9, 23),
          DateTime(2026, 11, 28),
        ),
        19,
      );
      expect(DevotionCalendar.relative(1), 'tomorrow');
      expect(DevotionCalendar.relative(19), 'in 19 days');
    });
  });

  group('today card', () {
    Future<void> pumpCard(WidgetTester tester, DateTime date) =>
        tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: TodayCard(date: date, onPlayHymn: () {}),
            ),
          ),
        );

    testWidgets('shows the novena day during the novena', (tester) async {
      await pumpCard(tester, DateTime(2026, 9, 21));
      expect(find.text('Day 3 of 9'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Bicol'), findsOneWidget);
    });

    testWidgets('shows the feast and the monthly devotion', (tester) async {
      await pumpCard(tester, DateTime(2026, 9, 28));
      expect(find.text('Feast of St. Lorenzo Ruiz'), findsOneWidget);
      await pumpCard(tester, DateTime(2026, 10, 28));
      expect(find.text('Day of devotion'), findsOneWidget);
    });

    testWidgets('counts down on other days', (tester) async {
      await pumpCard(tester, DateTime(2026, 9, 5));
      expect(find.text('Begins in 14 days'), findsOneWidget);
      await pumpCard(tester, DateTime(2026, 11, 9));
      expect(find.text('November 28'), findsOneWidget);
      expect(find.text('in 19 days'), findsOneWidget);
    });
  });

  group('feedback email', () {
    final original = UrlLauncherPlatform.instance;
    tearDown(() => UrlLauncherPlatform.instance = original);

    Future<void> tapEmail(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => LinkService.email(
                  context,
                  'someone@example.com',
                  subject: 'St. Lorenzo Ruiz Novena',
                ),
                child: const Text('Email'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Email'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    testWidgets('opens the mail app with the subject', (tester) async {
      final launcher = _FakeLauncher(opens: true);
      UrlLauncherPlatform.instance = launcher;
      await tapEmail(tester);
      expect(launcher.launched, [
        'mailto:someone@example.com?subject=St.%20Lorenzo%20Ruiz%20Novena',
      ]);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('copies the address when there is no mail app', (tester) async {
      UrlLauncherPlatform.instance = _FakeLauncher(opens: false);
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await tapEmail(tester);
      expect(copied, 'someone@example.com');
      expect(
        find.text('No email app found. someone@example.com was copied.'),
        findsOneWidget,
      );
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
