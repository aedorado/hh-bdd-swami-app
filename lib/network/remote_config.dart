import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hh_bbds_app/assets/constants.dart';

const String _AUDIO_YEARS = 'audio_years';
const String _LATEST_APP_VERSION = 'latest_app_version';

class RemoteConfigService {
 static late RemoteConfig remoteConfig;

 static List? getAudioYears() {
   Map<String, dynamic> rcMap = json.decode(remoteConfig.getValue(_AUDIO_YEARS).asString());
   return rcMap["data"];
 }

 static int getLatestAppVersion() {
   String rcString = remoteConfig.getString(_LATEST_APP_VERSION);
   return int.parse(rcString);
 }

 static Future<RemoteConfig> setupRemoteConfigAsync() async {
   remoteConfig = RemoteConfig.instance;
   await remoteConfig.setConfigSettings(RemoteConfigSettings(
     fetchTimeout: const Duration(seconds: 60),
     minimumFetchInterval: const Duration(minutes: 15),
   ));
   await remoteConfig.setDefaults(<String, dynamic>{
     _AUDIO_YEARS: json.encode("{\"data\":[]}"),
     _LATEST_APP_VERSION: CURRENT_APP_VERSION,
   });
   await remoteConfig.fetchAndActivate();
   RemoteConfigValue(null, ValueSource.valueStatic);
   return remoteConfig;
 }
}


