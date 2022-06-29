import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String content; // The typed message or the url of the image
  final Timestamp createdAt; // Timestamp of message
  final String creator; // User id of the creator

  Post(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.creator});

  factory Post.fromJson(String id, Map<String, dynamic> data) {
    return Post(
        id: id,
        content: data["content"],
        createdAt: data["createdAt"],
        creator: data["creator"]);
  }

  Map<String, dynamic> toJSON() {
    return {"content": content, "createdAt": createdAt, "creator": creator};
  }
}
