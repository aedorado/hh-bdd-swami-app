import 'package:cloud_firestore/cloud_firestore.dart';

class AudioFolder {
  late String id;
  late String name;
  late String totalContents;
  late String thumbnailUrl;
  late String description;

  AudioFolder({required this.id, required this.name, required this.totalContents, required this.thumbnailUrl, required this.description});

  AudioFolder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    totalContents = json['total_contents'];
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
  }

  AudioFolder.fromFirebaseAudioFolderSnapshot(QueryDocumentSnapshot<Object?> doc) {
    id = doc['id'] ?? '';
    name = doc['name'] ?? '';
    thumbnailUrl = doc['thumbnailUrl'] ?? '';
    description = doc['description'] ?? '';
    totalContents = doc['totalContents'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['total_contents'] = this.totalContents;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['description'] = this.description;
    return data;
  }
}
