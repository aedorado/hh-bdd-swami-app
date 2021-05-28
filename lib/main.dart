import 'package:flutter/material.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/ui/home/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(BDDSApp());

class BDDSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentAudio(),
      child: MaterialApp(home: Home()),
    );
  }
}

