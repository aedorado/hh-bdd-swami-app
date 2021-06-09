import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class BoardApp extends StatefulWidget {
  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var snapshot = FirebaseFirestore.instance.collection("board").snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshot,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return new ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              return Text('${snapshot.data!.docs[index]['title']}');
            });
      }
    );
  }
}
