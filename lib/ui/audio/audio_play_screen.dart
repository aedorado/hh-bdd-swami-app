import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/assets/constants.dart';
// import 'package:hh_bbds_app/background/audio_handler.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/podo/media_state.dart';
import 'package:hh_bbds_app/notifiers/play_button_notifier.dart';
import 'package:hh_bbds_app/notifiers/progress_notifier.dart';
import 'package:hh_bbds_app/streams/streams.dart';
import 'package:hh_bbds_app/ui/audio/page_manager.dart';
import 'package:hh_bbds_app/ui/favorites/favorite_audios.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

GetIt getIt = GetIt.instance;

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
  late MediaItem mediaItem;

  AudioPlayScreen(MediaItem this.mediaItem);

  @override
  _AudioPlayScreenState createState() => _AudioPlayScreenState();
}

class _AudioPlayScreenState extends State<AudioPlayScreen> {
  bool playing = false;
  final pageManager = getIt<PageManager>();
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);

  void initAudioPlayer() async {
    final pageManager = getIt<PageManager>();
    if (widget.mediaItem != null) {
      pageManager.playMediaItem(widget.mediaItem);
      // final _audioHandler = getIt<AudioHandler>();
      // _audioHandler.playMediaItem(widget.mediaItem);
      // pageManager.playMediaItem(widget.mediaItem);
      // pageManager.setAudioSource(widget.mediaItem);
      // pageManager.playFromUri(widget.mediaItem);
      // if (!AudioService.running) {
      // await AudioService.start(
      //     androidNotificationIcon: 'mipmap/ic_launcher',); //, params: {"url": audio.url});
      // }
      // if (widget.mediaItem != null) {
      //   if (AudioService.currentMediaItem?.id != widget.mediaItem?.id) {
      //     await AudioService.playMediaItem(widget.mediaItem!);
      //   } else {
      //     AudioService.play();
      //   }
      // }
    }
    // else {
    //   AudioService.play();
    // }
  }

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Audio Library")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                // padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 8.0),
                            color: Color(0x88BDBDBD),
                            blurRadius: 8)
                      ],
                      image: DecorationImage(
                          image:
                              NetworkImage(widget.mediaItem.artUri.toString()),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  // TODO add a loader to hide controls while audio is loading in background?
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 18, right: 18, top: 12),
                        child: Column(
                          children: [
                            Text(
                              widget.mediaItem.title,
                              style: audioTitleStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.mediaItem.extras!['subtitle'] ?? '',
                              style: audioSubtitleStyle,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, top: 20, bottom: 10),
                      child: AudioProgressBar(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF004BA0),
                        ),
                        child: Center(
                          child: PlayButton(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 50, right: 50, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: InkWell(
                              onTap: () {
                                String? currentMediaItemId =
                                    widget.mediaItem.id;
                                String favoritesActionPerformed;
                                if (favoriteAudiosBox.get(currentMediaItemId) ==
                                    null) {
                                  favoritesActionPerformed =
                                      FAVORITES_ACTION_ADD;
                                  favoriteAudiosBox.put(
                                      currentMediaItemId,
                                      Adapter.mediaItemToAudio(
                                          widget.mediaItem));
                                } else {
                                  favoritesActionPerformed =
                                      FAVORITES_ACTION_REMOVE;
                                  favoriteAudiosBox.delete(currentMediaItemId);
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(FavoriteAudioSnackBar(
                                  audio: Adapter.mediaItemToAudio(
                                      widget.mediaItem),
                                  favoritesActionPerformed:
                                      favoritesActionPerformed,
                                  displayUndoAction: false,
                                ).build(context));
                              },
                              child: ValueListenableBuilder(
                                  valueListenable:
                                      favoriteAudiosBox.listenable(),
                                  builder: (context, Box<Audio> box, _) {
                                    MediaItem mi = widget.mediaItem;
                                    return IconTheme(
                                        data: new IconThemeData(
                                            color: Colors.redAccent),
                                        child: Icon(
                                          (box.get(mi.id)) == null
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
        ),
      ),
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
        );
      },
    );
  }
}

class PlayButton extends StatefulWidget {
  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              color: Colors.white,
              iconSize: 36,
              icon: Icon(Icons.play_arrow),
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              color: Colors.white,
              iconSize: 36,
              icon: Icon(Icons.pause),
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}
