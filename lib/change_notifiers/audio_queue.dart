import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';

class AudioQueue extends ChangeNotifier {

  bool repeat = true;
  int nowPlaying;
  List<Audio> audioList;
  CurrentAudio currentAudio;
  bool shuffle = true;

  AudioQueue() {
    this.nowPlaying = -1;
    this.audioList = [];
    this.currentAudio = new CurrentAudio();

    this.currentAudio.audioPlayer.onPlayerCompletion.listen((event) {
      debugPrint('An audio got completed.');
      this.currentAudio.currentAudioPosition = Duration(seconds: 0);
      this.currentAudio.isPlaying = false;
      // notifyListeners();
      this.playNext();
    });

    this.currentAudio.audioPlayer.onDurationChanged.listen((d) {
      this.currentAudio.totalAudioDuration = d;
      notifyListeners();
    });

    this.currentAudio.audioPlayer.onAudioPositionChanged.listen((p) {
      this.currentAudio.currentAudioPosition = p;
      notifyListeners();
    });

    this.currentAudio.audioPlayer.onPlayerStateChanged.listen((ps) {
      this.currentAudio.audioPlayerState = ps;
      notifyListeners();
    });

  }

  bool addAudio(Audio a) {
    if (this.audioList.firstWhere((audioFromList) => audioFromList.id == a.id, orElse: () => null) == null) {
      this.audioList.add(a);
      notifyListeners();
      return true;
    }
    return false;
  }

  Audio getAt(int index) {
    if (index < audioList.length) {
      return this.audioList.elementAt(index);
    } else {
      return null;
    }
  }

  void addAudioAt(int index, Audio a) {
    this.audioList.insert(index, a);
    notifyListeners();
  }

  void removeAudioAt(int index) {
    this.audioList.removeAt(index);
    this.nowPlaying = this.audioList.indexWhere((audioFromList) => audioFromList.id == this.currentAudio.audio.id);
    debugPrint('${this.audioList}, Now Playing: $nowPlaying');
    notifyListeners();
  }

  void removeAudio(Audio a) {
    this.audioList.removeWhere((element) => element.id == a.id);
    this.nowPlaying = this.audioList.indexWhere((audioFromList) => audioFromList.id == this.currentAudio.audio.id);
    debugPrint('${this.audioList}, Now Playing: $nowPlaying');
    notifyListeners();
  }
  
  int size() {
    return this.audioList.length;
  }

  // [a0, a1, a2, a3, a4]
  //      ^
  //      nowPlaying = 1
  bool addNext(Audio audio) {
    if (this.audioList.firstWhere((audioFromList) => audioFromList.id == audio.id, orElse: () => null) == null) {
      this.addAudioAt(nowPlaying + 1, audio);
      notifyListeners();
      return true;
    } else {
      // TODO: handle case when the audio is already there
      // 3 cases
      // the audio playing currently is added to play next
      // the audio is to be moved up
      // the audio is to be moved down
      int presentIndex = this.audioList.indexOf(audio);
    }
    return false;
  }
  
  Audio next() {
    if (this.size() - 1 > this.nowPlaying) {
      Audio nextAudio = this.audioList.elementAt(this.nowPlaying + 1);
      this.nowPlaying++;
      return nextAudio;
    } else {
      return null;
    }
  }

  void rearrange(int oldIndex, int newIndex) {
    debugPrint('OI = $oldIndex, NI = $newIndex');
    // 0 -> 1 oi=0 ni=2
    // 0 -> 2 oi=0 ni=3
    // 0 -> 3 oi=0 ni=4
    // 0 -> 4 oi=0 ni=5
    // 2 -> 4 oi=2 ni=5
    // TODO: Add now playing logic
    if (newIndex < oldIndex) {
      Audio audio = this.audioList.removeAt(oldIndex);
      this.audioList.insert(newIndex, audio);
    } else {
      Audio audio = this.audioList.elementAt(oldIndex);
      this.audioList.insert(newIndex, audio);
      this.audioList.removeAt(oldIndex);
    }
    this.nowPlaying = this.audioList.indexWhere((audioFromList) => audioFromList.id == this.currentAudio.audio.id);
    debugPrint('${this.audioList}, Now Playing: $nowPlaying');
    // Audio audio = this.audioList.removeAt(oldIndex);
    // if (newIndex >= this.audioList.length - 1) {
    //   this.audioList.add(audio);
    // } else {
    //   this.audioList.insert(newIndex, audio);
    // }
    notifyListeners();
  }

  @override
  String toString() {
    var concatenate = StringBuffer();
    this.audioList.forEach((item){
      concatenate.write(item.id + ", ");
    });
    return concatenate.toString();
  }

  addAllOverwrite(List<Audio> data) {
    this.resetQueue();
    this.audioList = data;
  }

  void resetQueue() {
    this.nowPlaying = -1;
    this.audioList = [];
  }

  void addAndPlay(Audio audio) {
    int audioIndexInList = this.audioList.indexWhere((audioFromList) => audioFromList.id == audio.id);
    if (audioIndexInList == -1) { // not found in list
      this.audioList.add(audio);
    }
    this.nowPlaying = this.audioList.indexWhere((audioFromList) => audioFromList.id == audio.id);
    this.currentAudio.audio = audio;
    this.currentAudio.playAudio();
    debugPrint('${this.audioList}, Now Playing: $nowPlaying');
    notifyListeners();
  }

  void playNext() {
    if (shuffle) {
      debugPrint('Shuffling');
      this.nowPlaying = new Random().nextInt(this.audioList.length);
      this.currentAudio.audio = this.audioList.elementAt(this.nowPlaying);
      this.currentAudio.playAudio();
    }
    if (repeat && nowPlaying == this.audioList.length -1) {

    }
    debugPrint('${this.audioList}, Now Playing: $nowPlaying');
    notifyListeners();
  }

}
