import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class CurrentAudio extends ChangeNotifier {

  bool _audioIsPlaying = false;
  Duration _totalAudioDuration;
  Duration _currentAudioPosition;
  AudioPlayerState _audioPlayerState;

  AudioPlayer audioPlayer = new AudioPlayer();

  CurrentAudio() {
    audioPlayer.onDurationChanged.listen((d) {
      _totalAudioDuration = d;
      notifyListeners();
    });

    audioPlayer.onAudioPositionChanged.listen((p) {
      _currentAudioPosition = p;
      notifyListeners();
    });

    audioPlayer.onPlayerCompletion.listen((event) {
        _currentAudioPosition = Duration(seconds: 0);
        _audioIsPlaying = false;
        notifyListeners();
    });

    audioPlayer.onPlayerStateChanged.listen((ps) {
      _audioPlayerState = ps;
      notifyListeners();
    });

    startAudio(String audioUrl, int audioIndex) {
      _audioIsPlaying = true;
      audioPlayer.play('https://thegrowingdeveloper.org/files/audios/quiet-time.mp3?b4869097e4');
    }

    pauseAudio() {
      _audioIsPlaying = false;
      audioPlayer.pause();
    }

    stopAudio() {
      _audioIsPlaying = false;
      audioPlayer.stop();
    }

  }

}
