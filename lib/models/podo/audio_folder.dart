import 'package:cloud_firestore/cloud_firestore.dart';

class AudioFolder {
  late String id;
  late String name;
  late int totalContents;
  late String thumbnailUrl;
  late String description;
  late bool isSeries;

  AudioFolder(
      {required this.id,
      required this.name,
      required this.totalContents,
      required this.thumbnailUrl,
      required this.description,
      required this.isSeries});

  AudioFolder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    totalContents = json['total_contents'];
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    isSeries = json['isSeries'];
  }

  AudioFolder.fromFirebaseAudioFolderSnapshot(QueryDocumentSnapshot<Object?> doc) {
    id = doc['id'] ?? '';
    name = doc['name'] ?? '';
    thumbnailUrl = doc['thumbnailUrl'] ?? '';
    description = doc['description'] ?? '';
    totalContents = doc['totalContents'] ?? '';
    isSeries = doc['isSeries'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['total_contents'] = this.totalContents;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['description'] = this.description;
    data['isSeries'] = this.isSeries;
    return data;
  }
}
