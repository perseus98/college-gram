import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/screens/accounts/auth_screen.dart';
import 'package:college_gram/widgets/error_widget.dart';
import 'package:college_gram/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

import '../firebase/posts/post_model.dart';

class PostWidget extends StatelessWidget {
  final PostModel postModel;
  PostWidget(this.postModel);
  @override
  Widget build(BuildContext context) {
    print("Feed image => ${postModel.imageUrl}");
    return Container(
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
