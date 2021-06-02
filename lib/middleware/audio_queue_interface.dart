
import 'package:hh_bbds_app/change_notifiers/audio_queue.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';

class AudioQueueInterface {

  AudioQueue audioQueue;
  CurrentAudio currentAudio;

  AudioQueueInterface(AudioQueue audioQueue, CurrentAudio currentAudio) {
    this.audioQueue = audioQueue;
    this.currentAudio = currentAudio;
  }

  void playAddToQueue() {

  }

  // Used from audio folder view screen
  // When the play button is clicked on this screen
  // Queue is overwritten and first element from queue is played
  void playAudioFolder(List<Audio> audioList) {
    this.audioQueue.addAllOverwrite(audioList);
    Audio toPlay = this.audioQueue.next();
    this.currentAudio.audio = toPlay;
    this.currentAudio.playAudio();
  }



}
