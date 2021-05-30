import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

var audioTitleStyle = TextStyle(
  // fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 20.0,
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
      body: Container(
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
            Expanded(
              flex: 3,
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
              flex: 1,
              child: Center(
                child: Consumer<CurrentAudio>(
                  builder: (context, currentAudio, child) => Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                    child: Text(
                      currentAudio.audio.name,
                      style: audioTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              thumbColor: Colors.blue,
                              activeTrackColor: Colors.blue,
                              inactiveTrackColor: Colors.grey[350],
                              // overlayColor: Color(0x99EB1555),
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 18.0),
                            ),
                            child: Consumer<CurrentAudio>(
                              builder: (context, currentAudio, child) => Slider(
                                min: 0,
                                max: (currentAudio.totalAudioDuration == null) ? 0.0 : currentAudio.totalAudioDuration.inMilliseconds.toDouble(),
                                value: (currentAudio.currentAudioPosition == null || currentAudio.audioPlayerState == AudioPlayerState.COMPLETED)
                                          ? 0.0 : currentAudio.currentAudioPosition.inMilliseconds.toDouble(),
                                onChanged: (double value) {
                                  currentAudio.seekAudio(Duration(milliseconds: value.toInt()));
                                },
                              ),
                            ),
                          ),
                          Consumer<CurrentAudio>(
                              builder: (context, currentAudio, child) => Row(
                                children: [
                                  if (currentAudio.totalAudioDuration != null) Text(currentAudio.currentAudioPosition.toString().split('.').first),
                                  Spacer(),
                                  if (currentAudio.totalAudioDuration != null) Text(currentAudio.totalAudioDuration.toString().split('.').first)
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<CurrentAudio>(
                            builder: (context, currentAudio, child) => InkWell(
                              onTap: () {
                                currentAudio.isPlaying ? currentAudio.pauseAudio() : currentAudio.playAudio();
                              },
                              child: Container(
                                child: Center(
                                    child: Icon( currentAudio.isPlaying ? Icons.pause : Icons.play_arrow, size: 50, color: Colors.blue,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<CurrentAudio>(
                            builder: (context, currentAudio, child) => InkWell(
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
                              child: Consumer<CurrentAudio>(
                                builder: (context, currentAudio, child) => Container(
                                  child: Center(
                                      child: IconTheme(
                                          data: new IconThemeData(color: Colors.redAccent),
                                          child: Icon(favoriteAudiosBox.get(currentAudio.audio.id) == null ? Icons.favorite_border : Icons.favorite, size: 36,))),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
