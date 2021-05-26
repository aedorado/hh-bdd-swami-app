import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class CurrentAudio extends ChangeNotifier {

  bool _audioIsPlaying = false;
  Duration totalAudioDuration;
  Duration currentAudioPosition;
  AudioPlayerState _audioPlayerState;

  AudioPlayer audioPlayer = new AudioPlayer();

  CurrentAudio() {
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
        this._audioIsPlaying = false;
        notifyListeners();
    });

    audioPlayer.onPlayerStateChanged.listen((ps) {
      this._audioPlayerState = ps;
      notifyListeners();
    });

  }

  void playAudio(String audioUrl) {
    _audioIsPlaying = true;
    audioPlayer.play('https://thegrowingdeveloper.org/files/audios/quiet-time.mp3?b4869097e4');
  }

  void pauseAudio() {
    _audioIsPlaying = false;
    audioPlayer.pause();
  }

  void stopAudio() {
    _audioIsPlaying = false;
    audioPlayer.stop();
  }

}
