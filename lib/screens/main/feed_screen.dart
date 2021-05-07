import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram/firebase/posts/post_collection.dart';
import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/widgets/error_widget.dart';
import 'package:college_gram/widgets/loading_widget.dart';
import 'package:college_gram/widgets/post_widget.dart';
import 'package:flutter/material.dart';

import '../../firebase/posts/post_model.dart';

PostCollection postCollection = PostCollection();

class FeedScreen extends StatelessWidget {
  final UserModel currentUser;
  FeedScreen(this.currentUser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Feed Screen"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: postCollection.retrieveAllPost(),
          builder: (context, snapshots) {
            if (snapshots.hasError) {
              return MyCustomErrorWidget(snapshots.error);
            }
            if (ConnectionState.active == snapshots.connectionState) {
              if (snapshots.data.size == 0)
                return Center(
                  child: Text(
                    "No posts, has been added, add some to see here",
                    softWrap: true,
                  ),
                );
              return ListView.separated(
                itemCount: snapshots.data.size,
                itemBuilder: (context, index) {
                  return PostWidget(
                      PostModel.fromDocument(snapshots.data.docs[index]));
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black38,
                    endIndent: 20.0,
                    indent: 20.0,
                    thickness: 5.0,
                  );
                },
              );
            }
            return LoadingWidget();
          }),
    );
  }
}
