import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _AUDIO_YEARS = 'audio_years';
const String _SSRSS_IMAGES_UNIQUE_COLORS = 'ssrss_images_unique_colors';
const String _MAHARAJA_IMAGES_UNIQUE_PLACES = 'maharaja_images_unique_places';

class RemoteConfigService {
  static late RemoteConfig remoteConfig;

  static List? getAudioYears() {
    Map<String, dynamic> rcMap = json.decode(remoteConfig.getValue(_AUDIO_YEARS).asString());
    return rcMap["data"];
  }

  static List? getSsrssImagesColorsList() {
    Map<String, dynamic> rcMap = json.decode(remoteConfig.getValue(_SSRSS_IMAGES_UNIQUE_COLORS).asString());
    return rcMap["data"];
  }

  static List? getMaharajaImagesPlacesList() {
    Map<String, dynamic> rcMap = json.decode(remoteConfig.getValue(_MAHARAJA_IMAGES_UNIQUE_PLACES).asString());
    return rcMap["data"];
  }

  static Future<RemoteConfig> setupRemoteConfigAsync() async {
    remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 60),
      minimumFetchInterval: const Duration(minutes: 15),
    ));
    await remoteConfig.setDefaults(<String, dynamic>{
      _AUDIO_YEARS: json.encode("{\"data\":[]}"),
      _SSRSS_IMAGES_UNIQUE_COLORS: json.encode("{\"data\":[]}"),
      _MAHARAJA_IMAGES_UNIQUE_PLACES: json.encode("{\"data\":[]}"),
    });
    await remoteConfig.fetchAndActivate();
    RemoteConfigValue(null, ValueSource.valueStatic);
    return remoteConfig;
  }
}
