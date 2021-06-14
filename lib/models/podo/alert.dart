import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'alert.g.dart';

@HiveType(typeId: 1)
class Alert {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String link;

  @HiveField(2)
  late String type;

  @HiveField(3)
  late int receivedAt;

  @HiveField(4)
  late String title;

  @HiveField(5)
  late String subtitle;

  Alert(
      {required this.id,
      required this.link,
      required this.title,
      required this.subtitle,
      required this.type,
      required this.receivedAt});

  bool canBeDisplayed() {
    String typeLC = this.type.toLowerCase();
    if (typeLC != "zoom" && typeLC != "youtube" && typeLC != "facebook") {
      return false;
    }
    return true;
  }

  // fromFirebaseMessage assumes receivedAt time is supposed to be determined
  Alert.fromFirebaseMessage(String? id, Map<String, dynamic> json) {
    this.id = id ?? Uuid().v4();
    link = json['link'] ?? '';
    type = json['type'];
    title = json['title'];
    subtitle = json['subtitle'] ?? '';
    receivedAt = DateTime.now().millisecondsSinceEpoch;
  }

  // fromJson assumes that all relevant fields are present
  Alert.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    type = json['type'];
    title = json['title'];
    subtitle = json['subtitle'] ?? '';
    receivedAt = json['receivedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['link'] = this.link;
    data['type'] = this.type;
    data['receivedAt'] = this.receivedAt;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    return data;
  }
}
