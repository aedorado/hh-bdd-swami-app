import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/network/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
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

  final List audioListScreenSuggestions = ['TRACKS', 'SERIES', 'SEMINARS', 'YEAR', 'PLAYLIST'];
  final List audioListScreenFutures = [
    fetchAudios('https://mocki.io/v1/f3ed5273-36ea-4bc1-b6b7-31df45d77a35'),
    fetchAudios('https://mocki.io/v1/6817415e-fc15-4ed5-b6a2-e811e45802f5'),
    fetchAudios('https://mocki.io/v1/f3ed5273-36ea-4bc1-b6b7-31df45d77a35'),
    fetchAudios('https://mocki.io/v1/6817415e-fc15-4ed5-b6a2-e811e45802f5'),
    fetchAudios('https://mocki.io/v1/f3ed5273-36ea-4bc1-b6b7-31df45d77a35'),
  ];


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
                  return AudioListScreenPage(audioListScreenFutures[index]);
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

class PopUpMenuTile extends StatelessWidget {
  const PopUpMenuTile(
      {Key key,
        @required this.icon,
        @required this.title,
        this.isActive = false})
      : super(key: key);
  final IconData icon;
  final String title;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(icon,
            color: isActive
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headline4.copyWith(
              color: isActive
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}

class AudioListScreenPage extends StatelessWidget {

  Future<List<Audio>> audioListFuture;

  AudioListScreenPage(Future<List<Audio>> audioListFuture) {
    this.audioListFuture = audioListFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Audio>>(
      future: this.audioListFuture,
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
                              onTap: () {
                                // return PopupMenuButton<int>(
                                //   offset: const Offset(0, 0),
                                //   itemBuilder: (context) => [
                                //     PopupMenuItem<int>(
                                //         value: 0,
                                //         child: PopUpMenuTile(
                                //           isActive: true,
                                //           icon: Icons.fiber_manual_record,
                                //           title:'Stop recording',
                                //         )),
                                //     PopupMenuItem<int>(
                                //         value: 1,
                                //         child: PopUpMenuTile(
                                //           isActive: true,
                                //           icon: Icons.pause,
                                //           title: 'Pause recording',
                                //         )),
                                //     PopupMenuItem<int>(
                                //         value: 2,
                                //         child: PopUpMenuTile(
                                //           icon: Icons.group,
                                //           title: 'Members',
                                //         )),
                                //     PopupMenuItem<int>(
                                //         value: 3,
                                //         child: PopUpMenuTile(
                                //           icon: Icons.person_add,
                                //           title: 'Invite members',
                                //         )),
                                //   ],
                                //   child: Column(
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: <Widget>[
                                //       Icon(Icons.more_vert,
                                //           color: Colors.white60),
                                //       Text('more',
                                //           style: Theme.of(context)
                                //               .textTheme
                                //               .caption)
                                //     ],
                                //   ),
                                // );
                                // showMenu<String>(
                                //   context: context,
                                //   position: RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),      //position where you want to show the menu on screen
                                //   items: [
                                //     PopupMenuItem<String>(
                                //         child: const Text('Add to Favorites'), value: '1'),
                                //     PopupMenuItem<String>(
                                //         child: const Text('menu option 2'), value: '2'),
                                //     PopupMenuItem<String>(
                                //         child: const Text('menu option 3'), value: '3'),
                                //   ],
                                //   elevation: 8.0,
                                // ).then<void>((String itemSelected) {
                                //   if (itemSelected == null) return;
                                //   if(itemSelected == "1"){
                                //     //code here
                                //   }else if(itemSelected == "2"){
                                //     //code here
                                //   }else{
                                //     //code here
                                //   }
                                // });
                              },
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




