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

  @HiveField(4)
  late String namePlainText;

  Audio(
      {required this.id,
      required this.name,
      required this.url,
      required this.namePlainText,
      required this.thumbnailUrl});

  Audio.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['id'];
    name = json['name'] ?? json['name'];
    url = json['url'] ?? json['url'];
    thumbnailUrl = json['thumbnailUrl'] ?? json['thumbnailUrl'];
    namePlainText = json['namePlainText'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['namePlainText'] = this.namePlainText;
    return data;
  }

  @override
  String toString() {
    return 'Id: ${this.id} Name: ${this.name}, URL: ${this.url}, Thumbnail: ${this.thumbnailUrl}, NamePlainText: ${this.namePlainText}';
  }
}
