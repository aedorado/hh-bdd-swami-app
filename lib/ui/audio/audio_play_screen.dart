import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/background/background_audio_controls.dart';
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

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerBackgroundTasks());
}

class AudioPlayScreen extends StatefulWidget {
  final MediaItem? mediaItem;

  AudioPlayScreen({MediaItem? this.mediaItem});

  @override
  _AudioPlayScreenState createState() => _AudioPlayScreenState();
}

class _AudioPlayScreenState extends State<AudioPlayScreen>
    with SingleTickerProviderStateMixin {
  bool playing = false;
  late AnimationController controller;
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  void initAudioPlayer() async {
    if (widget.mediaItem != null) {
      await AudioService.connect();
      if (!AudioService.running) {
        await AudioService.start(
            androidNotificationIcon: 'mipmap/ic_launcher',
            backgroundTaskEntrypoint:
                _backgroundTaskEntrypoint); //, params: {"url": audio.url});
      }
      if (widget.mediaItem != null) {
        if (AudioService.currentMediaItem?.id != widget.mediaItem?.id) {
          await AudioService.playMediaItem(widget.mediaItem!);
        } else {
          AudioService.play();
        }
      }
    } else {
      AudioService.play();
    }
  }

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audio Library")),
      body: SafeArea(
        child: StreamBuilder<MediaState>(
            stream: CustomStream.mediaStateStream,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 48, right: 48, top: 24, bottom: 12),
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
                    flex: 4,
                    child: Column(
                      children: [
                        // TODO add a loader to hide controls while audio is loading in background?
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 50, right: 50, top: 16),
                              child: snapshot.hasData
                                  ? Column(
                                      children: [
                                        Text(
                                          snapshot.data?.mediaItem?.title ?? '',
                                          style: audioTitleStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          snapshot.data?.mediaItem
                                                  ?.extras!['subtitle'] ??
                                              '',
                                          style: audioSubtitleStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 20, bottom: 10),
                            child: snapshot.hasData
                                ? ProgressBar(
                                    total: snapshot.data?.mediaItem?.duration ??
                                        Duration.zero,
                                    progress: snapshot.data?.position ??
                                        Duration.zero,
                                    buffered:
                                        snapshot.data?.playbackState == null
                                            ? Duration.zero
                                            : snapshot.data?.playbackState
                                                .bufferedPosition,
                                    onSeek: (duration) {
                                      print(
                                          'User selected a new time: $duration');
                                      AudioService.seekTo(duration);
                                    },
                                  )
                                : Container(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 10, bottom: 10),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xFF004BA0),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: IconButton(
                                color: Colors.white,
                                iconSize: 32,
                                icon:
                                    // Icon(snapshot.hasData && snapshot.data!.shouldPause() ? Icons.pause : Icons.play_arrow),
                                    AnimatedIcon(
                                  icon: AnimatedIcons.pause_play,
                                  progress: controller,
                                ),
                                onPressed: () {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.shouldPause()) {
                                      AudioService.pause();
                                      controller.forward();
                                    } else {
                                      if (snapshot.data!.shouldReplay()) {
                                        AudioService.seekTo(
                                            Duration(milliseconds: 0));
                                      }
                                      AudioService.play();
                                      controller.reverse();
                                    }
                                  }
                                  // query = "";
                                  // close(context, "false");
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: InkWell(
                                    onTap: () {
                                      String? currentMediaItemId =
                                          snapshot.data?.mediaItem?.id;
                                      String favoritesActionPerformed;
                                      if (favoriteAudiosBox
                                              .get(currentMediaItemId) ==
                                          null) {
                                        favoritesActionPerformed =
                                            FAVORITES_ACTION_ADD;
                                        favoriteAudiosBox.put(
                                            currentMediaItemId,
                                            Adapter.mediaItemToAudio(
                                                snapshot.data?.mediaItem));
                                      } else {
                                        favoritesActionPerformed =
                                            FAVORITES_ACTION_REMOVE;
                                        favoriteAudiosBox
                                            .delete(currentMediaItemId);
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(FavoritesSnackBar(
                                                  Adapter.mediaItemToAudio(
                                                      snapshot.data?.mediaItem),
                                                  favoritesActionPerformed,
                                                  favoriteAudiosBox)
                                              .build(context));
                                    },
                                    child: ValueListenableBuilder(
                                        valueListenable:
                                            favoriteAudiosBox.listenable(),
                                        builder:
                                            (context, Box<Audio> box, widget) {
                                          MediaItem? mi =
                                              snapshot.data?.mediaItem;
                                          return IconTheme(
                                              data: new IconThemeData(
                                                  color: Colors.redAccent),
                                              child: Icon(
                                                (mi == null)
                                                    ? Icons.favorite_border
                                                    : (box.get(mi.id)) == null
                                                        ? Icons.favorite_border
                                                        : Icons.favorite,
                                                size: 36,
                                              ));
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              );
            }),
      ),
    );
  }
}
