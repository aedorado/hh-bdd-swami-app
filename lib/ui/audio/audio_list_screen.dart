import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/podo/audio_folder.dart';
import 'package:hh_bbds_app/ui/audio/audio_folder_screen.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/audio_search.dart';
import 'package:hh_bbds_app/ui/audio/audio_constants.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hh_bbds_app/ui/favorites/favorite_audios.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:palette_generator/palette_generator.dart';
import 'audio_year_screen.dart';

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
    FirebaseFirestore.instance.collection("audios").orderBy('name').snapshots(),
    FirebaseFirestore.instance.collection("series").orderBy('name').snapshots(),
    FirebaseFirestore.instance.collection("seminars").orderBy('name').snapshots(),
    // FirebaseFirestore.instance.collection("audios").orderBy('name').snapshots(),
  ];

  bool _isSearching = false;

  @override
  void initState() {
    initAudioService();
    super.initState();
  }

  initAudioService() async {
    await AudioService.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !_isSearching,
        foregroundColor: Colors.black,
        title: Text('Audio Library'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                var selectionType = await showSearch(context: context, delegate: AudioSearch());
                if (selectionType == TRACKS || selectionType == SHORT_AUDIOS) {
                  Box hiveBox = Hive.box(HIVE_BOX_AUDIO_SEARCH);
                  String id = hiveBox.get(HIVE_BOX_AUDIO_SEARCH_KEY_SELECTED_ITEM);
                  FirebaseFirestore.instance.collection('audios').where("id", isEqualTo: id).limit(1).get().then(
                    (value) async {
                      if (value.size > 0) {
                        Audio audio = Adapter.firebaseAudioSnapshotToAudio(value.docs[0]);
                        MediaItem mediaItem = Adapter.audioToMediaItem(audio);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AudioPlayScreen(
                                      mediaItem: mediaItem,
                                    )));
                      }
                    },
                  );
                } else if (selectionType == SEMINARS || selectionType == SERIES) {
                  Box hiveBox = Hive.box(HIVE_BOX_AUDIO_SEARCH);
                  String id = hiveBox.get(HIVE_BOX_AUDIO_SEARCH_KEY_SELECTED_ITEM);
                  FirebaseFirestore.instance
                      .collection(selectionType!.toLowerCase())
                      .where("id", isEqualTo: id)
                      .limit(1)
                      .get()
                      .then(
                    (value) async {
                      if (value.size > 0) {
                        AudioFolder audioFolder = AudioFolder.fromFirebaseAudioFolderSnapshot(value.docs[0]);
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AudioFolderScreen(audioFolder)));
                      }
                    },
                  );
                }
              }),
        ],
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
                              }),
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
                  if (index == 3) {
                    return AudioYearList();
                  } else if (index == 1 || index == 2) {
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
          this._pageController.jumpToPage(index);
          // .animateToPage(index, duration: Duration(milliseconds: this._animationDuration), curve: Curves.easeIn);
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6, bottom: 6),
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
  late Stream<QuerySnapshot<Map<String, dynamic>>> audiosSnapshot;

  AudioListPage(Stream<QuerySnapshot<Map<String, dynamic>>> audiosSnapshot) {
    this.audiosSnapshot = audiosSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: this.audiosSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // return Text(snapshot.data!.title);
          return Container(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (BuildContext context, int index) {
                    Audio audio = Adapter.firebaseAudioSnapshotToAudio(snapshot.data!.docs[index]);
                    return AudioListScreenRow(
                      audio: audio,
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

class AudioListScreenRow extends StatelessWidget {
  final Audio audio;

  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  AudioListScreenRow({Key? key, required this.audio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
        stream: AudioService.currentMediaItemStream,
        builder: (context, currentMediaItemSnapshot) {
          bool isItemPlaying = false;
          if (currentMediaItemSnapshot.data?.id == audio.id) {
            isItemPlaying = true;
          }
          return ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 60.0,
              maxHeight: 80.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image
                Expanded(
                    flex: 7,
                    child: InkWell(
                      onTap: () async {
                        MediaItem mediaItem = Adapter.audioToMediaItem(audio);
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AudioPlayScreen(mediaItem: mediaItem)));
                      },
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(color: isItemPlaying ? Color(0xFFBBDEFB) : null),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2, left: 4, right: 2, bottom: 2),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue, // inner circle color
                                      image: DecorationImage(image: NetworkImage(audio.thumbnailUrl))),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 6,
                              child: Container(
                                decoration: BoxDecoration(color: isItemPlaying ? Color(0xFFBBDEFB) : null),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${audio.name}',
                                        maxLines: 2,
                                        style: TextStyle(fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${audio.name}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(color: isItemPlaying ? Color(0xFFBBDEFB) : null),
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
                        ScaffoldMessenger.of(context).showSnackBar(FavoriteAudioSnackBar(
                          audio: audio,
                          favoritesActionPerformed: favoritesActionPerformed,
                          displayUndoAction: false,
                        ).build(context));
                      },
                      child: ValueListenableBuilder(
                          valueListenable: favoriteAudiosBox.listenable(),
                          builder: (context, Box<Audio> box, widget) {
                            return IconTheme(
                                data: new IconThemeData(color: Colors.redAccent),
                                child: Icon(
                                  (box.get(audio.id) == null) ? Icons.favorite_border : Icons.favorite,
                                  size: 24,
                                ));
                          }),
                    ),
                  ),
                ),
              ],
              //: Center(child: Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 18),)),
            ),
          );
        });
  }
}

class AudioFolderPage extends StatelessWidget {
  late Stream<QuerySnapshot<Map<String, dynamic>>> audiosSnapshot;

  AudioFolderPage(Stream<QuerySnapshot<Map<String, dynamic>>> audiosSnapshot) {
    this.audiosSnapshot = audiosSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: this.audiosSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // return Text(snapshot.data!.title);
          return Container(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (BuildContext context, int index) {
                    AudioFolder audioFolder = AudioFolder.fromFirebaseAudioFolderSnapshot(snapshot.data!.docs[index]);
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
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => AudioFolderScreen(audioFolder)));
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 6, left: 6, right: 6, bottom: 6),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(image: NetworkImage(audioFolder.thumbnailUrl))),
                                      ),
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
                                            Text(
                                              '${audioFolder.name}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              '${audioFolder.totalContents} audios',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
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
