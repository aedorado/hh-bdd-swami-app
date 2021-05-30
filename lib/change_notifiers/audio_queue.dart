import 'package:flutter/cupertino.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';

class AudioQueue extends ChangeNotifier {

  bool repeat;
  int nowPlaying;
  List<Audio> audioList;

  AudioQueue() {
    this.nowPlaying = -1;
    this.audioList = [];
  }

  void addAudio(Audio a) {
    this.audioList.add(a);
    notifyListeners();
  }

  void addAudioAt(int index, Audio a) {
    this.audioList.insert(index, a);
    notifyListeners();
  }

  void removeAudioAt(int index) {
    this.audioList.removeAt(index);
    notifyListeners();
  }

  void removeAudio(Audio a) {
    this.audioList.removeWhere((element) => element.id == a.id);
    notifyListeners();
  }
  
  int size() {
    return this.audioList.length;
  }

  // [a0, a1, a2, a3, a4]
  //      ^
  //      nowPlaying = 1
  void addNext(Audio audio) {
    this.addAudioAt(nowPlaying + 1, audio);
    notifyListeners();
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

}
