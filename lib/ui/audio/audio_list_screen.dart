import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/network/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:provider/provider.dart';

class AudioListScreen extends StatefulWidget {
  @override
  _AudioListScreenState createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {

  PageController _pageController = PageController(
    initialPage: 0,
  );
  final _animationDuration = 250;
  int selectedSuggestion = 0;

  // String audioAPIUrl = "https://mocki.io/v1/6817415e-fc15-4ed5-b6a2-e811e45802f5";
  String audioAPIUrl = "https://mocki.io/v1/f3ed5273-36ea-4bc1-b6b7-31df45d77a35";

  CurrentAudio currentAudio;
  AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    currentAudio = Provider.of<CurrentAudio>(context, listen: false);
    audioPlayer = Provider.of<CurrentAudio>(context, listen: false).audioPlayer;
  }

  @override
  void dispose() {
    currentAudio.audio = null;
    currentAudio.audioPlayer.stop();
    currentAudio.isPlaying = false;
    currentAudio.currentAudioIndex = -1;
    currentAudio.currentAudioPosition = Duration(seconds: 0);
    currentAudio.audioPlayer.release();
    super.dispose();
  }

  List audioListScreenSuggestions = ['TRACKS', 'ALBUMS', 'YEAR', 'POPULARITY', 'LENGTH'];

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
              child: Container(
                height: 56,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: audioListScreenSuggestions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _audioListSuggestionBox(index, audioListScreenSuggestions[index]);
                          }
                      ),
                    ],
                  ),
                ),
              ),

          ),
          Expanded(
            child: PageView.builder(
              itemCount: audioListScreenSuggestions.length,
              itemBuilder: (context, index) {
                return AudioListScreenPage();
              },
              controller: _pageController,
              onPageChanged: (pageNumber) {
                setState(() {
                  this.selectedSuggestion = pageNumber;
                });
              },
            ),
          )
          // AudioListScreenPage(),
        ],
      ),
    );
  }

  Widget _audioListSuggestionBox(int index, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          this.selectedSuggestion = index;
          this._pageController.animateToPage(index, duration: Duration(milliseconds: this._animationDuration), curve: Curves.easeIn);
        });
      },
      child: Padding(
        padding:
        const EdgeInsets.only(left: 5.0, right: 5.0, top: 6, bottom: 6),
        child: AnimatedContainer(
          duration: Duration(milliseconds: this._animationDuration),
          curve: Curves.easeIn,
          decoration: new BoxDecoration(
            color: this.selectedSuggestion == index ? Color(0xFF0077C2) : Color(0xFFBDBDBD),
            borderRadius: new BorderRadius.all(Radius.elliptical(80, 100)),
          ),
          height: 36,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
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
    return Padding(
      padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, top: 6, bottom: 6),
      child: Container(
        decoration: new BoxDecoration(
          color: isSelected == true ? Color(0xFF0077C2) : Color(0xFFBDBDBD),
          borderRadius: new BorderRadius.all(Radius.elliptical(80, 100)),
        ),
        height: 36,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              this.title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class AudioListScreenPage extends StatelessWidget {

  final String url;

  const AudioListScreenPage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Audio>>(
      future: fetchAudios(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // return Text(snapshot.data!.title);
          return Container(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 80,
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
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Consumer<CurrentAudio>(
                                  builder: (_, currentAudio, child) => InkWell(
                                    onTap: () {
                                      currentAudio.audio = snapshot.data[index];
                                      currentAudio.currentAudioIndex = index;
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayScreen()));
                                    },
                                    child: Consumer<CurrentAudio>(
                                      builder: (_, currentAudio, child) => Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 16),),
                                          if (currentAudio.isPlaying && index == currentAudio.currentAudioIndex) Text(currentAudio.currentAudioPosition.toString().split('.').first),
                                          if (currentAudio.isPlaying && index == currentAudio.currentAudioIndex) Text(currentAudio.totalAudioDuration.toString().split('.').first),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Consumer<CurrentAudio>(
                              builder: (_, currentAudio, child) => InkWell(
                                  onTap: () {
                                    // if audio is playing and user clicks on the button for the audio that is playing then pause audio
                                    if (currentAudio.isPlaying && (index == currentAudio.currentAudioIndex)) {
                                      currentAudio.pauseAudio();
                                    } else if (currentAudio.isPlaying && (index != currentAudio.currentAudioIndex)) { // user clicks on play button for an audio that is not playing currently
                                      currentAudio.stopAudio();
                                      currentAudio.currentAudioIndex = index;
                                      currentAudio.audio = snapshot.data[index];
                                      currentAudio.playAudio();
                                    } else if (!currentAudio.isPlaying) { // if not audio is playing, simply start playing current audio
                                      currentAudio.currentAudioIndex = index;
                                      currentAudio.audio = snapshot.data[index];
                                      currentAudio.playAudio();
                                    }
                                  },
                                  child: Icon((index == currentAudio.currentAudioIndex && currentAudio.isPlaying) ? Icons.pause : Icons.play_arrow)),
                            ),
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
        return Center(child: Container(height: 24, width: 24, child: CircularProgressIndicator()));
      },
    );
  }
}


