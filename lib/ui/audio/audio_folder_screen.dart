import 'package:flutter/material.dart';
import 'package:hh_bbds_app/change_notifiers/audio_queue.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/middleware/audio_queue_interface.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/podo/audio_folder.dart';
import 'package:hh_bbds_app/network/audio.dart';
import 'package:hh_bbds_app/ui/audio/audio_list_screen.dart';
import 'package:hh_bbds_app/ui/audio/audio_play_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:provider/provider.dart';

class AudioFolderScreen extends StatelessWidget {

  AudioFolder audioFolder;
  String contentUrl;
  Box<Audio> favoriteAudiosBox = Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
  Future<List<Audio>> audioListFuture; // = fetchAudios('https://mocki.io/v1/00c25346-891a-4a2a-987e-4a9c1a6c637e');

  AudioFolderScreen(AudioFolder audioFolder) {
    this.audioFolder = audioFolder;
    this.audioListFuture = fetchAudios(this.audioFolder.contentUrl);
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
                          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AudioListScreenRow(audio: snapshot.data[index], favoriteAudiosBox: favoriteAudiosBox,);
                          }
                        )
                      );
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
                                  child: Image.network("https://vrindavandarshan.in/upload_images/dailydarshan/2021-06-01-Mycnz.jpg",
                                    fit: BoxFit.cover,
                                  )
                                ),
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: 8,
                                  right: 24,
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF004BA0),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Consumer2<AudioQueue, CurrentAudio>(
                                      builder: (context, audioQueue, currentAudio, child) => InkWell(
                                        onTap: () {
                                          AudioQueueInterface(audioQueue, currentAudio).playAudioFolder(snapshot.data);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AudioPlayScreen()));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Center(child: Icon(Icons.play_arrow, size: 36, color: Colors.white,)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(flex: 3, child: Text('${this.audioFolder.name}', style: TextStyle(fontSize: 24),)),
                                          Expanded(flex: 1, child: Container())
                                        ],
                                      ),
                                      Text('A series on spiritual connection between a disciple and their spiritual master', style: TextStyle(fontSize: 14),),
                                    ],
                                  ),
                                ),
                              ]
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return AudioListScreenRow(audio: snapshot.data[index], favoriteAudiosBox: favoriteAudiosBox,);
                              },
                              childCount: snapshot.data.length, // 1000 list items
                            ),
                          ),
                        ],
                      );
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
    );
  }
}
