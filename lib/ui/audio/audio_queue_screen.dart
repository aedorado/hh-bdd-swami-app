import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/change_notifiers/audio_queue.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class AudioQueueScreen extends StatelessWidget {

  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Queue'),),
      body: Consumer<AudioQueue>(
        builder: (context, audioQueue, child) =>
          ReorderableListView(
              children: <Widget>[
                for (int index = 0; index < audioQueue.size(); index++)
                  Container(
                    key: Key('$index'),
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
                            child: Icon(Icons.drag_handle),
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
                                    currentAudio.audio = audioQueue.getAt(index);
                                    currentAudio.playAudio();
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${audioQueue.getAt(index).name}', style: TextStyle(fontSize: 16),),
                                      Text('${audioQueue.getAt(index).name}', style: TextStyle(fontSize: 12),),
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
                              if (favoriteAudiosBox.get(audioQueue.getAt(index).id) == null) {
                                favoritesActionPerformed = FAVORITES_ACTION_ADD;
                                favoriteAudiosBox.put(audioQueue.getAt(index).id, audioQueue.getAt(index));
                              } else {
                                favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                favoriteAudiosBox.delete(audioQueue.getAt(index).id);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(audioQueue.getAt(index), favoritesActionPerformed, favoriteAudiosBox).build(context));
                            },
                            child: ValueListenableBuilder(
                                valueListenable: favoriteAudiosBox.listenable(),
                                builder: (context, box, widget) {
                                  return IconTheme(
                                      data: new IconThemeData(color: Colors.redAccent),
                                      child: Icon((box.get(audioQueue.getAt(index).id) == null) ? Icons.favorite_border : Icons.favorite,
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
                                      favoriteAudiosBox.delete(audioQueue.getAt(index).id);
                                      ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(audioQueue.getAt(index), item, favoriteAudiosBox).build(context));
                                      break;
                                    case FAVORITES_ACTION_ADD:
                                      favoriteAudiosBox.put(audioQueue.getAt(index).id, audioQueue.getAt(index));
                                      ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(audioQueue.getAt(index), item, favoriteAudiosBox).build(context));
                                      break;
                                    case REMOVE_FROM_QUEUE:
                                      audioQueue.removeAudioAt(index);
                                      break;
                                  }
                                },
                                itemBuilder: (context) {
                                  return [
                                    (favoriteAudiosBox.get(audioQueue.getAt(index).id) == null) ?
                                    PopupMenuItem(value: FAVORITES_ACTION_ADD, child: Text('Add to Favorites'),) :
                                    PopupMenuItem(value: FAVORITES_ACTION_REMOVE, child: Text('Remove from Favorites'),),
                                    PopupMenuItem(value: REMOVE_FROM_QUEUE, child: Text('Remove from Queue'),),
                                  ];
                                },
                              ),
                          ),
                        ),
                      ],
                      //: Center(child: Text('${audio.name}', style: TextStyle(fontSize: 18),)),
                    ),
                  )
              //     ListTile(
              //       key: Key('$index'),
              //       // tileColor: audioQueue.getAt(index) == null ? oddItemColor : evenItemColor,
              //       title: _getQueueListItem(audioQueue.getAt(index)),
              //     ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                debugPrint(audioQueue.toString());
                audioQueue.rearrange(oldIndex, newIndex);
                debugPrint(audioQueue.toString());
              },
          )
      ),
    );
  }
}

