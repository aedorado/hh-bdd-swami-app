import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/background/background_audio_controls.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/podo/audio_folder.dart';
import 'package:hh_bbds_app/network/remote_config.dart';
import 'package:hh_bbds_app/ui/audio/audio_folder_screen.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'audio_year_screen.dart';

const TRACKS = 'tracks';
const SERIES = 'series';
const SEMINARS = 'seminars';
const SHORT_AUDIOS = 'short audios';

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

  final List audioListScreenSuggestions = [
    'TRACKS',
    'SERIES',
    'SEMINARS',
    'YEAR'
  ];
  final List audioListScreenFutures = [
    FirebaseFirestore.instance.collection("audios").snapshots(),
    FirebaseFirestore.instance.collection("series").snapshots(),
    FirebaseFirestore.instance.collection("seminars").snapshots(),
    FirebaseFirestore.instance.collection("audios").snapshots(),
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
                var selectionType =
                    await showSearch(context: context, delegate: AudioSearch());
                if (selectionType == TRACKS || selectionType == SHORT_AUDIOS) {
                  Box hiveBox = Hive.box(HIVE_BOX_AUDIO_SEARCH);
                  String id =
                      hiveBox.get(HIVE_BOX_AUDIO_SEARCH_KEY_SELECTED_ITEM);
                  FirebaseFirestore.instance
                      .collection('audios')
                      .where("id", isEqualTo: id)
                      .limit(1)
                      .get()
                      .then(
                    (value) async {
                      if (value.size > 0) {
                        Audio audio =
                            Adapter.firebaseAudioSnapshotToAudio(value.docs[0]);
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
                } else if (selectionType == SEMINARS ||
                    selectionType == SERIES) {
                  Box hiveBox = Hive.box(HIVE_BOX_AUDIO_SEARCH);
                  String id =
                      hiveBox.get(HIVE_BOX_AUDIO_SEARCH_KEY_SELECTED_ITEM);
                  debugPrint(selectionType?.toLowerCase());
                  FirebaseFirestore.instance
                      .collection(selectionType!.toLowerCase())
                      .where("id", isEqualTo: id)
                      .limit(1)
                      .get()
                      .then(
                    (value) async {
                      if (value.size > 0) {
                        AudioFolder audioFolder =
                            Adapter.firebaseAudioFolderSnapshotToAudioFolder(
                                value.docs[0]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AudioFolderScreen(audioFolder)));
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
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: audioListScreenSuggestions.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _audioListSuggestionBox(
                                    index, audioListScreenSuggestions[index]);
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
          this._pageController.animateToPage(index,
              duration: Duration(milliseconds: this._animationDuration),
              curve: Curves.easeIn);
        });
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, top: 6, bottom: 6),
        child: AnimatedContainer(
          duration: Duration(milliseconds: this._animationDuration),
          curve: Curves.easeIn,
          decoration: new BoxDecoration(
            color: this.selectedSuggestion == index
                ? Color(0xFF0077C2)
                : Color(0xFFBDBDBD),
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

class AudioYearList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List yearsList = RemoteConfigService.getAudioYears() ?? [];
    return ListView.builder(
        itemCount: yearsList.length,
        itemBuilder: (BuildContext content, int index) {
          return ListTile(
            title:
                Text('${yearsList[index]}', style: TextStyle(fontSize: 24.0)),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AudioYearScreen(yearsList[index])));
            },
          );
        });
  }
}

class AudioListPage extends StatelessWidget {
  late Stream<QuerySnapshot<Map<String, dynamic>>> audiosSnapshot;
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

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
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (BuildContext context, int index) {
                    Audio audio = Adapter.firebaseAudioSnapshotToAudio(
                        snapshot.data!.docs[index]);
                    return AudioListScreenRow(
                      audio: audio,
                      favoriteAudiosBox: favoriteAudiosBox,
                    );
                  }));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
            child: Container(
                height: 24, width: 24, child: CircularProgressIndicator()));
      },
    );
  }
}

class AudioListScreenRow extends StatelessWidget {
  final Audio? audio;
  final Box<Audio> favoriteAudiosBox;

