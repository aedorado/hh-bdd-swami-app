import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/network/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
    fetchAudios('https://mocki.io/v1/00c25346-891a-4a2a-987e-4a9c1a6c637e'),
    fetchAudios('https://mocki.io/v1/6817415e-fc15-4ed5-b6a2-e811e45802f5'),
    fetchAudios('https://mocki.io/v1/f3ed5273-36ea-4bc1-b6b7-31df45d77a35'),
    fetchAudios('https://mocki.io/v1/6817415e-fc15-4ed5-b6a2-e811e45802f5'),
    fetchAudios('https://mocki.io/v1/00c25346-891a-4a2a-987e-4a9c1a6c637e'),
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
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

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
                          // Image
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
                          // Title
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Consumer<CurrentAudio>(
                                builder: (_, currentAudio, child) => InkWell(
                                  onTap: () {
                                    currentAudio.audio = snapshot.data[index];
                                    currentAudio.playAudio();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayScreen()));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 16),),
                                      Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 12),),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ),
                          // Favorite Icon
                          Expanded(flex: 1,
                            child: InkWell(
                              onTap: () {
                                String favoritesActionPerformed;
                                if (favoriteAudiosBox.get(snapshot.data[index].id) == null) {
                                  favoritesActionPerformed = FAVORITES_ACTION_ADD;
                                  favoriteAudiosBox.put(snapshot.data[index].id, snapshot.data[index]);
                                } else {
                                  favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                  favoriteAudiosBox.delete(snapshot.data[index].id);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(snapshot.data[index], favoritesActionPerformed, favoriteAudiosBox).build(context));
                              },
                              child: ValueListenableBuilder(
                                valueListenable: favoriteAudiosBox.listenable(),
                                builder: (context, box, widget) {
                                  return IconTheme(
                                    data: new IconThemeData(color: Colors.redAccent),
                                    child: Icon((box.get(snapshot.data[index].id) == null) ? Icons.favorite_border : Icons.favorite,
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
                                      favoriteAudiosBox.delete(snapshot.data[index].id);
                                      ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(snapshot.data[index], item, favoriteAudiosBox).build(context));
                                      break;
                                    case FAVORITES_ACTION_ADD:
                                      favoriteAudiosBox.put(snapshot.data[index].id, snapshot.data[index]);
                                      ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(snapshot.data[index], item, favoriteAudiosBox).build(context));
                                      break;
                                    case 'delete':
                                    //TODO: delete item
                                  }
                                },
                                itemBuilder: (context) {
                                  return [
                                    (favoriteAudiosBox.get(snapshot.data[index].id) == null) ?
                                     PopupMenuItem(value: FAVORITES_ACTION_ADD, child: Text('Add to Favorites'),) :
                                      PopupMenuItem(value: FAVORITES_ACTION_REMOVE, child: Text('Remove from Favorites'),),
                                    PopupMenuItem(value: 'delete', child: Text('Play Next'),),
                                    PopupMenuItem(value: 'delete', child: Text('Add to Queue'),),
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

  Widget _getFavoriteSnackBar(Audio a, String favoritesActionPerformed) {
    String snackBarText;

    if (favoritesActionPerformed == FAVORITES_ACTION_REMOVE) {
      snackBarText = 'Added to Favorites';
    } else {
      snackBarText = 'Removed from Favorites';
    }

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

class FavoritesSnackBar extends StatelessWidget {

  Audio a;
  String favoritesActionPerformed;
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
  
  FavoritesSnackBar(this.a, this.favoritesActionPerformed, this.favoriteAudiosBox) {
    if (this.favoritesActionPerformed == FAVORITES_ACTION_REMOVE) {
      snackBarText = 'Added to Favorites';
    } else {
      snackBarText = 'Removed from Favorites';
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







