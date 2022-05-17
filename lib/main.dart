import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hh_bbds_app/assets/constants.dart';
import 'package:hh_bbds_app/models/podo/gallery_image.dart';
import 'package:hh_bbds_app/models/podo/alert.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/podo/quote.dart';
import 'package:hh_bbds_app/network/remote_config.dart';
import 'package:hh_bbds_app/services/service_locator.dart';
import 'package:hh_bbds_app/ui/audio/page_manager.dart';
import 'package:hh_bbds_app/ui/calendar/view_event.dart';
import 'package:hh_bbds_app/ui/home/home.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
   'high_importance_channel', // id
   'High Importance Notifications', // title
   importance: Importance.max,
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
     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
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
   ..registerAdapter(AlertAdapter())
   ..registerAdapter(QuoteAdapter())
   ..registerAdapter(GalleryImageAdapter());

 await Hive.openBox<Audio>(HIVE_BOX_FAVORITE_AUDIOS);
 await Hive.openBox<Quote>(HIVE_BOX_FAVORITE_QUOTES);
 await Hive.openBox<Alert>(HIVE_BOX_ALERTS);
 await Hive.openBox(HIVE_BOX_AUDIO_SEARCH);
 await Hive.openBox(HIVE_BOX_NOTIFICATIONS_LIST);
 await Hive.openBox(HIVE_BOX_FAVORITE_BLOGS);
 await Hive.openBox<GalleryImage>(HIVE_BOX_FAVORITE_IMAGES);

 await setupServiceLocator();

 runApp(MaterialApp(
   title: 'HH BDD Swami',
   theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Nunito'),
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

 // saveAlert(RemoteMessage message) {
 //   Box<Alert> alertsBox = Hive.box<Alert>(HIVE_BOX_ALERTS);
 //   alertsBox.put(message.messageId, Alert.fromFirebaseMessage(message.messageId, message.data));
 // }

 // checkForInitialMessage() async {
 //   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
 //   if (initialMessage != null) {
 //     saveAlert(initialMessage);
 //     setState(() {
 //       this._homeScreenSelectedScreen = 2;
 //     });
 //   }
 // }

 isAppLaunchedByNotification() async {
   NotificationAppLaunchDetails? notificationAppLaunchDetails =
       await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
   if (notificationAppLaunchDetails != null) {
     final notificationLaunchedApp = notificationAppLaunchDetails.didNotificationLaunchApp;
     if (notificationLaunchedApp)
       return onSelectNotification(notificationAppLaunchDetails.payload);
   }
 }

 Future onSelectNotification(String? payload) {
   try {
     if (null != payload && payload.length > 0) {
       Map<String, dynamic> payloadMap = jsonDecode(payload);
       if (payloadMap['type'] as String == 'events') {
         // debugPrint(payloadMap.toString());
         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) => ViewEvent(
                       eventId: payloadMap['id'],
                     )));
       }
     } else {
       debugPrint('Payload else: ' + (payload == null).toString());
       debugPrint('Payload else: ' + (payload!.length).toString());
     }
   } on Exception catch (e) {
     debugPrint(e.toString());
     return Future<int>.value(0);
   }
   return Future<int>.value(0);
 }


 @override
 void initState() {
   super.initState();
   // If app was opened by a PN when app was in the background
   // checkForInitialMessage();

   var initializationSettingsAndroid = new AndroidInitializationSettings('ic_launcher');
   var initializationSettingsIOS = new IOSInitializationSettings();
   var initializationSettings = new InitializationSettings(
       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
   flutterLocalNotificationsPlugin.initialize(initializationSettings,
       onSelectNotification: onSelectNotification);

   // Notification recieved when app is in foreground
   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
   //   RemoteNotification notification = message.notification!;
   //   AndroidNotification android = message.notification!.android!;
   //   print('A new onMessage event was published!');
   //   if (notification != null && android != null) {
   //     flutterLocalNotificationsPlugin.show(
   //       notification.hashCode,
   //       notification.title,
   //       notification.body,
   //       NotificationDetails(
   //         android: AndroidNotificationDetails(
   //           channel.id,
   //           channel.name,
   //           color: Colors.blue,
   //           playSound: true,
   //           importance: Importance.max,
   //           icon: '@mipmap/ic_launcher',
   //         ),
   //       ),
   //     );
   //     saveAlert(message);
   //   }
   // });
   //
   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
   //   print('A new onMessageOpenedApp event was published!');
   //   RemoteNotification notification = message.notification!;
   //   AndroidNotification android = message.notification!.android!;
   //   if (notification != null && android != null) {
   //     saveAlert(message);
   //     setState(() {
   //       _homeScreenSelectedScreen = 3;
   //     });
   //   }
   // });

   getIt<PageManager>().init();

   isAppLaunchedByNotification();
 }

 @override
 void dispose() {
   getIt<PageManager>().dispose();
   super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   int latestAppVersion = RemoteConfigService.getLatestAppVersion();
   if (latestAppVersion > CURRENT_APP_VERSION) {
     return Container(
       child: Text('You are using an outdated app, please update the app to continue using it. Hare Krishna!'),
     );
   }
   debugPrint('${latestAppVersion}');
   return Home(
     selectedIndex: this._homeScreenSelectedScreen,
   );
 }
}