  const AudioListScreenRow(
      {Key? key, this.audio, required this.favoriteAudiosBox})
      : super(key: key);

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
            flex: 8,
            child: StreamBuilder<PlaybackState>(
                stream: AudioService.playbackStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  return InkWell(
                    onTap: () async {
                      MediaItem mediaItem = Adapter.audioToMediaItem(audio!);
                      // await AudioService.connect();
                      // if (!AudioService.running) {
                      //   await AudioService.start(
                      //       androidNotificationIcon: 'mipmap/ic_launcher',
                      //       backgroundTaskEntrypoint:
                      //           _backgroundTaskEntrypoint); //, params: {"url": audio.url});
                      // }
                      // if (AudioService.currentMediaItem?.id != mediaItem.id) {
                      //   await AudioService.playMediaItem(mediaItem);
                      // }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AudioPlayScreen(mediaItem: mediaItem)));
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 2, left: 4, right: 2, bottom: 2),
                            child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://i.postimg.cc/RZJ6HJrw/c.jpg')),
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
                                    '${audio?.name}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '${audio?.name}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            )),
                        StreamBuilder<MediaItem?>(
                            stream: AudioService.currentMediaItemStream,
                            builder: (context, currentMediaItemSnapshot) {
                              return Icon(
                                playing &&
                                        currentMediaItemSnapshot.data?.id ==
                                            audio?.id
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 25,
                              );
                            })
                      ],
                    ),
                  );
                }),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                String favoritesActionPerformed;
                if (favoriteAudiosBox.get(audio!.id) == null) {
                  favoritesActionPerformed = FAVORITES_ACTION_ADD;
                  favoriteAudiosBox.put(audio!.id, audio!);
                } else {
                  favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                  favoriteAudiosBox.delete(audio!.id);
                }
                ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(
                        audio!, favoritesActionPerformed, favoriteAudiosBox)
                    .build(context));
              },
              child: ValueListenableBuilder(
                  valueListenable: favoriteAudiosBox.listenable(),
                  builder: (context, Box<Audio> box, widget) {
                    return IconTheme(
                        data: new IconThemeData(color: Colors.redAccent),
                        child: Icon(
                          (box.get(audio!.id) == null)
                              ? Icons.favorite_border
                              : Icons.favorite,
                          size: 24,
                        ));
                  }),
            ),
          ),
        ],
        //: Center(child: Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 18),)),
      ),
    );
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
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (BuildContext context, int index) {
                    AudioFolder audioFolder =
                        Adapter.firebaseAudioFolderSnapshotToAudioFolder(
                            snapshot.data!.docs[index]);
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
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AudioFolderScreen(audioFolder)));
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2, left: 4, right: 2, bottom: 2),
                                      child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://i.postimg.cc/RZJ6HJrw/c.jpg')),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
        return Center(
            child: Container(
                height: 24, width: 24, child: CircularProgressIndicator()));
      },
    );
  }
}

class FavoritesSnackBar extends StatelessWidget {
  Audio a;
  String favoritesActionPerformed;
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
  late String snackBarText;

  FavoritesSnackBar(
      this.a, this.favoritesActionPerformed, this.favoriteAudiosBox) {
    if (this.favoritesActionPerformed == FAVORITES_ACTION_REMOVE) {
      snackBarText = 'Removed from Favorites';
    } else {
      snackBarText = 'Added to Favorites';
    }
  }

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

class AudioSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        query = "";
        close(context, "false");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Box hiveBox = Hive.box(HIVE_BOX_AUDIO_SEARCH);

