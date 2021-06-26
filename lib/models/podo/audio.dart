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

  Audio({required this.id, required this.name, required this.url});

  Audio.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['id'];
    name = json['name'] ?? json['name'];
    url = json['url'] ?? json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }

  @override
  String toString() {
    return 'Id: ${this.id} Name: ${this.name}, URL: ${this.url}';
  }
}
