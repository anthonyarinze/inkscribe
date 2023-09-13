import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String title;
  final String text;
  final Timestamp timestamp;
  final String id;
  final int color;

  Comment(this.title, this.text, this.timestamp, this.id, this.color);
}
