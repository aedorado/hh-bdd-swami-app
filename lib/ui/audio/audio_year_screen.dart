import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/models/podo/audio_folder.dart';
import 'package:hh_bbds_app/ui/audio/audio_folder_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';
import 'package:hh_bbds_app/network/remote_config.dart';

class AudioYearList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List yearsList = RemoteConfigService.getAudioYears() ?? [];
    return ListView.builder(
        itemCount: yearsList.length,
        itemBuilder: (BuildContext content, int index) {
          return ListTile(
            title: Text('${yearsList[index]}', style: TextStyle(fontSize: 24.0)),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AudioYearScreen(yearsList[index])));
            },
          );
        });
  }
}

class AudioYearScreen extends StatelessWidget {
  late int year;
  late Stream<QuerySnapshot<Map<String, dynamic>>> ssy;

  AudioYearScreen(year) {
    this.year = year;
    this.ssy = FirebaseFirestore.instance.collection("audios").where("year", isEqualTo: year.toString()).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // body: AudioListPage(this.audioListFuture),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: this.ssy,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return AudioFolderScreenSliverList(
                        AudioFolder(
                            id: "${this.year}",
                            name: "${this.year}",
                            totalContents: "${snapshot.data?.size}",
                            description: "All audios from the year ${this.year}.",
                            thumbnailUrl: "https://vrindavandarshan.in/upload_images/dailydarshan/2021-06-01-Mycnz.jpg"),
                        snapshot);
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
