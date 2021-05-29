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
      body: SafeArea(
        child: Column(
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
            ),
            Miniplayer(),
          ],
        ),
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
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, left: 2, right: 2, bottom: 2),
                              child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://i.postimg.cc/RZJ6HJrw/c.jpg')),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Consumer<CurrentAudio>(
                                builder: (_, currentAudio, child) => InkWell(
                                  onTap: () {
                                    currentAudio.audio = snapshot.data[index];
                                    currentAudio.currentAudioIndex = index;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayScreen()));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 16),),
                                      Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 12),),
                                      // if (currentAudio.isPlaying && index == currentAudio.currentAudioIndex) Text(currentAudio.currentAudioPosition.toString().split('.').first),
                                      // if (currentAudio.isPlaying && index == currentAudio.currentAudioIndex) Text(currentAudio.totalAudioDuration.toString().split('.').first),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ),
                          Expanded(flex: 1,
                            child: InkWell(
                              onTap: () {
                                final snackBar = SnackBar(
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      // Some code to undo the change.
                                    },
                                  ),
                                  content: Text('Added to Favorites!')
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                              child: IconTheme(
                                  data: new IconThemeData(color: Colors.redAccent),
                                  child: Icon(
                                    true ? Icons.favorite : Icons.favorite_border,
                                    size: 24,
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {},
                              child: Icon(Icons.more_vert, size: 24,)
                            ),
                          ),
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
                                  } else if (!currentAudio.isPlaying) { // if ndebugot audio is playing, simply start playing current audio
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

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = 0;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class Miniplayer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentAudio>(
      builder: (context, currentAudio, child) => AnimatedContainer(
        height: currentAudio.isPlaying ? 80 : 0,
        duration: Duration(milliseconds: 200),
        // Provide an optional curve to make the animation feel smoother.
        curve: Curves.easeIn,
        child: ColoredBox(
          color: Color(0xFF42A5F5),
          child: Column(
            children: [
              SizedBox(
                height: 4,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackShape: CustomTrackShape(),
                    trackHeight: 2.0,
                    // thumbColor: Color(0xFFEB1555),
                    inactiveTrackColor: Color(0xFF8D8E98),
                    // activeTrackColor: Colors.white,
                    // overlayColor: Color(0x99EB1555),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                    // overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                  ),
                  child: Slider(
                    min: 0,
                    max: (currentAudio.totalAudioDuration == null) ? 0.0 : currentAudio.totalAudioDuration.inMilliseconds.toDouble(),
                    value: (currentAudio.currentAudioPosition == null || currentAudio.audioPlayerState == AudioPlayerState.COMPLETED)
                        ? 0.0 : currentAudio.currentAudioPosition.inMilliseconds.toDouble(),
                    onChanged: null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 2),
                      child: CircleAvatar(backgroundImage: NetworkImage('https://i.postimg.cc/RZJ6HJrw/c.jpg')),
                    ),
                  ),
                  Expanded(flex: 4, child: Center(child: Column(
                    children: [
                      Text(currentAudio.audio == null ? '' : currentAudio.audio.name, style: TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis,),
                      Text(currentAudio.audio == null ? '' : currentAudio.audio.name, style: TextStyle(fontSize: 9), overflow: TextOverflow.ellipsis,),
                    ],
                  ))),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: () {
                            // if audio is playing and user clicks on the button for the audio that is playing then pause audio
                            if (currentAudio.isPlaying) {
                              currentAudio.pauseAudio();
                            } else if (!currentAudio.isPlaying) { // if not audio is playing, simply start playing current audio
                              currentAudio.playAudio();
                            }
                          },
                          child: Icon(currentAudio.isPlaying ? Icons.pause : Icons.play_arrow))),
                ],),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



