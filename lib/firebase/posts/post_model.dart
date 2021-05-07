import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram/firebase/users/user_model.dart';

class PostModel {
  String id;
  String owner;
  String caption;
  String imageUrl;
  PostModel({this.id, this.owner, this.imageUrl, this.caption});

  factory PostModel.fromDocument(QueryDocumentSnapshot post) {
    return PostModel(
      id: post['id'],
      owner: post['owner'],
      imageUrl: post['imageUrl'],
      caption: post['caption'],
    );
  }

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>.of({
      'id': id,
      'owner': owner,
      'caption': caption,
      'imageUrl': imageUrl,
    });
  }
}
