import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram/firebase/posts/post_model.dart';
import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/screens/accounts/auth_screen.dart';
import 'package:flutter/material.dart';

import 'error_widget.dart';
import 'loading_widget.dart';

class ProfilePostWidget extends StatelessWidget {
  final PostModel postModel;
  final bool gridView;
  ProfilePostWidget(this.postModel, this.gridView);
  @override
  Widget build(BuildContext context) {
    return gridView
        ? Container(
            height: 50.0,
            width: 50.0,
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.black38,
            ),
            child: Image.network(
              postModel.imageUrl,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
              width: 400.0,
              height: 400.0,
              fit: BoxFit.fitWidth,
            ),
          )
        : Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Column(
              children: [
                retrieveOwnerData(),
                Image.network(
                  postModel.imageUrl,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 400.0,
                      height: 400.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                  width: 400.0,
                  height: 400.0,
                  fit: BoxFit.fitWidth,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      postModel.caption,
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    )),
                  ],
                )
              ],
            ),
          );
  }

  Widget retrieveOwnerData() => FutureBuilder<DocumentSnapshot>(
        future: userCollection.retrieveUserData(postModel.owner),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MyCustomErrorWidget(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data.data());
            UserModel userModel =
                UserModel.fromDocDataMap(snapshot.data.data());
            return Row(
              children: [
                Image.network(
                  userModel.photoURL ?? "https://via.placeholder.com/150",
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 20.0,
                      height: 20.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.fill,
                ),
                Text(userModel.name),
              ],
            );
          }
          return LoadingWidget();
        },
      );
}
