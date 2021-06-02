import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/change_notifiers/audio_queue.dart';
import 'package:hh_bbds_app/change_notifiers/current_audio.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/ui/home/home.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive..init(document.path)..registerAdapter(AudioAdapter());
  await Hive.openBox<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
  // Hive.box<Audio>(HIVE_BOX_FAVORITE_AUDIOS).deleteFromDisk();
  runApp(BDDSApp());
}

class BDDSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentAudio>(
          create: (_) => CurrentAudio(),
        ),
        ChangeNotifierProvider<AudioQueue>(
          create: (_) => AudioQueue(),
        ),
      ],
      child: MaterialApp(
          home: AudioServiceWidget(child: Home())
      ),
    );

    // return ChangeNotifierProvider(
    //   create: (context) => CurrentAudio(),
    //   child: MaterialApp(home: Home()),
    // );
  }
}

