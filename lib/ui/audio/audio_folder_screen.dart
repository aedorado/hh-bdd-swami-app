import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/adapter/adapter.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/podo/audio_folder.dart';
import 'package:hh_bbds_app/network/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hive/hive.dart';
import 'package:hh_bbds_app/assets/constants.dart';

class AudioFolderScreen extends StatelessWidget {
  late AudioFolder audioFolder;
  late Stream<QuerySnapshot<Map<String, dynamic>>> ssy;

  AudioFolderScreen(AudioFolder audioFolder) {
    // TODO remove series hardcoding from here
    this.audioFolder = audioFolder;
    this.ssy = FirebaseFirestore.instance
        .collection("audios")
        .where("series", isEqualTo: this.audioFolder.id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColoredBox(
        // TODO change to default scaffold color
        color: Colors.white,
        child: Scaffold(
          // body: AudioListPage(this.audioListFuture),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: this.ssy,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      debugPrint('SNAP SIZE: ${snapshot.data!.size}');
                      return AudioFolderScreenSliverList(snapshot);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                        child: Container(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator()));
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

  AudioFolderScreenSliverList(snapshot) {
    debugPrint('AudioFolderScreenSliverList: ${snapshot.data!.size}');
    debugPrint('${snapshot.data!.size}');
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
                "https://vrindavandarshan.in/upload_images/dailydarshan/2021-06-01-Mycnz.jpg",
                fit: BoxFit.cover,
              )),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Stack(clipBehavior: Clip.none, children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        'TITLE',
                        style: TextStyle(fontSize: 24),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      'A series on spiritual connection between a disciple and their spiritual master',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Audio audio = Adapter.firebaseAudioSnapshotToAudio(
                  this.snapshot.data!.docs[index]);
              return AudioListScreenRow(
                audio: audio,
                favoriteAudiosBox: favoriteAudiosBox,
              );
            },
            childCount: this.snapshot.data!.size,
          ),
        ),
      ],
    );
  }
}
