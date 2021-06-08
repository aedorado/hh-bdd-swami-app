import 'package:hh_bbds_app/models/podo/audio.dart';

class AudioResponse {
  late int totalAudios;
  late List<Audio> audios;

  AudioResponse({required this.totalAudios, required this.audios});

  AudioResponse.fromJson(Map<String, dynamic> json) {
    totalAudios = json['total_audios'];
    if (json['audios'] != null) {
      List<Audio> audios = [];
      json['audios'].forEach((v) {
        audios.add(new Audio.fromJson(v));
      });
      this.audios = audios;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_audios'] = this.totalAudios;
    data['audios'] = this.audios.map((v) => v.toJson()).toList();
    return data;
  }
}
