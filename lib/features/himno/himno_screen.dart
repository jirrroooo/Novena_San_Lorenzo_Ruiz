import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novena_lorenzo/core/content/content_cubit.dart';
import 'package:novena_lorenzo/core/services/log_service.dart';
import 'package:novena_lorenzo/core/widgets/collapsing_header.dart';
import 'package:novena_lorenzo/core/widgets/credits.dart';
import 'package:novena_lorenzo/core/widgets/header_art.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/core/widgets/reading_settings_sheet.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/himno/himno_repository.dart';

/// Hymn tab: audio player plus lyrics of "Himno ki San Lorenzo Ruiz".
class HimnoScreen extends StatelessWidget {
  const HimnoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const CollapsingHeader(
          title: 'Himno ki San Lorenzo Ruiz',
          subtitle: 'Msgr. Crispin C. Bernarte Jr.',
          background: HeaderArt(
            icon: Icons.music_note_rounded,
            palette: ArtPalette.mauve,
          ),
          actions: [ReadingSettingsButton()],
        ),
        const ReadingSliver(bottom: 0, children: [HymnPlayer()]),
        ContentSliver<Hymn>(
          load: const HimnoRepository().load,
          builder: (context, hymn) => ReadingSliver(
            top: 8,
            children: [
              const Speaker('Koro'),
              VerseLines(hymn.chorus),
              for (var i = 0; i < hymn.verses.length; i++) ...[
                Speaker('Verso ${i + 1}'),
                VerseLines(hymn.verses[i], italic: false),
              ],
              const ApprovalCredits(translation: Translation.bicol),
            ],
          ),
        ),
      ],
    );
  }
}

class HymnPlayer extends StatefulWidget {
  const HymnPlayer({super.key});

  @override
  State<HymnPlayer> createState() => _HymnPlayerState();
}

class _HymnPlayerState extends State<HymnPlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _failed = false;
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      await _player.setAsset('assets/audio/himno.mp3');
    } catch (e, s) {
      await LogService.instance.error(e, s);
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await _player.seek(Duration.zero);
      await _player.play();
    } else if (state.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  static String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_failed) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.error_outline_rounded, color: scheme.error),
          title: const Text('The hymn audio could not be loaded.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Row(
              children: [
                StreamBuilder<PlayerState>(
                  stream: _player.playerStateStream,
                  builder: (context, snapshot) {
                    final state =
                        snapshot.data ??
                        PlayerState(false, ProcessingState.idle);
                    final loading =
                        state.processingState == ProcessingState.loading ||
                        state.processingState == ProcessingState.buffering;
                    final playing =
                        state.playing &&
                        state.processingState != ProcessingState.completed;
                    return IconButton.filled(
                      iconSize: 36,
                      tooltip: playing ? 'Pause' : 'Play hymn',
                      onPressed: loading ? null : () => _toggle(state),
                      icon: Icon(
                        playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Himno ki San Lorenzo Ruiz',
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        'Listen and sing along',
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            StreamBuilder<Duration?>(
              stream: _player.durationStream,
              builder: (context, durationSnap) {
                final total = durationSnap.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: _player.positionStream,
                  builder: (context, positionSnap) {
                    final position = positionSnap.data ?? Duration.zero;
                    final max = total.inMilliseconds.toDouble();
                    final value =
                        (_dragValue ?? position.inMilliseconds.toDouble())
                            .clamp(0.0, max > 0 ? max : 1.0);
                    return Column(
                      children: [
                        Slider(
                          value: value,
                          max: max > 0 ? max : 1.0,
                          onChanged: max > 0
                              ? (v) => setState(() => _dragValue = v)
                              : null,
                          onChangeEnd: (v) {
                            _player.seek(Duration(milliseconds: v.round()));
                            setState(() => _dragValue = null);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _format(Duration(milliseconds: value.round())),
                                style: textTheme.labelSmall,
                              ),
                              Text(_format(total), style: textTheme.labelSmall),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
