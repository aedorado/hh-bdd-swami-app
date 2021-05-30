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

}
