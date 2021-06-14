import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _AUDIO_YEARS = 'audio_years';

class RemoteConfigService {
  static late RemoteConfig remoteConfig;

  static List? getAudioYears() {
    Map<String, dynamic> rcMap =
        json.decode(remoteConfig.getValue(_AUDIO_YEARS).asString());
    return rcMap["years"];
  }

  static Future<RemoteConfig> setupRemoteConfigAsync() async {
    remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 30),
      minimumFetchInterval: const Duration(hours: 72),
    ));
    await remoteConfig.setDefaults(<String, dynamic>{
      _AUDIO_YEARS: json.encode("{\"years\":[2020]}"),
    });
    await remoteConfig.fetchAndActivate();
    RemoteConfigValue(null, ValueSource.valueStatic);
    return remoteConfig;
  }
}
