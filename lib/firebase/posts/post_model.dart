import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String caption;
  String imageUrl;
  PostModel(this.id, this.imageUrl, this.caption);
  factory PostModel.fromFirebaseAuthUser(DocumentSnapshot post) {
    return PostModel(post['id'], post['caption'], post['imageUrl']);
  }

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>.of({
      'id': id,
      'caption': caption,
      'imageUrl': imageUrl,
    });
  }
}
