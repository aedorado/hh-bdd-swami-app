import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/ui/audio/audio_folder_screen.dart';
import 'package:hh_bbds_app/ui/audio/miniplayer.dart';

class AudioYearScreen extends StatelessWidget {
  late int year;
  late Stream<QuerySnapshot<Map<String, dynamic>>> ssy;

  AudioYearScreen(year) {
    this.year = year;
    this.ssy = FirebaseFirestore.instance
        .collection("audios")
        .where("year", isEqualTo: year.toString())
        .snapshots();
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
    );
  }
}
