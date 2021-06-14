import 'package:flutter/material.dart';
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
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
  late Future<List<Audio>> audioListFuture =
      fetchAudios('https://mocki.io/v1/00c25346-891a-4a2a-987e-4a9c1a6c637e');

  AudioFolderScreen(AudioFolder audioFolder) {
    this.audioFolder = audioFolder;
    // this.audioListFuture = fetchAudios(this.audioFolder.contentUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // body: AudioListPage(this.audioListFuture),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Audio>>(
                future: this.audioListFuture,
                builder: (context, snapshot) {
                  Widget audioListSliver;
                  if (snapshot.hasData) {
                    // return Text(snapshot.data!.title);
                    audioListSliver = Container(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AudioListScreenRow(
                                audio: snapshot.data![index],
                                favoriteAudiosBox: favoriteAudiosBox,
                              );
                            }));
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
                                        '${this.audioFolder.name}',
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
                              return AudioListScreenRow(
                                audio: snapshot.data?[index],
                                favoriteAudiosBox: favoriteAudiosBox,
                              );
                            },
                            childCount: snapshot.data?.length,
                          ),
                        ),
                      ],
                    );
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
    );
  }
}
