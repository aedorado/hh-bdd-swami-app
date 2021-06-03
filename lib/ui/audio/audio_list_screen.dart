import 'package:hh_bbds_app/background/background_audio_controls.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/podo/audio_folder.dart';
import 'package:hh_bbds_app/network/audio.dart';
import 'package:hh_bbds_app/network/audio_folder.dart';
import 'package:hh_bbds_app/ui/audio/audio_folder_screen.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerBackgroundTasks());
}

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

  final List audioListScreenSuggestions = ['TRACKS', 'SERIES', 'SEMINARS', 'YEAR'];
  final List audioListScreenFutures = [
    fetchAudios('https://mocki.io/v1/00c25346-891a-4a2a-987e-4a9c1a6c637e'),
    fetchAudioFolders('https://mocki.io/v1/0d9de1d0-332b-4748-bc5a-f5b79b952883'),
    fetchAudioFolders('https://mocki.io/v1/0d9de1d0-332b-4748-bc5a-f5b79b952883'),
    fetchAudios('https://mocki.io/v1/707d651f-aa2f-4d0a-90a9-2db94623350b'),
    fetchAudios('https://mocki.io/v1/00c25346-891a-4a2a-987e-4a9c1a6c637e'),
  ];

  // CurrentAudio currentAudio;
  // AudioPlayer audioPlayer;

  @override
  void initState() {
    initAudioService();
    super.initState();
  }

  initAudioService() async {
    await AudioService.connect();
  }

  // @override
  // void didChangeDependencies() {
  //   currentAudio = Provider.of<CurrentAudio>(context, listen: false);
  //   audioPlayer = Provider.of<CurrentAudio>(context, listen: false).audioPlayer;
  // }

  @override
  void dispose() {
    AudioService.disconnect();
    // currentAudio.audio = null;
    // currentAudio.audioPlayer.stop();
    // currentAudio.isPlaying = false;
    // currentAudio.currentAudioIndex = -1;
    // currentAudio.currentAudioPosition = Duration(seconds: 0);
    // currentAudio.audioPlayer.release();
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
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFBDBDBD),
              ),
              child: Row(
                children: [
                  Expanded(
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
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                itemCount: audioListScreenSuggestions.length,
                itemBuilder: (context, index) {
                  if (index == 1 || index == 2) {
                    return AudioFolderPage(audioListScreenFutures[index]);
                  }
                  return AudioListPage(audioListScreenFutures[index]);
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

class AudioListPage extends StatelessWidget {

  Future<List<Audio>> audioListFuture;
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  AudioListPage(Future<List<Audio>> audioListFuture) {
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
                return AudioListScreenRow(audio: snapshot.data[index], favoriteAudiosBox: favoriteAudiosBox,);
              })
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: Container(height: 24, width: 24, child: CircularProgressIndicator()));
      },
    );
  }
}

class AudioListScreenRow extends StatelessWidget {

  final Audio audio;
  final Box<Audio> favoriteAudiosBox;

  const AudioListScreenRow({Key key, this.audio, this.favoriteAudiosBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
              flex: 7,
              child: InkWell(
                  onTap: () {
                    // audioQueue.addAndPlay(audio);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayScreen()));
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 2, left: 4, right: 2, bottom: 2),
                          child: CircleAvatar(
                              backgroundImage: NetworkImage('https://i.postimg.cc/RZJ6HJrw/c.jpg')),
                        ),
                      ),
                      Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${audio.name}', style: TextStyle(fontSize: 16),),
                                Text('${audio.name}', style: TextStyle(fontSize: 12),),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ),
          ),
          Expanded(
            flex: 1,
            child: StreamBuilder<PlaybackState>(
              stream: AudioService.playbackStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return InkWell(
                  onTap: () {
                    if (playing) AudioService.pause();
                    else {
                      if (AudioService.running) {
                        AudioService.play();
                      } else {
                        AudioService.start(backgroundTaskEntrypoint: _backgroundTaskEntrypoint, params: {"url": audio.url});
                      }
                    }
                  },
                  child: Icon(playing ? Icons.pause : Icons.play_arrow, size: 25,)
                );
              }
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                AudioService.stop();
              },
              child: Icon(Icons.stop, size: 25,)
            )
          ),
          Expanded(flex: 1,
            child: InkWell(
              onTap: () {
                String favoritesActionPerformed;
                if (favoriteAudiosBox.get(audio.id) == null) {
                  favoritesActionPerformed = FAVORITES_ACTION_ADD;
                  favoriteAudiosBox.put(audio.id, audio);
                } else {
                  favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                  favoriteAudiosBox.delete(audio.id);
                }
                ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(audio, favoritesActionPerformed, favoriteAudiosBox).build(context));
              },
              child: ValueListenableBuilder(
                  valueListenable: favoriteAudiosBox.listenable(),
                  builder: (context, box, widget) {
                    return IconTheme(
                        data: new IconThemeData(color: Colors.redAccent),
                        child: Icon((box.get(audio.id) == null) ? Icons.favorite_border : Icons.favorite,
                          size: 24,
                        )
                    );
                  }
              ),
            ),
          ),
          // More Icon
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 2, right: 4),
              child: PopupMenuButton(
                  onSelected: (item) {
                    switch (item) {
                      case FAVORITES_ACTION_REMOVE:
                        favoriteAudiosBox.delete(audio.id);
                        ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(audio, item, favoriteAudiosBox).build(context));
                        break;
                      case FAVORITES_ACTION_ADD:
                        favoriteAudiosBox.put(audio.id, audio);
                        ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(audio, item, favoriteAudiosBox).build(context));
                        break;
                      case PLAY_NEXT:
                        // bool isAdded = audioQueue.addNext(audio);
                        // ScaffoldMessenger.of(context).showSnackBar(QueueModificationSnackBar(isAdded, audio, audioQueue).build(context));
                        break;
                      case ADD_TO_QUEUE:
                        // bool isAdded = audioQueue.addAudio(audio);
                        // ScaffoldMessenger.of(context).showSnackBar(QueueModificationSnackBar(isAdded, audio, audioQueue).build(context));
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      (favoriteAudiosBox.get(audio.id) == null) ?
                      PopupMenuItem(value: FAVORITES_ACTION_ADD, child: Text('Add to Favorites'),) :
                      PopupMenuItem(value: FAVORITES_ACTION_REMOVE, child: Text('Remove from Favorites'),),
                      PopupMenuItem(value: PLAY_NEXT, child: Text('Play Next'),),
                      PopupMenuItem(value: ADD_TO_QUEUE, child: Text('Add to Queue'),),
                    ];
                  },
                ),
              ),
            ),
        ],
        //: Center(child: Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 18),)),
      ),
    );
  }
}

