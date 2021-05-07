import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram/firebase/posts/post_model.dart';
import 'package:college_gram/firebase/users/user_model.dart';

class PostCollection {
  CollectionReference postsReference =
      FirebaseFirestore.instance.collection('posts');

  Stream<QuerySnapshot> retrieveAllPost() {
    return postsReference.snapshots();
  }

  Future<void> addPost(PostModel post) {
    // Call the user's CollectionReference to add a new user
    return postsReference
        .doc(post.id)
        .set(post.toMap())
        .then((value) => print("Post saved to firestore"))
        .catchError(
            (error) => print("Failed to save new post to firestore: $error"));
  }

  Stream<QuerySnapshot> getProfilePost(String id) {
    return postsReference.where("owner", isEqualTo: id).snapshots();
  }
}
