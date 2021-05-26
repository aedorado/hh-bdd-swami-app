import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/change_notifiers/audio_player.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/network/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:provider/provider.dart';

class AudioListScreen extends StatefulWidget {
  @override
  _AudioListScreenState createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {

  // State items related to presently playing audio
  // bool _audioIsPlaying = false;
  // int _currentAudioIndex = -1;
  // Duration _totalAudioDuration;
  // Duration _currentAudioPosition;

  CurrentAudio currentAudio = new CurrentAudio();

  int selectedSuggestion = 0;

  String audioAPIUrl = "https://mocki.io/v1/6817415e-fc15-4ed5-b6a2-e811e45802f5";

  // AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    // audioPlayer = new AudioPlayer();
    // audioPlayer.onDurationChanged.listen((d) => setState(() => _totalAudioDuration = d));
    // audioPlayer.onAudioPositionChanged.listen((p) => setState(() => _currentAudioPosition = p));
    // audioPlayer.onPlayerCompletion.listen((event) {
    //   setState(() {
    //     _currentAudioPosition = Duration(seconds: 0);
    //     _audioIsPlaying = false;
    //   });
    // });
  }

  @override
  void dispose() {
    this.currentAudio.audioPlayer.release();
    super.dispose();
  }

  playAudio(String audioUrl, int audioIndex) {
    setState(() {
      currentAudio.audioIsPlaying = true;
      currentAudio.currentAudioIndex = audioIndex;
    });
    currentAudio.playAudio('https://thegrowingdeveloper.org/files/audios/quiet-time.mp3?b4869097e4');
    // audioPlayer.play(audioUrl);
  }

  pauseAudio() {
    setState(() {
      currentAudio.audioIsPlaying = false;
    });
    currentAudio.pauseAudio();
  }

  stopAudio() {
    setState(() {
      currentAudio.audioIsPlaying = false;
      currentAudio.currentAudioIndex = -1;
      currentAudio.currentAudioPosition = Duration(seconds: 0);
    });
    currentAudio.stopAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BDDS Audio Library'),
      ),
      body: Column(
        children: [
          ColoredBox(
              color: Color(0xFFBDBDBD),
              child: Row(
                children: [
                  AudioListSuggestionBox(
                    title: 'TRACKS',
                    flex: 2,
                    isSelected: selectedSuggestion == 0,
                  ),
                  AudioListSuggestionBox(
                    title: 'ALBUMS',
                    flex: 2,
                    isSelected: selectedSuggestion == 1,
                  ),
                  AudioListSuggestionBox(
                    title: 'YEAR',
                    flex: 2,
                    isSelected: selectedSuggestion == 2,
                  ),
                  AudioListSuggestionBox(
                    title: 'POPULARITY',
                    flex: 3,
                    isSelected: selectedSuggestion == 3,
                  ),
                  AudioListSuggestionBox(
                    title: 'LENGTH',
                    flex: 2,
                    isSelected: selectedSuggestion == 4,
                  ),
                ],
              )),
          FutureBuilder<List<Audio>>(
            future: fetchAudios(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return Text(snapshot.data!.title);
                return Container(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 75,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2, left: 2, right: 2, bottom: 2),
                                      child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://i.postimg.cc/RZJ6HJrw/c.jpg')),
                                      // ClipRRect(
                                      //   borderRadius: BorderRadius.circular(8.0),
                                      //   child: Image.network('https://i.postimg.cc/RZJ6HJrw/c.jpg', height: 150.0, width: 100.0),
                                      // ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: InkWell(
                                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayScreen())),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 16),),
                                              if (currentAudio.audioIsPlaying && index == currentAudio.currentAudioIndex) Text(currentAudio.currentAudioPosition.toString().split('.').first),
                                              if (currentAudio.audioIsPlaying && index == currentAudio.currentAudioIndex) Text(currentAudio.totalAudioDuration.toString().split('.').first),
                                            ],
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                            onTap: () {
                                              // if audio is playing
                                              // and
                                              // user clicks on the button for the audio that is playing
                                              // then pause audio
                                              if (currentAudio.audioIsPlaying && (index == currentAudio.currentAudioIndex)) {
                                                pauseAudio();
                                              } else if (currentAudio.audioIsPlaying && (index != currentAudio.currentAudioIndex)) { // user clicks on play button for an audio that is not playing currently
                                                stopAudio();
                                                playAudio(snapshot.data[index].url, index);
                                              } else if (!currentAudio.audioIsPlaying) { // if not audio is playing, simply start playing current audio
                                                playAudio(snapshot.data[index].url, index);
                                              }
                                            },
                                            child: Icon((index == currentAudio.currentAudioIndex && currentAudio.audioIsPlaying) ? Icons.pause : Icons.play_arrow)),
                                      ),
                                  // Divider(color: Colors.black, height: 1,),
                                ],
                                //: Center(child: Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 18),)),
                              ),
                          );
                        }));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}

class AudioListSuggestionBox extends StatelessWidget {
  final String title;
  final int flex;
  final bool isSelected;

  const AudioListSuggestionBox(
      {Key key, this.title, this.flex, this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: this.flex,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 2.0, right: 2.0, top: 6, bottom: 6),
          child: Container(
            decoration: new BoxDecoration(
              color: isSelected == true ? Color(0xFF0077C2) : Color(0xFFBDBDBD),
              borderRadius: new BorderRadius.all(Radius.elliptical(110, 100)),
            ),
            height: 36,
            child: Center(
              child: Text(
                this.title,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ));
  }
}
