import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/background/background_audio_controls.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerBackgroundTasks());
}

class FavoriteAudios extends StatelessWidget {
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: favoriteAudiosBox.listenable(),
            builder: (context, Box<Audio> box, widget) {
              return Expanded(
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
                                // if (!playing) {
                                if (!AudioService.running) {
                                  AudioService.start(
                                      androidNotificationIcon: 'mipmap/ic_launcher',
                                      backgroundTaskEntrypoint: _backgroundTaskEntrypoint
                                  );//, params: {"url": audio.url});
                                  await AudioService.connect();
                                }
                                if (AudioService.currentMediaItem?.id != mediaItem.id) {
                                  AudioService.playMediaItem(mediaItem);
                                }
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
                                          Text('${favoriteAudiosBox.getAt(index)?.name}', style: TextStyle(fontSize: 16),),
                                          Text('${favoriteAudiosBox.getAt(index)?.name}', style: TextStyle(fontSize: 12),),
                                        ],
                                      ),
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(flex: 1,
                            child: InkWell(
                              onTap: () {
                                String favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(favoriteAudiosBox.getAt(index)!, favoritesActionPerformed, favoriteAudiosBox).build(context));
                                favoriteAudiosBox.delete(favoriteAudiosBox.getAt(index)?.id);
                              },
                              child: IconTheme(
                                data: new IconThemeData(color: Colors.redAccent),
                                child: Icon((box.get(favoriteAudiosBox.getAt(index)?.id) == null) ? Icons.favorite_border : Icons.favorite,
                                  size: 24,
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              );
            }
          ),
          Miniplayer(),
        ],
      )
    );
  }
}
