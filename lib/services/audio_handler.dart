import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.bddswami.www',
      androidNotificationChannelName: 'HH BBDS App',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      //  TODO: Set android notification icon
      //   androidNotificationIcon:
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) async {
      MediaItem? oldMediaItem = await mediaItem.first;
      final newMediaItem = oldMediaItem?.copyWith(duration: duration);
      mediaItem.add(newMediaItem);
    });
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
        ],
        systemActions: const {MediaAction.seek},
        androidCompactActionIndices: const [0, 1],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  // UriAudioSource _createAudioSource(MediaItem mediaItem) {
  //   return AudioSource.uri(
  //     Uri.parse(mediaItem.extras!['url']),
  //     tag: mediaItem,
  //   );
  // }
  //
  // Future<void> setAudioSource(MediaItem mediaItem) async {
  //   try {
  //     _player.setAudioSource(_createAudioSource(mediaItem));
  //   } catch (e) {
  //     print("Error while setting audio source: $e");
  //   }
  // }

  @override
  Future<void> playMediaItem(MediaItem mi) {
    _player.setUrl(mi.extras!['url']);
    mediaItem.add(mi);
    return _player.play();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }
}