    if (query.isEmpty) {
      var suggestionList = hiveBox.get('search_audios_1');
      suggestionList =
          (suggestionList == null) ? [] : suggestionList.reversed.toList();
      return ListView.builder(
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            _updateSavedSuggestions(hiveBox, suggestionList[index]);
            // HIVE_BOX_AUDIO_SEARCH_SELECTED_ITEM
            // TODO - pass the type that we select form hive list
            query = suggestionList[index];
            // close(context, "true");
          },
          leading: Icon(Icons.music_note),
          title: Text(suggestionList[index]),
        ),
        itemCount: suggestionList.length,
      );
    } else if (query.length > 2) {
      return StatefulBuilder(
        builder: (context, setState) {
          return StreamBuilder<QuerySnapshot>(
            stream: _firestoreSnapshots[_selectedSearchFilter],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var docs = _filterDocs(snapshot.data!.docs, query);
                return Column(
                  children: [
                    Container(
                      height: 56,
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              scrollDirection: Axis.horizontal,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount:
                                      _searchScreenSuggestionBoxes.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0,
                                          right: 5.0,
                                          top: 6,
                                          bottom: 6),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                        decoration: new BoxDecoration(
                                          color: this._selectedSearchFilter ==
                                                  index
                                              ? Color(0xFF0077C2)
                                              : Color(0xFFBDDEFB),
                                          borderRadius: new BorderRadius.all(
                                              Radius.elliptical(80, 100)),
                                        ),
                                        height: 36,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              this._selectedSearchFilter =
                                                  index;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                _searchScreenSuggestionBoxes[
                                                        index]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color:
                                                        this._selectedSearchFilter ==
                                                                index
                                                            ? Colors.white
                                                            : Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          // Audio audio =
                          //     Adapter.firebaseAudioSnapshotToAudio(docs[index]);
                          return ListTile(
                            onTap: () {
                              _updateSavedSuggestions(
                                  hiveBox, docs[index]['name']);
                              hiveBox.put(
                                  HIVE_BOX_AUDIO_SEARCH_KEY_SELECTED_ITEM,
                                  docs[index]['id']);
                              close(
                                  context,
                                  this._searchScreenSuggestionBoxes[
                                      this._selectedSearchFilter]);
                            },
                            leading: Icon(Icons.music_note),
                            title: Text(docs[index]['name'] ?? ''),
                          );
                        }),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void _updateSavedSuggestions(Box hiveBox, String suggestion) {
    var recentSearches = hiveBox.get('search_audios_1');
    recentSearches =
        (recentSearches == null) ? [] : recentSearches.reversed.toList();

    if (!recentSearches.contains(suggestion)) {
      recentSearches = recentSearches.reversed.toList();
      recentSearches.add(suggestion);
    } else {
      recentSearches = recentSearches.reversed.toList();
      recentSearches.removeWhere((item) => item == suggestion);
      recentSearches.add(suggestion);
    }
    if (recentSearches.length > 5) {
      recentSearches.removeAt(0);
    }
    hiveBox.put('search_audios_1', recentSearches);
  }

  List<QueryDocumentSnapshot<Object?>> _filterDocs(
      List<QueryDocumentSnapshot<Object?>> docs, String query) {
    query = query.trim().toLowerCase();
    List<QueryDocumentSnapshot<Object?>> matchedByName = [];
    List<QueryDocumentSnapshot<Object?>> matchedByTags = [];
    var matchedSet = new Set();

    if (this._searchScreenSuggestionBoxes[this._selectedSearchFilter] ==
            SERIES ||
        this._searchScreenSuggestionBoxes[this._selectedSearchFilter] ==
            SEMINARS) {
      matchedByName = docs.where((element) {
        return (element['name'] as String).toLowerCase().contains(query);
      }).toList();
    } else if (this._searchScreenSuggestionBoxes[this._selectedSearchFilter] ==
            TRACKS ||
        this._searchScreenSuggestionBoxes[this._selectedSearchFilter] ==
            SHORT_AUDIOS) {
      // all audios and short audios
      matchedByName = docs.where((element) {
        bool isAMatch =
            (element['name'] as String).toLowerCase().contains(query);
        if (isAMatch) matchedSet.add(element['id']);
        return isAMatch;
      }).toList();
      matchedByTags = docs
          .where((element) => (!matchedSet.contains(element['id']) &&
              (element['tags'] as String).toLowerCase().contains(query)))
          .toList();
    }

    return [...matchedByName, ...matchedByTags];
  }

  var _searchScreenSuggestionBoxes = [
    TRACKS,
    SERIES,
    SEMINARS,
    SHORT_AUDIOS,
  ];
  int _selectedSearchFilter = 0;
  var _firestoreSnapshots = [
    FirebaseFirestore.instance
        .collection("audios")
        .where('isShortAudio', isEqualTo: false)
        .snapshots(),
    FirebaseFirestore.instance.collection("series").snapshots(),
    FirebaseFirestore.instance.collection("seminars").snapshots(),
    FirebaseFirestore.instance
        .collection("audios")
        .where('isShortAudio', isEqualTo: true)
        .snapshots(),
  ];
}
