import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteAudios extends StatelessWidget {
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorite Audios'),
        ),
        body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: favoriteAudiosBox.listenable(),
              builder: (context, Box<Audio> box, widget) {
                if (favoriteAudiosBox.length == 0) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text('No audios added to favorites. Visit library to add audios to favorites list.'),
                    ),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: favoriteAudiosBox.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 80,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: InkWell(
                                      onTap: () async {
                                        MediaItem mediaItem = Adapter.audioToMediaItem(favoriteAudiosBox.getAt(index));
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AudioPlayScreen(
                                                      mediaItem: mediaItem,
                                                    )));
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 2, left: 4, right: 2, bottom: 2),
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
                                                    Text(
                                                      '${favoriteAudiosBox.getAt(index)?.name}',
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                    Text(
                                                      '${favoriteAudiosBox.getAt(index)?.name}',
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Audio audio = favoriteAudiosBox.getAt(index)!;
                                        favoriteAudiosBox.delete(favoriteAudiosBox.getAt(index)?.id);
                                        ScaffoldMessenger.of(context).showSnackBar(FavoriteAudioSnackBar(
                                          audio: audio,
                                          favoritesActionPerformed: FAVORITES_ACTION_REMOVE,
                                          displayUndoAction: true,
                                        ).build(context));
                                      },
                                      child: IconTheme(
                                          data: new IconThemeData(color: Colors.redAccent),
                                          child: Icon(
                                            (box.get(favoriteAudiosBox.getAt(index)?.id) == null)
                                                ? Icons.favorite_border
                                                : Icons.favorite,
                                            size: 24,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    Miniplayer(),
                  ],
                );
              }),
        ));
  }
}

class FavoriteAudioSnackBar extends StatelessWidget {
  final Audio audio;
  final String favoritesActionPerformed;
  final Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
  late String _snackBarText;
  final bool displayUndoAction;

  FavoriteAudioSnackBar(
      {required this.audio, required this.favoritesActionPerformed, required this.displayUndoAction}) {
    if (this.favoritesActionPerformed == FAVORITES_ACTION_REMOVE) {
      _snackBarText = 'Removed from Favorites';
    } else {
      _snackBarText = 'Added to Favorites';
    }
  }

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      action: this.displayUndoAction
          ? SnackBarAction(
              label: 'Undo',
              onPressed: () {
                if (favoritesActionPerformed == FAVORITES_ACTION_REMOVE) {
                  _snackBarText = 'Added to Favorites';
                  favoriteAudiosBox.put(audio.id, audio);
                } else {
                  _snackBarText = 'Removed from Favorites';
                  favoriteAudiosBox.delete(audio.id);
                }
              },
            )
          : null,
      content: Text(_snackBarText),
      duration: Duration(milliseconds: 1000),
    );
  }
}
