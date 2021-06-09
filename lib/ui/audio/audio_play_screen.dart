import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/podo/media_state.dart';
import 'package:hh_bbds_app/streams/streams.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

var audioTitleStyle = TextStyle(
  // fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 20.0,
  decoration: TextDecoration.none,
);

var audioSubtitleStyle = TextStyle(
  // fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 14.0,
  decoration: TextDecoration.none,
);

class AudioPlayScreen extends StatefulWidget {
  @override
  _AudioPlayScreenState createState() => _AudioPlayScreenState();
}

class _AudioPlayScreenState extends State<AudioPlayScreen> {
  bool playing = false;

  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BDD Swami App"), backgroundColor: Colors.blue[800]),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[800]!,
                  Colors.blue[200]!,
                ]),
          ),
          child: StreamBuilder<MediaState>(
              stream: CustomStream.mediaStateStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(4),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       InkWell(
                    //         onTap: () {
                    //           Navigator.push(context, MaterialPageRoute(builder: (context) => AudioQueueScreen()));
                    //         },
                    //         child: Icon(Icons.queue_music, size: 32),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 48, right: 48, top: 24, bottom: 12),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://i1.sndcdn.com/artworks-000674039176-uw34hj-t500x500.jpg"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                          child: snapshot.hasData ? Column(
                            children: [
                              Text(snapshot.data?.mediaItem?.title ?? '', style: audioTitleStyle, textAlign: TextAlign.center,),
                              Text(snapshot.data?.mediaItem?.extras!['subtitle'] ?? '', style: audioSubtitleStyle, textAlign: TextAlign.center,),
                            ],
                          ): Container(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
                                child: snapshot.hasData ? ProgressBar(
                                  total: snapshot.data?.mediaItem?.duration ?? Duration.zero,
                                  progress: snapshot.data?.position ?? Duration.zero,
                                  buffered: snapshot.data?.playbackState == null ? Duration.zero : snapshot.data?.playbackState.bufferedPosition,
                                  onSeek: (duration) {
                                    print('User selected a new time: $duration');
                                    AudioService.seekTo(duration);
                                  },
                                ): Container(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Flexible(
                                    //   child: Container(
                                    //     child: InkWell(
                                    //       onTap: () {
                                    //
                                    //       },
                                    //       child: Center(
                                    //           child: Icon(Icons.skip_previous, size: 40, color: Color(0xFF1976D2),)
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF004BA0),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            if ((snapshot.hasData && snapshot.data?.playbackState != null && snapshot.data?.playbackState.playing == true)) {
                                              AudioService.pause();
                                            } else {
                                              if (snapshot.hasData
                                                  && snapshot.data?.playbackState != null
                                                  && snapshot.data?.playbackState.processingState == AudioProcessingState.completed) {
                                                AudioService.seekTo(Duration(milliseconds: 0));
                                              }
                                              AudioService.play();
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Center(
                                                child: Icon( (snapshot.hasData
                                                    && snapshot.data?.playbackState != null
                                                    && snapshot.data?.playbackState.playing == true
                                                    && snapshot.data?.playbackState.processingState != AudioProcessingState.completed)
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                  size: 44,
                                                  color: Colors.white,)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Flexible(
                                    //   child: Container(
                                    //     child: InkWell(
                                    //       onTap: () {
                                    //       },
                                    //       child: Center(
                                    //           child: Icon(Icons.skip_next, size: 40, color: Color(0xFF1976D2),)
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      child: InkWell(
                                        onTap: () {
                                          String? currentMediaItemId = snapshot.data?.mediaItem?.id;
                                          String favoritesActionPerformed;
                                          if (favoriteAudiosBox.get(currentMediaItemId) == null) {
                                            favoritesActionPerformed = FAVORITES_ACTION_ADD;
                                            favoriteAudiosBox.put(currentMediaItemId, Adapter.mediaItemToAudio(snapshot.data?.mediaItem));
                                          } else {
                                            favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                            favoriteAudiosBox.delete(currentMediaItemId);
                                          }
                                          ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(Adapter.mediaItemToAudio(snapshot.data?.mediaItem), favoritesActionPerformed, favoriteAudiosBox).build(context));
                                        },
                                        child: ValueListenableBuilder(
                                            valueListenable: favoriteAudiosBox.listenable(),
                                            builder: (context, Box<Audio> box, widget) {
                                              return IconTheme(
                                                  data: new IconThemeData(color: Colors.redAccent),
                                                  child: Icon((box.get(snapshot.data?.mediaItem?.id) == null) ? Icons.favorite_border : Icons.favorite, size: 36,)
                                              );
                                            }
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   child: InkWell(
                                    //     onTap: () {
                                    //       // debugPrint('Before: ${audioQueue.shuffle}');
                                    //       // audioQueue.shuffle = !audioQueue.shuffle;
                                    //       // debugPrint('After: ${audioQueue.shuffle}');
                                    //     },
                                    //     child: Container(
                                    //       child: Center(
                                    //         child: IconTheme(
                                    //             data: new IconThemeData(),
                                    //             child: Icon(true ? Icons.shuffle_on : Icons.shuffle, size: 36,)
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   child: InkWell(
                                    //     onTap: () {
                                    //       // String favoritesActionPerformed;
                                    //       // if (favoriteAudiosBox.get(currentAudio.audio.id) == null) {
                                    //       //   favoritesActionPerformed = FAVORITES_ACTION_ADD;
                                    //       //   favoriteAudiosBox.put(currentAudio.audio.id, currentAudio.audio);
                                    //       // } else {
                                    //       //   favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                    //       //   favoriteAudiosBox.delete(currentAudio.audio.id);
                                    //       // }
                                    //       // ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(currentAudio.audio, favoritesActionPerformed, favoriteAudiosBox).build(context));
                                    //     },
                                    //     child: Container(
                                    //       child: Center(
                                    //         child: IconTheme(
                                    //             data: new IconThemeData(color: Color(0xFF42A5F5)),
                                    //             child: Icon(true ? Icons.repeat : Icons.repeat_on,
                                    //               size: 36,)
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   child: InkWell(
                                    //     onTap: () {
                                    //       String favoritesActionPerformed;
                                    //       // if (favoriteAudiosBox.get(currentAudio.audio.id) == null) {
                                    //       //   favoritesActionPerformed = FAVORITES_ACTION_ADD;
                                    //       //   favoriteAudiosBox.put(currentAudio.audio.id, currentAudio.audio);
                                    //       // } else {
                                    //       //   favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                    //       //   favoriteAudiosBox.delete(currentAudio.audio.id);
                                    //       // }
                                    //       // ScaffoldMessenger.of(context).showSnackBar(FavoritesSnackBar(currentAudio.audio, favoritesActionPerformed, favoriteAudiosBox).build(context));
                                    //     },
                                    //     child: Container(
                                    //       child: Center(
                                    //         child: IconTheme(
                                    //             data: new IconThemeData(color: Color(0xFF42A5F5)),
                                    //             child: Icon(Icons.queue_music, size: 36,)
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),

                              ),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}

