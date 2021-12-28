import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/notifiers/play_button_notifier.dart';
import 'package:hh_bbds_app/notifiers/progress_notifier.dart';
import 'package:hh_bbds_app/ui/audio/page_manager.dart';
import 'package:hh_bbds_app/ui/favorites/favorite_audios.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

GetIt getIt = GetIt.instance;

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
      MediaItem? currentMediaItem = pageManager.currentMediaItemNotifier.value;
      if (currentMediaItem == null ||
          currentMediaItem != null && currentMediaItem.id != widget.mediaItem.id) {
        pageManager.playMediaItem(widget.mediaItem);
      }
    }
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
                padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                // padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, 8.0), color: Color(0x88BDBDBD), blurRadius: 8)
                      ],
                      image: DecorationImage(
                          image: NetworkImage(widget.mediaItem.artUri.toString()),
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
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 12),
                        child: Column(
                          children: [
                            Text(
                              widget.mediaItem.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.mediaItem.extras!['subtitle'] ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                decoration: TextDecoration.none,
                              ),
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
                      padding: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
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
                          child: PlayButton(iconSize: 36),
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: AudioSpeedPicker()),
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
                                String? currentMediaItemId = widget.mediaItem.id;
                                String favoritesActionPerformed;
                                if (favoriteAudiosBox.get(currentMediaItemId) == null) {
                                  favoritesActionPerformed = FAVORITES_ACTION_ADD;
                                  favoriteAudiosBox.put(currentMediaItemId,
                                      Adapter.mediaItemToAudio(widget.mediaItem));
                                } else {
                                  favoritesActionPerformed = FAVORITES_ACTION_REMOVE;
                                  favoriteAudiosBox.delete(currentMediaItemId);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(FavoriteAudioSnackBar(
                                  audio: Adapter.mediaItemToAudio(widget.mediaItem),
                                  favoritesActionPerformed: favoritesActionPerformed,
                                  displayUndoAction: false,
                                ).build(context));
                              },
                              child: ValueListenableBuilder(
                                  valueListenable: favoriteAudiosBox.listenable(),
                                  builder: (context, Box<Audio> box, _) {
                                    MediaItem mi = widget.mediaItem;
                                    return IconTheme(
                                        data: new IconThemeData(color: Colors.redAccent),
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

  double iconSize;
  PlayButton({required this.iconSize});
}

class _PlayButtonState extends State<PlayButton> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
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
              iconSize: widget.iconSize,
              icon: Icon(Icons.play_arrow),
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              color: Colors.white,
              iconSize: widget.iconSize,
              icon: Icon(Icons.pause),
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}

class AudioSpeedPicker extends StatefulWidget {
  const AudioSpeedPicker({Key? key}) : super(key: key);

  @override
  State<AudioSpeedPicker> createState() => _AudioSpeedPickerState();
}

class _AudioSpeedPickerState extends State<AudioSpeedPicker> {
  final pageManager = getIt<PageManager>();
  late String originalSpeed;

  @override
  void initState() {
    super.initState();
    double osp = pageManager.playbackSpeedNotifier.value;
    if (osp == 0.75)
      this.originalSpeed = '0.75';
    else if (osp == 1.0)
      this.originalSpeed = '1';
    else if (osp == 1.5)
      this.originalSpeed = '1.5';
    else if (osp == 2) this.originalSpeed = '2';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: originalSpeed,
      // icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: (String? updatedSpeed) {
        if (updatedSpeed != this.originalSpeed) {
          setState(() {
            originalSpeed = updatedSpeed!;
          });
          pageManager.setSpeed(double.parse(updatedSpeed ?? '1'));
        }
      },
      items: <String>['0.75', '1', '1.5', '2'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value + 'x'),
        );
      }).toList(),
    );
  }
}
