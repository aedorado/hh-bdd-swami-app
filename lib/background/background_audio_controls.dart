import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerBackgroundTasks extends BackgroundAudioTask {
  final _audioPlayer = AudioPlayer();

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.connecting);
    // Connect to the URL
    // await _audioPlayer.setUrl(params["url"]);

    // Now we're ready to play
    // _audioPlayer.play();
    // Broadcast that we're playing, and what controls are available.
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.ready);
  }

  @override
  Future<void> onStop() async {
    AudioServiceBackground.setState(
        controls: [],
        playing: false,
        processingState: AudioProcessingState.ready);
    await _audioPlayer.stop();
    await super.onStop();
  }

  @override
  Future<void> onPlay() async{
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.ready);
    await _audioPlayer.play();
    return super.onPlay();
  }

  @override
  Future<void> onPause() async{
    AudioServiceBackground.setState(
        controls: [MediaControl.play, MediaControl.stop],
        playing: false,
        processingState: AudioProcessingState.ready);
    await _audioPlayer.pause();
    return super.onPause();
  }

  @override
  Future<void> onUpdateMediaItem(MediaItem mediaItem) {
    debugPrint('Current MediaIteam changed');
    AudioServiceBackground.setMediaItem(mediaItem);
    return super.onUpdateMediaItem(mediaItem);
  }

  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    Duration d = await _audioPlayer.setUrl(mediaItem.extras['url']);
    _audioPlayer.play();
    debugPrint('Duration: ${d.toString()}');
    this.onUpdateMediaItem(mediaItem.copyWith(duration: d));
    return super.onPlayMediaItem(mediaItem);
  }

}