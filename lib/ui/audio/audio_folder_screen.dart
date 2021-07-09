import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/podo/audio_folder.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hive/hive.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:palette_generator/palette_generator.dart';

class AudioFolderScreen extends StatefulWidget {
  late AudioFolder audioFolder;
  late Stream<QuerySnapshot<Map<String, dynamic>>> ssy;

  AudioFolderScreen(AudioFolder audioFolder) {
    // TODO remove series hardcoding from here
    this.audioFolder = audioFolder;
    this.ssy =
        FirebaseFirestore.instance.collection("audios").where("series", isEqualTo: this.audioFolder.id).snapshots();
  }

  @override
  _AudioFolderScreenState createState() => _AudioFolderScreenState();
}

class _AudioFolderScreenState extends State<AudioFolderScreen> {
  Color? notificationBarColor;

  Future<Color?> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color;
  }

  @override
  void initState() {
    super.initState();
    determineNotificationBarColor();
  }

  determineNotificationBarColor() async {
    var imagePrimaryColor = await getImagePalette(NetworkImage(widget.audioFolder.thumbnailUrl));
    setState(() {
      this.notificationBarColor = imagePrimaryColor;
    });
    debugPrint("Color : ${imagePrimaryColor.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.notificationBarColor ?? Theme.of(context).colorScheme.primaryVariant,
      child: SafeArea(
        child: Scaffold(
          // body: AudioListPage(this.audioListFuture),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: this.widget.ssy,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return AudioFolderScreenSliverList(widget.audioFolder, snapshot);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(child: Container(height: 24, width: 24, child: CircularProgressIndicator()));
                  },
                ),
              ),
              Miniplayer(),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioFolderScreenSliverList extends StatelessWidget {
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
  late AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  late AudioFolder audioFolder;

  AudioFolderScreenSliverList(audioFolder, snapshot) {
    this.audioFolder = audioFolder;
    this.snapshot = snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 300.0,
          floating: true,
          pinned: true,
          snap: false,
          actionsIconTheme: IconThemeData(opacity: 0.0),
          flexibleSpace: Stack(
            children: <Widget>[
              Positioned.fill(
                  child: Image.network(
                this.audioFolder.thumbnailUrl,
                // "https://vrindavandarshan.in/upload_images/dailydarshan/2021-06-01-Mycnz.jpg",
                fit: BoxFit.cover,
              )),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Stack(clipBehavior: Clip.none, children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          '${this.audioFolder.name}',
                          style: TextStyle(fontSize: 24),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        "${this.audioFolder.description}",
                        // '${this.audioFolder.description}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Audio audio = Adapter.firebaseAudioSnapshotToAudio(this.snapshot.data!.docs[index]);
              return AudioListScreenRow(
                audio: audio,
              );
            },
            childCount: this.snapshot.data!.size,
          ),
        ),
      ],
    );
  }
}
