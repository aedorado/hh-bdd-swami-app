import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'gallery_image.g.dart';

@HiveType(typeId: 2)
class GalleryImage {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String date;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late String displayURL;

  @HiveField(4)
  late String downloadURL;

  @HiveField(5)
  late String thumbnailURL;

  @HiveField(6)
  late String tags;

  @HiveField(7)
  late String group;

  @HiveField(8)
  late bool isRss;

  @HiveField(9)
  late int order;

  GalleryImage(
      {required this.id,
      required this.date,
      required this.description,
      required this.displayURL,
      required this.downloadURL,
      required this.thumbnailURL,
      required this.tags});

  GalleryImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    group = json['group'];
    isRss = json['isRss'];
    date = json['date'];
    description = json['description'];
    displayURL = json['display_url'];
    downloadURL = json['download_url'];
    thumbnailURL = json['thumbnail_url'];
    order = json['order'];
    tags = json['tags'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group'] = this.group;
    data['date'] = this.date;
    data['description'] = this.description;
    data['display_url'] = this.displayURL;
    data['download_url'] = this.downloadURL;
    data['thumbnail_url'] = this.thumbnailURL;
    data['isRss'] = this.isRss;
    data['tags'] = this.tags;
    data['order'] = this.order;
    return data;
  }

  GalleryImage.fromFireBaseSnapshotDoc(QueryDocumentSnapshot<Object?> doc) {
    id = doc['id'] ?? '';
    description = doc['description'] ?? '';
    group = doc['group'] ?? '';
    isRss = doc['is_rss'] ?? '';
    date = doc['date'] ?? '';
    displayURL = doc['display_url'] ?? '';
    downloadURL = doc['download_url'] ?? '';
    thumbnailURL = doc['thumbnail_url'] ?? '';
    order = doc['order'] ?? '';
    tags = doc['tags'] ?? '';
  }
}
