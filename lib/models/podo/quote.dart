import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'quote.g.dart';

@HiveType(typeId: 3)
class Quote {

 @HiveField(0)
 late String id;

 @HiveField(1)
 late String url;

 @HiveField(2)
 late String text;

 @HiveField(3)
 late String place;

 @HiveField(4)
 late String temple;

 @HiveField(5)
 late String location;

 @HiveField(6)
 late String date;

 @HiveField(7)
 late int order;

 Quote({required this.id, required this.url, required this.text, required this.place, required this.temple, required this.location, required this.date});

 Quote.fromJson(Map<String, dynamic> json) {
   id = json['id'] ?? json['id'];
   url = json['url'] ?? json['url'];
   date = json['date'] ?? json['date'];
   text = json['text'] ?? json['text'];
   place = json['place'] ?? json['place'];
   temple = json['temple'] ?? json['temple'];
   location = json['location'] ?? json['location'];
   order = int.parse(json['order']);
 }

 Quote.fromFirebaseDocumentSnapshot(QueryDocumentSnapshot<Object?> doc) {
   this.id = doc['id'] ?? '';
   this.date = doc['date'];
   this.url = doc['url'] ?? '';
   this.text = doc['text'] ?? '';
   this.place = doc['place'] ?? '';
   this.temple = doc['temple'] ?? '';
   this.location = doc['location'] ?? '';
   this.order = doc['order'] ?? '';
 }

 Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = new Map<String, dynamic>();
   data['id'] = this.id;
   data['url'] = this.url;
   data['date'] = this.date;
   data['text'] = this.text;
   data['order'] = this.order;
   data['place'] = this.place;
   data['temple'] = this.temple;
   data['location'] = this.location;
   return data;
 }

 @override
 String toString() {
   return 'Id: ${this.id} Url: ${this.url}, Date: ${this.date}, Order: ${this.order}, Text: ${this.text}, Place: ${this.place}, Temple: ${this.temple}, Location: ${this.location}';
 }
}
