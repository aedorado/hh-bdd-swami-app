import 'package:cloud_firestore/cloud_firestore.dart';

class ImageCategory {
  late String categoryName;

  late bool isRss;

  late List subcategoryList;

  ImageCategory(
      {required this.categoryName,
      required this.isRss,
      required this.subcategoryList});

  ImageCategory.fromJson(Map<String, dynamic> json) {
    categoryName = json['group_name'];
    isRss = json['is_rss'];
    subcategoryList = json['subgroups_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['is_rss'] = this.isRss;
    data['subcategories_list'] = this.subcategoryList;
    return data;
  }

  ImageCategory.fromFireBaseSnapshotDoc(QueryDocumentSnapshot<Object?> doc) {
    categoryName = doc['category_name'] ?? '';
    isRss = doc['is_rss'] ?? '';
    subcategoryList = doc['subcategories_list'] ?? '';
  }
}
