import 'package:hh_bbds_app/models/podo/audio_folder.dart';

class AudioFolderResponse {
  int totalFolders;
  List<AudioFolder> audioFolders;

  AudioFolderResponse({this.totalFolders, this.audioFolders});

  AudioFolderResponse.fromJson(Map<String, dynamic> json) {
    totalFolders = json['total_folders'];
    if (json['audio_folders'] != null) {
      List<AudioFolder> audioFolders = [];
      json['audio_folders'].forEach((v) {
        audioFolders.add(new AudioFolder.fromJson(v));
      });
      this.audioFolders = audioFolders;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_folders'] = this.totalFolders;
    if (this.audioFolders != null) {
      data['audio_folders'] = this.audioFolders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
