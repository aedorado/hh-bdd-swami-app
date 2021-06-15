import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/alert.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/network/remote_config.dart';
import 'package:hh_bbds_app/ui/home/home.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// For backgournd, this fucntion initialized the background app
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up : ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp();

  // Push Notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Remote Config
  await RemoteConfigService.setupRemoteConfigAsync();

  // Local Storage
  Directory document = await getApplicationDocumentsDirectory();
  Hive
    ..init(document.path)
    ..registerAdapter(AudioAdapter())
    ..registerAdapter(AlertAdapter());

  await Hive.openBox<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
  await Hive.openBox<Alert>(HIVE_BOX_ALERTS);
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BDDSApp(),
  ));
}

class BDDSApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _BDDSAppState createState() => _BDDSAppState();
}

class _BDDSAppState extends State<BDDSApp> {
  int _homeScreenSelectedScreen = 0;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
        Box<Alert> alertsBox = Hive.box<Alert>(HIVE_BOX_ALERTS);
        alertsBox.put(message.messageId,
            Alert.fromFirebaseMessage(message.messageId, message.data));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        // showDialog(
        //     context: context,
        //     builder: (_) {
        //       return AlertDialog(
        //         title: Text(notification.title ?? ''),
        //         content: SingleChildScrollView(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [Text(notification.body ?? '')],
        //           ),
        //         ),
        //       );
        //     });
        Box<Alert> alertsBox = Hive.box<Alert>(HIVE_BOX_ALERTS);
        alertsBox.put(message.messageId,
            Alert.fromFirebaseMessage(message.messageId, message.data));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Home(selectedIndex: 3)));
        setState(() {
          _homeScreenSelectedScreen = 3;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Home(
      selectedIndex: this._homeScreenSelectedScreen,
    );
  }
}
