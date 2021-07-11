import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  late String id;
  late DateTime date;
  late String content;
  late String title;
  late String image;

  Blog({required this.id, required this.content, required this.title, required this.date, required this.image});

  Blog.fromFirebaseMessage(QueryDocumentSnapshot<Object?> doc) {
    this.id = doc['id'] ?? '';
    this.date = doc['date'].toDate();
    this.content = doc['content'] ?? '';
    this.title = doc['title'] ?? '';
    this.image = doc['image'] ?? '';
  }
}
