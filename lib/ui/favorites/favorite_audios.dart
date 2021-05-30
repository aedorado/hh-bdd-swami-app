
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class FavoriteAudios extends StatelessWidget {
  Box<Audio> favBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            physics:
            BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: favBox.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Text('${favBox.getAt(index).name}'),
              );
              // return Container(
              //   height: 80,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         flex: 2,
              //         child: Padding(
              //           padding: const EdgeInsets.only(
              //               top: 2, left: 2, right: 2, bottom: 2),
              //           child: CircleAvatar(
              //               backgroundImage: NetworkImage(
              //                   'https://i.postimg.cc/RZJ6HJrw/c.jpg')),
              //         ),
              //       ),
              //       Expanded(
              //           flex: 6,
              //           child: Padding(
              //             padding: const EdgeInsets.all(12.0),
              //             child: Consumer<CurrentAudio>(
              //               builder: (_, currentAudio, child) => InkWell(
              //                 onTap: () {
              //                   currentAudio.audio = favBox.getAt(index);
              //                   currentAudio.currentAudioIndex = index;
              //                   Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayScreen()));
              //                 },
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 16),),
              //                     Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 12),),
              //                     // if (currentAudio.isPlaying && index == currentAudio.currentAudioIndex) Text(currentAudio.currentAudioPosition.toString().split('.').first),
              //                     // if (currentAudio.isPlaying && index == currentAudio.currentAudioIndex) Text(currentAudio.totalAudioDuration.toString().split('.').first),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           )
              //       ),
              //       Expanded(flex: 1,
              //         child: InkWell(
              //           onTap: () {
              //             debugPrint('${favBox.get(snapshot.data[index].name)}');
              //             favBox.put(snapshot.data[index].name, snapshot.data[index]);
              //             // debugPrint(favBox.get('key'));
              //             final snackBar = SnackBar(
              //                 action: SnackBarAction(
              //                   label: 'Undo',
              //                   onPressed: () {
              //                     // Some code to undo the change.
              //                   },
              //                 ),
              //                 content: Text('Added to Favorites!')
              //             );
              //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //           },
              //           child: IconTheme(
              //               data: new IconThemeData(color: Colors.redAccent),
              //               child: Icon(
              //                 favBox.get(snapshot.data[index].name) == null ? Icons.favorite_border : Icons.favorite,
              //                 size: 24,
              //               )),
              //         ),
              //       ),
              //       Expanded(
              //         flex: 1,
              //         child: Padding(
              //           padding: EdgeInsets.only(left: 8),
              //           child: PopupMenuButton(
              //             onSelected: (item) {
              //               switch (item) {
              //                 case 'update':
              //                   debugPrint('Updating...');
              //                   // nameController.text = 'update name';
              //                   // descriptionController.text =
              //                   // 'update description';
              //                   //
              //                   // inputItemDialog(context, 'update', index);
              //                   break;
              //                 case 'delete':
              //                 //TODO: delete item
              //               }
              //             },
              //             itemBuilder: (context) {
              //               return [
              //                 PopupMenuItem(
              //                   value: 'update',
              //                   child: Text('Update'),
              //
              //                 ),
              //                 PopupMenuItem(
              //                   value: 'delete',
              //                   child: Text('Delete'),
              //                 ),
              //               ];
              //             },
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         flex: 1,
              //         child: Consumer<CurrentAudio>(
              //           builder: (_, currentAudio, child) => InkWell(
              //               onTap: () {
              //                 // if audio is playing and user clicks on the button for the audio that is playing then pause audio
              //                 if (currentAudio.isPlaying && (index == currentAudio.currentAudioIndex)) {
              //                   currentAudio.pauseAudio();
              //                 } else if (currentAudio.isPlaying && (index != currentAudio.currentAudioIndex)) { // user clicks on play button for an audio that is not playing currently
              //                   currentAudio.stopAudio();
              //                   currentAudio.currentAudioIndex = index;
              //                   currentAudio.audio = snapshot.data[index];
              //                   currentAudio.playAudio();
              //                 } else if (!currentAudio.isPlaying) { // if ndebugot audio is playing, simply start playing current audio
              //                   currentAudio.currentAudioIndex = index;
              //                   currentAudio.audio = snapshot.data[index];
              //                   currentAudio.playAudio();
              //                 }
              //               },
              //               child: Icon((index == currentAudio.currentAudioIndex && currentAudio.isPlaying) ? Icons.pause : Icons.play_arrow)),
              //         ),
              //       ),
              //       // Divider(color: Colors.black, height: 1,),
              //     ],
              //     //: Center(child: Text('${snapshot.data[index].name}', style: TextStyle(fontSize: 18),)),
              //   ),
              // );
            }));
  }
}