class AudioFolderPage extends StatelessWidget {

  Future<List<AudioFolder>> audioFolderFuture;

  AudioFolderPage(Future<List<AudioFolder>> audioFolderFuture) {
    this.audioFolderFuture = audioFolderFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AudioFolder>>(
      future: this.audioFolderFuture,
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
                      // TODO: Make sure the rows on all the screens are of equal height
                      height: 76,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image
                          Expanded(
                              flex: 7,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AudioFolderScreen(snapshot.data[index])));
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2, left: 4, right: 2, bottom: 2),
                                          child: CircleAvatar(
                                              backgroundImage: NetworkImage('https://i.postimg.cc/RZJ6HJrw/c.jpg')),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 6,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 16),),
                                                Text('${snapshot.data[index].totalContents} audios', style: TextStyle(fontSize: 12),),
                                              ],
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                          // More Icon
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2, right: 4),
                              child: PopupMenuButton(
                                  onSelected: (item) {
                                    switch (item) {
                                      case FAVORITES_ACTION_REMOVE:
                                        // favoriteAudiosBox.delete(snapshot.data[index].id);
                                        // ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(snapshot.data[index], item, favoriteAudiosBox).build(context));
                                        break;
                                      case FAVORITES_ACTION_ADD:
                                        // favoriteAudiosBox.put(snapshot.data[index].id, snapshot.data[index]);
                                        // ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(snapshot.data[index], item, favoriteAudiosBox).build(context));
                                        break;
                                      case PLAY_NEXT:
                                        // bool isAdded = audioQueue.addNext(snapshot.data[index]);
                                        // ScaffoldMessenger.of(context).showSnackBar(QueueModificationSnackBar(isAdded, snapshot.data[index], audioQueue).build(context));
                                        break;
                                      case ADD_TO_QUEUE:
                                        // bool isAdded = audioQueue.addAudio(snapshot.data[index]);
                                        // ScaffoldMessenger.of(context).showSnackBar(QueueModificationSnackBar(isAdded, snapshot.data[index], audioQueue).build(context));
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      // (favoriteAudiosBox.get(snapshot.data[index].id) == ndeull) ?
                                      // PopupMenuItem(value: FAVORITES_ACTION_ADD, child: Text('Add to Favorites'),) :
                                      // PopupMenuItem(value: FAVORITES_ACTION_REMOVE, child: Text('Remove from Favorites'),),
                                      PopupMenuItem(value: PLAY_NEXT, child: Text('Play Next'),),
                                      PopupMenuItem(value: ADD_TO_QUEUE, child: Text('Add to Queue'),),
                                    ];
                                  },
                                ),
                            ),
                          ),
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

class FavoritesSnackBar extends StatelessWidget {

  Audio a;
  String favoritesActionPerformed;
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
  
  FavoritesSnackBar(this.a, this.favoritesActionPerformed, this.favoriteAudiosBox) {
    if (this.favoritesActionPerformed == FAVORITES_ACTION_REMOVE) {
      snackBarText = 'Removed from Favorites';
    } else {
      snackBarText = 'Added to Favorites';
    }
  }

  String snackBarText;

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
          if (favoritesActionPerformed == FAVORITES_ACTION_REMOVE) {
            snackBarText = 'Added to Favorites';
            favoriteAudiosBox.put(a.id, a);
          } else {
            snackBarText = 'Removed from Favorites';
            favoriteAudiosBox.delete(a.id);
          }
        },
      ),
      content: Text(snackBarText),
      duration: Duration(milliseconds: 1000),
    );
  }

}

// class QueueModificationSnackBar extends StatelessWidget {
//
//   bool isAdded;
//   Audio audio;
//   AudioQueue audioQueue;
//   // String favoritesActionPerformed;
//   // Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
//
//   QueueModificationSnackBar(this.isAdded, this.audio, this.audioQueue);
//
//   String snackBarText;
//
//   @override
//   SnackBar build(BuildContext context) {
//     return SnackBar(
//       action: this.isAdded ? SnackBarAction(
//         label: 'Undo',
//         onPressed: () {
//           if (this.isAdded) {
//             this.audioQueue.removeAudio(this.audio);
//           }
//         },
//       ): null,
//       content: Text(this.isAdded ? 'Added to Queue': 'Already added to Queue'),
//       duration: Duration(milliseconds: 1000),
//     );
//   }
//
// }

