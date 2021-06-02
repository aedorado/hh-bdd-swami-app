import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/change_notifiers/audio_queue.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hh_bbds_app/ui/audio/audio_queue_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

var audioTitleStyle = TextStyle(
  // fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 20.0,
  decoration: TextDecoration.none,
);

var audioSubtitleStyle = TextStyle(
  // fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 14.0,
  decoration: TextDecoration.none,
);

class AudioPlayScreen extends StatefulWidget {
  @override
  _AudioPlayScreenState createState() => _AudioPlayScreenState();
}

class _AudioPlayScreenState extends State<AudioPlayScreen> {
  bool playing = false;

  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BDD Swami App"), backgroundColor: Colors.blue[800]),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[800],
                  Colors.blue[200],
                ]),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AudioQueueScreen()));
                      },
                      child: Icon(Icons.queue_music, size: 32),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 48, right: 48, top: 24, bottom: 12),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://i1.sndcdn.com/artworks-000674039176-uw34hj-t500x500.jpg"),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Consumer<AudioQueue>(
                    builder: (context, audioQueue, child) => Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                      child: Column(
                        children: [
                          Text(audioQueue.currentAudio.audio.name, style: audioTitleStyle, textAlign: TextAlign.center,),
                          Text(audioQueue.currentAudio.audio.name, style: audioSubtitleStyle, textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                          child: Consumer<AudioQueue>(
                            builder: (context, audioQueue, child) => Column(
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                    thumbColor: Colors.blue,
                                    activeTrackColor: Colors.blue,
                                    inactiveTrackColor: Colors.grey[350],
                                    // overlayColor: Color(0x99EB1555),
                                    trackHeight: 8,
                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                                    overlayShape: RoundSliderOverlayShape(overlayRadius: 18.0),
                                  ),
                                  child: Slider(
                                    min: 0,
                                    max: (audioQueue.currentAudio.totalAudioDuration == null) ? 0.0 : audioQueue.currentAudio.totalAudioDuration.inMilliseconds.toDouble(),
                                    value: (audioQueue.currentAudio.currentAudioPosition == null || audioQueue.currentAudio.audioPlayerState == AudioPlayerState.COMPLETED)
                                        ? 0.0 : audioQueue.currentAudio.currentAudioPosition.inMilliseconds.toDouble(),
                                    onChanged: (double value) {
                                      audioQueue.currentAudio.seekAudio(Duration(milliseconds: value.toInt()));
                                    },
                                  ),
                                ),
                                if (audioQueue.currentAudio.showMiniPlayer() && audioQueue.currentAudio.totalAudioDuration != null)
                                  Row(
                                    children: [
                                      Text(audioQueue.currentAudio.currentAudioPosition.toString().split('.').first),
                                      Spacer(),
                                      Text(audioQueue.currentAudio.totalAudioDuration.toString().split('.').first)
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                          child: Consumer2<CurrentAudio, AudioQueue>(
                            builder: (context, currentAudio, audioQueue, child) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    child: InkWell(
                                      onTap: () {
                                        audioQueue.currentAudio.isPlaying ? audioQueue.currentAudio.pauseAudio() : audioQueue.currentAudio.playAudio();
                                      },
                                      child: Center(
                                          child: Icon(Icons.skip_previous, size: 45, color: Color(0xFF1976D2),)
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF004BA0),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        audioQueue.currentAudio.isPlaying ? audioQueue.currentAudio.pauseAudio() : audioQueue.currentAudio.playAudio();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Center(
                                            child: Icon( audioQueue.currentAudio.isPlaying ? Icons.pause : Icons.play_arrow, size: 50, color: Colors.white,
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    child: InkWell(
                                      onTap: () {
                                        audioQueue.currentAudio.isPlaying ? audioQueue.currentAudio.pauseAudio() : audioQueue.currentAudio.playAudio();
                                      },
                                      child: Center(
                                          child: Icon(Icons.skip_next, size: 45, color: Color(0xFF1976D2),)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                          child: Consumer2<CurrentAudio, AudioQueue>(
                            builder: (context, currentAudio, audioQueue, child) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: InkWell(
                                    onTap: () {
                                      String favoritesActionPerformed;
                                      if (favoriteAudiosBox.get(audioQueue.currentAudio.audio.id) == null) {
                                        favoritesActionPerformed = FAVORITES_ACTION_ADD;
                                        favoriteAudiosBox.put(audioQueue.currentAudio.audio.id, audioQueue.currentAudio.audio);
                                      } else {
                                        favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                        favoriteAudiosBox.delete(audioQueue.currentAudio.audio.id);
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(audioQueue.currentAudio.audio, favoritesActionPerformed, favoriteAudiosBox).build(context));
                                    },
                                    child: ValueListenableBuilder(
                                        valueListenable: favoriteAudiosBox.listenable(),
                                        builder: (context, box, widget) {
                                          return IconTheme(
                                              data: new IconThemeData(color: Colors.redAccent),
                                              child: Icon((box.get(audioQueue.currentAudio.audio.id) == null) ? Icons.favorite_border : Icons.favorite,
                                                size: 36,
                                              )
                                          );
                                        }
                                    ),
                                  ),
                                ),
                                Container(
                                  child: InkWell(
                                    onTap: () {
                                      debugPrint('Before: ${audioQueue.shuffle}');
                                      audioQueue.shuffle = !audioQueue.shuffle;
                                      debugPrint('After: ${audioQueue.shuffle}');
                                    },
                                    child: Container(
                                      child: Center(
                                        child: IconTheme(
                                            data: new IconThemeData(),
                                            child: Icon(audioQueue.shuffle ? Icons.shuffle_on : Icons.shuffle, size: 36,)
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: InkWell(
                                    onTap: () {
                                      // String favoritesActionPerformed;
                                      // if (favoriteAudiosBox.get(currentAudio.audio.id) == null) {
                                      //   favoritesActionPerformed = FAVORITES_ACTION_ADD;
                                      //   favoriteAudiosBox.put(currentAudio.audio.id, currentAudio.audio);
                                      // } else {
                                      //   favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                      //   favoriteAudiosBox.delete(currentAudio.audio.id);
                                      // }
                                      // ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(currentAudio.audio, favoritesActionPerformed, favoriteAudiosBox).build(context));
                                    },
                                    child: Container(
                                      child: Center(
                                        child: IconTheme(
                                            data: new IconThemeData(color: Color(0xFF42A5F5)),
                                              child: Icon(audioQueue.repeat ? Icons.repeat : Icons.repeat_on,
                                              size: 36,)
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: InkWell(
                                    onTap: () {
                                      String favoritesActionPerformed;
                                      if (favoriteAudiosBox.get(currentAudio.audio.id) == null) {
                                        favoritesActionPerformed = FAVORITES_ACTION_ADD;
                                        favoriteAudiosBox.put(currentAudio.audio.id, currentAudio.audio);
                                      } else {
                                        favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                        favoriteAudiosBox.delete(currentAudio.audio.id);
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(currentAudio.audio, favoritesActionPerformed, favoriteAudiosBox).build(context));
                                    },
                                    child: Container(
                                      child: Center(
                                        child: IconTheme(
                                            data: new IconThemeData(color: Color(0xFF42A5F5)),
                                            child: Icon(Icons.queue_music, size: 36,)
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

