import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';

class CurrentAudio extends ChangeNotifier {

  Audio audio;
  int currentAudioIndex = -1;
  bool isPlaying = false;
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
        this.isPlaying = false;
        notifyListeners();
    });

    audioPlayer.onPlayerStateChanged.listen((ps) {
      this.audioPlayerState = ps;
      notifyListeners();
    });

  }

  void playAudio() {
    this.isPlaying = true;
    this.audioPlayer.play(this.audio.url);
    notifyListeners();
  }

  void pauseAudio() {
    this.isPlaying = false;
    this.audioPlayer.pause();
    notifyListeners();
  }

  void stopAudio() {
    this.audio = null;
    this.audioPlayer.stop();
    this.isPlaying = false;
    this.currentAudioIndex = -1;
    this.currentAudioPosition = Duration(seconds: 0);
    this.audioPlayer.release();
    notifyListeners();
  }

}
