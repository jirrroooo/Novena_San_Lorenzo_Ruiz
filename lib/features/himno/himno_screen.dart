import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novena_lorenzo/core/content/content_cubit.dart';
import 'package:novena_lorenzo/core/services/hymn_audio.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/core/widgets/credits.dart';
import 'package:novena_lorenzo/core/widgets/page_header.dart';
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
        const PageHeader(
          title: HymnAudio.title,
          subtitle: 'Msgr. Crispin C. Bernarte Jr.',
          actions: [ReadingSettingsButton()],
        ),
        const ReadingSliver(top: 8, bottom: 0, children: [HymnPlayer()]),
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

/// Full player for the hymn: play/pause and a seek bar with times.
class HymnPlayer extends StatefulWidget {
  const HymnPlayer({super.key});

  @override
  State<HymnPlayer> createState() => _HymnPlayerState();
}

class _HymnPlayerState extends State<HymnPlayer> {
  final HymnAudio _audio = HymnAudio.instance;
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    // Loads the audio so its length shows before the first play.
    _audio.load();
  }

  static String _format(Duration d) {
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inMinutes}:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final timeStyle = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return ValueListenableBuilder<bool>(
      valueListenable: _audio.failed,
      builder: (context, failed, _) {
        if (failed) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.error_outline_rounded),
              title: const Text('The hymn could not be played on this device.'),
            ),
          );
        }
        final player = _audio.player;
        return Container(
          padding: const EdgeInsets.fromLTRB(
            Space.l,
            Space.l,
            Space.xl,
            Space.l,
          ),
          decoration: BoxDecoration(
            color: AppTheme.groupColor(theme),
            borderRadius: BorderRadius.circular(AppRadius.group),
            boxShadow: AppShadows.raised(theme.brightness),
          ),
          child: Row(
            children: [
              StreamBuilder<PlayerState>(
                stream: player.playerStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final loading =
                      state == null ||
                      state.processingState == ProcessingState.idle ||
                      state.processingState == ProcessingState.loading;
                  final playing = state != null && HymnAudio.isPlaying(state);
                  return IconButton.filled(
                    iconSize: 32,
                    constraints: const BoxConstraints.tightFor(
                      width: 56,
                      height: 56,
                    ),
                    tooltip: playing ? 'Pause' : 'Play the hymn',
                    onPressed: loading ? null : _audio.toggle,
                    icon: Icon(
                      playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    ),
                  );
                },
              ),
              const SizedBox(width: Space.l),
              Expanded(
                child: StreamBuilder<Duration?>(
                  stream: player.durationStream,
                  builder: (context, durationSnap) {
                    final total = durationSnap.data ?? Duration.zero;
                    return StreamBuilder<Duration>(
                      stream: player.positionStream,
                      builder: (context, positionSnap) {
                        final position = positionSnap.data ?? Duration.zero;
                        final max = total.inMilliseconds.toDouble();
                        final value =
                            (_dragValue ?? position.inMilliseconds.toDouble())
                                .clamp(0.0, max > 0 ? max : 1.0);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Space.m,
                                ),
                              ),
                              child: Slider(
                                value: value,
                                max: max > 0 ? max : 1.0,
                                semanticFormatterCallback: (v) =>
                                    _format(Duration(milliseconds: v.round())),
                                onChanged: max > 0
                                    ? (v) => setState(() => _dragValue = v)
                                    : null,
                                onChangeEnd: (v) {
                                  player.seek(
                                    Duration(milliseconds: v.round()),
                                  );
                                  setState(() => _dragValue = null);
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _format(
                                    Duration(milliseconds: value.round()),
                                  ),
                                  style: timeStyle,
                                ),
                                Text(_format(total), style: timeStyle),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
