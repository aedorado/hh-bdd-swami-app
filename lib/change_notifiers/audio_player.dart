import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class CurrentAudio extends ChangeNotifier {

  int currentAudioIndex = -1;
  bool audioIsPlaying = false;
  Duration totalAudioDuration;
  Duration currentAudioPosition;
  AudioPlayerState audioPlayerState;

  AudioPlayer audioPlayer;

  CurrentAudio() {

    this.audioPlayer = new AudioPlayer();

    audioPlayer.onDurationChanged.listen((d) {
      this.totalAudioDuration = d;
      notifyListeners();
    });

    audioPlayer.onAudioPositionChanged.listen((p) {
      this.currentAudioPosition = p;
      notifyListeners();
    });

    audioPlayer.onPlayerCompletion.listen((event) {
        this.currentAudioPosition = Duration(seconds: 0);
        this.audioIsPlaying = false;
        notifyListeners();
    });

    audioPlayer.onPlayerStateChanged.listen((ps) {
      this.audioPlayerState = ps;
      notifyListeners();
    });

  }

  void playAudio(String audioUrl) {
    this.audioIsPlaying = true;
    this.audioPlayer.play('https://thegrowingdeveloper.org/files/audios/quiet-time.mp3?b4869097e4');
  }

  void pauseAudio() {
    this.audioIsPlaying = false;
    this.audioPlayer.pause();
  }

  void stopAudio() {
    this.audioIsPlaying = false;
    this.audioPlayer.stop();
  }

}
