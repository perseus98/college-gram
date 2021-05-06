import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram/firebase/posts/post_collection.dart';
import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/widgets/error_widget.dart';
import 'package:flutter/material.dart';

PostCollection postCollection = PostCollection();
class FeedScreen extends StatelessWidget {
  final UserModel currentUser;
  FeedScreen(this.currentUser);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: postCollection.retrieveAllPost(),
        builder: (context,snapshots){
        if(snapshots.hasError){
          return MyCustomErrorWidget(snapshots.error);
        }
        if(ConnectionState.active == snapshots.connectionState){
          return Text("Done");
        }
        return Text("none");
        }
    );
  }
}
