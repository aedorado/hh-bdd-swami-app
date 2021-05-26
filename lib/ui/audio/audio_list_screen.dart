import 'package:flutter/material.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/network/audio.dart';

class AudioListScreen extends StatefulWidget {
  @override
  _AudioListScreenState createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {

  String audioUrl = "https://mocki.io/v1/6817415e-fc15-4ed5-b6a2-e811e45802f5";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Audio>>(
        future: fetchAudios(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return Text(snapshot.data!.title);
            return Container(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      debugPrint('Index: $index');
                      return Text('${snapshot.data[index].name}');
                    }
                )
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }




}
