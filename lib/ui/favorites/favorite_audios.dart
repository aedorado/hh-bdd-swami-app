
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class FavoriteAudios extends StatelessWidget {
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: favoriteAudiosBox.listenable(),
              builder: (context, box, widget) {
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
                                          currentAudio.audio = favoriteAudiosBox.getAt(index);
                                          currentAudio.playAudio();
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayScreen()));
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${favoriteAudiosBox.getAt(index).name}', style: TextStyle(fontSize: 16),),
                                            Text('${favoriteAudiosBox.getAt(index).name}', style: TextStyle(fontSize: 12),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              Expanded(flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    String favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                    ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(favoriteAudiosBox.getAt(index), favoritesActionPerformed, favoriteAudiosBox).build(context));
                                    favoriteAudiosBox.delete(favoriteAudiosBox.getAt(index).id);
                                  },
                                  child: IconTheme(
                                    data: new IconThemeData(color: Colors.redAccent),
                                    child: Icon((box.get(favoriteAudiosBox.getAt(index).id) == null) ? Icons.favorite_border : Icons.favorite,
                                      size: 24,
                                    )
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2, right: 4),
                                  child: PopupMenuButton(
                                    onSelected: (item) {
                                      switch (item) {
                                        case FAVORITES_ACTION_REMOVE:
                                          ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(favoriteAudiosBox.getAt(index), item, favoriteAudiosBox).build(context));
                                          favoriteAudiosBox.delete(favoriteAudiosBox.getAt(index).id);
                                          break;
                                        case 'delete':
                                        //TODO: delete item
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(value: FAVORITES_ACTION_REMOVE, child: Text('Remove from Favorites'),),
                                        PopupMenuItem(value: 'delete', child: Text('Play Next'),),
                                        PopupMenuItem(value: 'delete', child: Text('Add to Queue'),),
                                      ];
                                    },
                                  ),
                                ),

                              ),
                              // Expanded(
                              //   flex: 1,
                              //   child: Consumer<CurrentAudio>(
                              //     builder: (_, currentAudio, child) => InkWell(
                              //         onTap: () {
                              //           // if audio is playing and user clicks on the button for the audio that is playing then pause audio
                              //           if (currentAudio.isPlaying && (index == currentAudio.currentAudioIndex)) {
                              //             currentAudio.pauseAudio();
                              //           } else if (currentAudio.isPlaying && (index != currentAudio.currentAudioIndex)) { // user clicks on play button for an audio that is not playing currently
                              //             currentAudio.stopAudio();
                              //             currentAudio.currentAudioIndex = index;
                              //             currentAudio.audio = favoriteAudiosBox.getAt(index);
                              //             currentAudio.playAudio();
                              //           } else if (!currentAudio.isPlaying) { // if ndebugot audio is playing, simply start playing current audio
                              //             currentAudio.currentAudioIndex = index;
                              //             currentAudio.audio = favoriteAudiosBox.getAt(index);
                              //             currentAudio.playAudio();
                              //           }
                              //         },
                              //         child: Icon((index == currentAudio.currentAudioIndex && currentAudio.isPlaying) ? Icons.pause : Icons.play_arrow)),
                              //   ),
                              // ),
                              // Divider(color: Colors.black, height: 1,),
                            ],
                            //: Center(child: Text('${favoriteAudiosBox.getAt(index).name}', style: TextStyle(fontSize: 18),)),
                          ),
                        );
                      }
                  ),
                );
              }
            ),
            Miniplayer(),
          ],
        ));
  }
}
