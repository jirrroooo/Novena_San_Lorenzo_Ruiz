import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/services/hymn_audio.dart';
import 'package:novena_lorenzo/core/widgets/hymn_mini_player.dart';
import 'package:novena_lorenzo/features/about/about_screen.dart';
import 'package:novena_lorenzo/features/biography/biography_screen.dart';
import 'package:novena_lorenzo/features/himno/himno_screen.dart';
import 'package:novena_lorenzo/features/home/home_screen.dart';
import 'package:novena_lorenzo/features/prayers/prayers_screens.dart';

enum AppTab { home, prayers, hymn, life, more }

/// Bottom-navigation shell. Tabs are built on first visit and then kept
/// alive, so scroll position and the hymn player survive tab switches.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  static MainNavigationState of(BuildContext context) =>
      context.findAncestorStateOfType<MainNavigationState>()!;

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  AppTab _tab = AppTab.home;
  final Set<AppTab> _visited = {AppTab.home};

  @override
  void initState() {
    super.initState();
    // The mini player on any screen leads back to the Hymn tab.
    HymnAudio.instance.openPlayer = () {
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      select(AppTab.hymn);
    };
  }

  @override
  void dispose() {
    HymnAudio.instance.openPlayer = null;
    super.dispose();
  }

  void select(AppTab tab) {
    setState(() {
      _tab = tab;
      _visited.add(tab);
    });
  }

  Widget _screen(AppTab tab) => switch (tab) {
    AppTab.home => const HomeScreen(),
    AppTab.prayers => const PrayersScreen(),
    AppTab.hymn => const HimnoScreen(),
    AppTab.life => const BiographyScreen(),
    AppTab.more => const AboutScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Back from another tab returns to Home before leaving the app.
      canPop: _tab == AppTab.home,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) select(AppTab.home);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _tab.index,
          children: [
            for (final tab in AppTab.values)
              _visited.contains(tab) ? _screen(tab) : const SizedBox.shrink(),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: HymnAudio.instance.active,
              builder: (context, playing, _) => AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: playing && _tab != AppTab.hymn
                    ? HymnMiniPlayer(onOpen: () => select(AppTab.hymn))
                    : const SizedBox(width: double.infinity),
              ),
            ),
            NavigationBar(
              selectedIndex: _tab.index,
              onDestinationSelected: (i) => select(AppTab.values[i]),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.volunteer_activism_outlined),
                  selectedIcon: Icon(Icons.volunteer_activism_rounded),
                  label: 'Prayers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.music_note_outlined),
                  selectedIcon: Icon(Icons.music_note_rounded),
                  label: 'Hymn',
                ),
                NavigationDestination(
                  icon: Icon(Icons.auto_stories_outlined),
                  selectedIcon: Icon(Icons.auto_stories_rounded),
                  label: 'His Life',
                ),
                NavigationDestination(
                  icon: Icon(Icons.more_horiz_rounded),
                  selectedIcon: Icon(Icons.more_horiz_rounded),
                  label: 'More',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
