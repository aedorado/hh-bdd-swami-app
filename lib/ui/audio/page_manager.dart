import 'package:flutter/foundation.dart';
import '../../notifiers/play_button_notifier.dart';
import '../../notifiers/progress_notifier.dart';
import '../../notifiers/repeat_button_notifier.dart';

import 'package:audio_service/audio_service.dart';
import '../../services/service_locator.dart';
// import 'services/playlist_repository.dart';

class PageManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier =
      ValueNotifier<Map<String, String>>({'title': '', 'subtitle': ''});
  final currentMediaItemNotifier = ValueNotifier<MediaItem?>(null);
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  final _audioHandler = getIt<AudioHandler>();

  void init() async {
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentMediaItemNotifier.value = mediaItem;
    });
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() {}
  void next() {}
  void repeat() {}
  void shuffle() {}
  void add() {}
  void remove() {}

  void playMediaItem(MediaItem mediaItem) async {
    await _audioHandler.playMediaItem(mediaItem);
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      debugPrint('PBS : ' + playbackState.toString());
      final isPlaying = playbackState.playing;
      debugPrint('isPlaying : ' + isPlaying.toString());
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        debugPrint('PBS-1');
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        debugPrint('PBS-2');
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        debugPrint('PBS-3');
        playButtonNotifier.value = ButtonState.playing;
      } else {
        debugPrint('PBS-4');
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void dispose() {
    _audioHandler.customAction('dispose');
  }
}
