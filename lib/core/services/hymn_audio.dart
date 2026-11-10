import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novena_lorenzo/core/services/log_service.dart';

/// The hymn's audio player, shared by the Hymn tab and the mini player so
/// playback can be paused or stopped from any screen.
///
/// The player is created and the audio loaded on first use.
class HymnAudio {
  HymnAudio._();

  static final HymnAudio instance = HymnAudio._();

  static const String title = 'Himno ki San Lorenzo Ruiz';
  static const String _asset = 'assets/audio/himno.mp3';

  AudioPlayer? _player;
  Future<void>? _loading;

  /// True from the first play until the hymn ends or is stopped. The mini
  /// player is shown while this is set.
  final ValueNotifier<bool> active = ValueNotifier(false);

  /// True when the audio could not be loaded on this device.
  final ValueNotifier<bool> failed = ValueNotifier(false);

  /// Opens the full player; set by the tab shell so the mini player on any
  /// screen can lead back to the Hymn tab.
  VoidCallback? openPlayer;

  AudioPlayer get player => _player ??= AudioPlayer();

  /// Loads the audio once; later calls return the same future.
  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      await player.setAsset(_asset);
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          active.value = false;
        }
      });
    } catch (e, s) {
      await LogService.instance.error(e, s);
      failed.value = true;
    }
  }

  static bool isPlaying(PlayerState state) =>
      state.playing && state.processingState != ProcessingState.completed;

  Future<void> play() async {
    await load();
    if (failed.value) return;
    if (player.processingState == ProcessingState.completed) {
      await player.seek(Duration.zero);
    }
    active.value = true;
    // Completes only when playback stops, so it is not awaited.
    unawaited(player.play());
  }

  Future<void> toggle() async {
    if (_player != null && isPlaying(player.playerState)) {
      await player.pause();
    } else {
      await play();
    }
  }

  /// Stops playback and hides the mini player.
  Future<void> stop() async {
    active.value = false;
    await player.pause();
    await player.seek(Duration.zero);
  }
}
