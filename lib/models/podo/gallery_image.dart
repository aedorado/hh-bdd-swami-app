import 'package:hive/hive.dart';

part 'gallery_image.g.dart';

@HiveType(typeId: 2)
class GalleryImage {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String albumID;

  @HiveField(2)
  late String color;

  @HiveField(3)
  late String date;

  @HiveField(4)
  late String description;

  @HiveField(5)
  late String displayURL;

  @HiveField(6)
  late String downloadURL;

  @HiveField(7)
  late String thumbnailURL;

  @HiveField(8)
  late String location;

  @HiveField(9)
  late String tags;

  @HiveField(10)
  late String type;

  GalleryImage(
      {required this.id,
      required this.albumID,
      required this.color,
      required this.date,
      required this.description,
      required this.displayURL,
      required this.downloadURL,
      required this.thumbnailURL,
      required this.location,
      required this.tags,
      required this.type});

  GalleryImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumID = json['album_id'];
    color = json['color'];
    date = json['date'];
    description = json['description'];
    displayURL = json['display_url'];
    downloadURL = json['download_url'];
    thumbnailURL = json['thumbnail_url'];
    location = json['location'];
    tags = json['tags'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['album_id'] = this.albumID;
    data['color'] = this.color;
    data['date'] = this.date;
    data['description'] = this.description;
    data['display_url'] = this.displayURL;
    data['download_url'] = this.downloadURL;
    data['thumbnail_url'] = this.thumbnailURL;
    data['location'] = this.location;
    data['tags'] = this.tags;
    data['type'] = this.type;
    return data;
  }
}
