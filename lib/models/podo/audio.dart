import 'package:hive/hive.dart';

part 'audio.g.dart';

@HiveType(typeId: 0)
class Audio {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String url;

  @HiveField(3)
  late String thumbnailUrl;

  Audio({required this.id, required this.name, required this.url, required this.thumbnailUrl});

  Audio.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['id'];
    name = json['name'] ?? json['name'];
    url = json['url'] ?? json['url'];
    url = json['thumbnailUrl'] ?? json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['thumbnailUrl'] = this.thumbnailUrl;
    return data;
  }

  @override
  String toString() {
    return 'Id: ${this.id} Name: ${this.name}, URL: ${this.url}, Thumbnai: ${this.thumbnailUrl}';
  }
}
