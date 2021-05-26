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

  void playAudio(String audioUrl, int audioIndex) {
    this.currentAudioIndex = audioIndex;
    this.audioIsPlaying = true;
    this.audioPlayer.play(audioUrl);
    notifyListeners();
  }

  void pauseAudio() {
    this.audioIsPlaying = false;
    this.audioPlayer.pause();
    notifyListeners();
  }

  void stopAudio() {
    debugPrint("Stopping Audio");
    this.audioPlayer.stop();
    this.audioIsPlaying = false;
    this.currentAudioIndex = -1;
    this.currentAudioPosition = Duration(seconds: 0);
    notifyListeners();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   this.audioPlayer.release();
  // }

}
