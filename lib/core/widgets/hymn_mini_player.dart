import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novena_lorenzo/core/services/hymn_audio.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';

/// Compact player shown at the bottom of other screens while the hymn plays,
/// so it can be paused or stopped without going back to the Hymn tab.
class HymnMiniPlayer extends StatelessWidget {
  const HymnMiniPlayer({
    super.key,
    this.onOpen,
    this.includeBottomInset = false,
  });

  /// Opens the full player; defaults to [HymnAudio.openPlayer].
  final VoidCallback? onOpen;

  /// Adds the gesture-bar inset below the player (when it is the last thing
  /// on screen rather than sitting above the navigation bar).
  final bool includeBottomInset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final audio = HymnAudio.instance;
    final bottom =
        Space.s +
        (includeBottomInset ? MediaQuery.paddingOf(context).bottom : 0);

    return Padding(
      padding: EdgeInsets.fromLTRB(Space.s, Space.s, Space.s, bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.group),
          boxShadow: AppShadows.raised(theme.brightness),
        ),
        child: Material(
          color: AppTheme.groupColor(theme),
          borderRadius: BorderRadius.circular(AppRadius.group),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onOpen ?? audio.openPlayer,
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  const SizedBox(width: Space.xs),
                  StreamBuilder<PlayerState>(
                    stream: audio.player.playerStateStream,
                    builder: (context, snapshot) {
                      final playing =
                          snapshot.hasData &&
                          HymnAudio.isPlaying(snapshot.data!);
                      return IconButton(
                        tooltip: playing ? 'Pause the hymn' : 'Play the hymn',
                        onPressed: audio.toggle,
                        icon: Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: scheme.primary,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: Space.xs),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          HymnAudio.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: Space.s),
                        _Progress(player: audio.player),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Stop the hymn',
                    onPressed: audio.stop,
                    icon: Icon(
                      Icons.close_rounded,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: Space.xs),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.player});

  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      builder: (context, snapshot) {
        final total = player.duration?.inMilliseconds ?? 0;
        final position = snapshot.data?.inMilliseconds ?? 0;
        return ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: total > 0 ? (position / total).clamp(0.0, 1.0) : 0,
            minHeight: 3,
            backgroundColor: Theme.of(context).colorScheme.primary
                .withValues(alpha: 0.15),
          ),
        );
      },
    );
  }
}

/// Scaffold for pages pushed over the tabs (novenas, prayers). It shows the
/// [HymnMiniPlayer] at the bottom while the hymn plays.
class PageScaffold extends StatelessWidget {
  const PageScaffold({super.key, required this.slivers});

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: HymnAudio.instance.active,
        builder: (context, playing, _) => Column(
          children: [
            Expanded(
              // The mini player takes over the bottom inset while shown.
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: playing,
                child: CustomScrollView(slivers: slivers),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: playing
                  ? const HymnMiniPlayer(includeBottomInset: true)
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
