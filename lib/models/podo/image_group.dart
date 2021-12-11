import 'package:cloud_firestore/cloud_firestore.dart';

class ImageGroup {
  late String groupName;

  late bool isRss;

  late List subgroupsList;

  ImageGroup(
      {required this.groupName,
      required this.isRss,
      required this.subgroupsList});

  ImageGroup.fromJson(Map<String, dynamic> json) {
    groupName = json['group_name'];
    isRss = json['is_rss'];
    subgroupsList = json['subgroups_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_name'] = this.groupName;
    data['is_rss'] = this.isRss;
    data['subgroups_list'] = this.subgroupsList;
    return data;
  }

  ImageGroup.fromFireBaseSnapshotDoc(QueryDocumentSnapshot<Object?> doc) {
    groupName = doc['group_name'] ?? '';
    isRss = doc['is_rss'] ?? '';
    subgroupsList = doc['subgroups_list'] ?? '';
  }
}
